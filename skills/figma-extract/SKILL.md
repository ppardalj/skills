---
name: figma-extract
description: "Extract tokens, structure and assets from a large Figma file via MCP. Use when a Figma frame is big (a whole page or artboard), or when deriving design tokens from a file without variables."
---

# Figma extract

Large frames break the Figma MCP: `get_design_context` on a page-sized frame returns megabytes,
`get_metadata` and full-size `get_screenshot` close the connection, and `use_figma` caps its
return at 20 KB. Work section by section.

## Steps

### 1. List the top-level frames

`use_figma` (read-only) returning `id`, `name`, size and direct children of the artboard.
Done when every page-level frame and its sections have an id.

### 2. Look before measuring

`get_screenshot` per section with `maxDimension` 1440 (full-frame shots of tall pages come out
unreadable), downloaded with `curl` into a fresh `/tmp` dir and opened with Read. Done when
every section has been seen. Glows, blurs and decorative layers show up here, not in the tree.

### 3. Serialize each section

Run one read-only `use_figma` per group of sections, in parallel, ids passed as a literal list.
Return a compact JSON string: per node `id`, type, name, size, auto-layout (direction, gap,
padding, alignment), fills, strokes, radius, effects, and for text the characters, font, size,
line height and letter spacing. Cap children per node (3-8) and stay under 20 KB per call.

Include vector and ellipse nodes that carry a fill, effect or blur: they are the decorative
backgrounds. Skip only vector internals of logos and icons. Done when every visible effect in
the step 2 screenshots maps to a serialized node.

### 4. Derive tokens

Check `getLocalVariableCollectionsAsync` and local styles first; a file with none has no
tokens, so tally colors, fonts and spacings from step 3 and name them. Gradient direction comes
from `gradientTransform`, not guesses.

### 5. Download assets

`download_assets` per icon or logo with `defaultFormat: "svg"`; prefer the `svgAssets` entries
over `export`, which can carry the surrounding frame. Done when no asset still points at a
temporary Figma URL.
