# Chapter: Colors and Palettes for the Whittaker Diagram — Ideation Notes
_Captured 2026-05-15. Working title; final title to be set
when drafting begins._

## Status
Chapter proposed by Kim during the example-catalog working
session. He flagged palette work as substantive enough to
merit its own chapter, citing three concerns that converge
naturally on the topic: aesthetic value of a palette,
matching conventional appearance (light blue for tundra,
greens for forests), and color-blindness accessibility.
Suggested four or five (or more) variants would allow a
brief exploration.

## Placement
Position TBD in the chapter sequence. Natural candidates:

- **After Basic Whittaker Diagrams (Ch 5)** as a follow-on
  chapter on visualization choices. Reads well as
  "now that you can plot, here's how to choose how
  it looks."
- **Before Basic Whittaker Diagrams** as a setup chapter
  that establishes design choices the plotting code then
  honors. Reads well as "here's the palette landscape;
  now we'll plot."
- **As a section within Basic Whittaker Diagrams** if
  the chapter count would otherwise grow uncomfortably.

The chapter-status decision depends partly on how many
chapters end up in the final document — see related
proposed chapters in design_classification_to_mapping.md
and chapter_what_is_a_biome_ideas.md.

## The Five Threads

### 1. Why palette matters (the principle)
Palette is not decoration. It is part of how a
classification system communicates its categories.
Distinct colors that don't read as distinct have already
failed the categorization claim — if a viewer can't tell
two categories apart, the categories haven't been
communicated. Palette choice is therefore a substantive
design decision, not a stylistic afterthought. This
opening thread sets up the rest of the chapter's content
as serious work rather than aesthetic preference.

Connects to design file Thread 1 (display constraints):
palette is a display variable that, like polygon count,
constrains how many categories can be communicated.

### 2. The Ricklefs palette (origins and conventions)
The colors in the vendored data — and in plotbiomes and
the original Ricklefs textbook figure — are not arbitrary.
They follow cartographic and ecological color conventions
that go back through Whittaker, Holdridge, and earlier
biome mapmakers. Greens for forests (with darker greens
for wetter and tropical types). Yellows and tans for
arid biomes. Light blues and grays for tundra and cold
types. Olives and khakis for woodland/shrubland and
transitional types.

These conventions arose from cartographic tradition and
visual association with the landscape: a temperate forest
looks green from a plane, a desert looks tan from a
satellite. The palette is an iconic palette in the strict
sense — it visually resembles what it represents.

Chapter content: name the conventions, name their
sources, show the Ricklefs palette with its semantic
mapping table.

### 3. Color-blindness as a design constraint
About 8% of men and 0.5% of women have some form of color
vision deficiency, most commonly red-green (deuteranopia,
protanopia). The Ricklefs palette has a real CVD problem:
several of its greens are perceptually close even for
color-normal viewers, and the green-versus-yellow
distinction (temperate forest vs tropical seasonal /
savanna) collapses under common CVDs.

This thread sets up the design problem: how do you keep
the convention-following quality of the Ricklefs palette
while making it work for the 8%? Two paths:
- Modify the palette to be CVD-safer while preserving
  convention.
- Add secondary visual encoding (centroid labels) so
  color doesn't carry the whole load.

The chapter doesn't have to choose between these — it can
present both as legitimate complementary moves.

### 4. Point color: encoding data origin and ensuring visibility

Added 2026-05-15.

Color isn't only a palette question for biome polygons; it's
also a question for the data points placed on top of them.
Two distinct point-color use cases the chapter should cover:

**Encoding data origin.** A figure mixing WorldClim
retrievals with METAR observations, station data, or other
sources needs a visible distinction between point types.
This is partly an honesty move (different sources have
different temporal aggregation and spatial scale; pretending
they're equivalent is misleading) and partly an
interpretation move (the reader needs to know which kind of
data they're looking at to evaluate it correctly).

**Ensuring visibility against biome backgrounds.** Default
points are black-filled with white borders. On most biome
polygons this works; on dark-green tropical rain forest a
black fill nearly disappears, and on light-yellow
subtropical desert a white border nearly disappears. The
biome the data point lands on therefore constrains the
right border-and-fill choice. The chapter can show the
problem with side-by-side figures: same points, two
biomes' backgrounds, different visibility outcomes — then
the configurable border-and-fill solution.

Both use cases are supported by adding `point_color`
(border) and `point_fill` (interior) parameters to
`plot_biomes()`, each accepting a scalar or vector. The
chapter's example chunks can demonstrate both.

### 5. Secondary visual encoding (the centroid label move)
Already captured as a queued toolkit feature in
example_ideas.md. The chapter is where this gets
explained, not just implemented. Pattern: short label
(number 1-9, or two-letter abbreviation) at each
polygon's centroid, matched to a numbered or
abbreviated legend. Survives CVD, grayscale, photocopy,
and bad displays. The diagram becomes readable as a
two-encoding object: color (primary, aesthetic) and
label (secondary, robust).

Content: explain why redundant encoding is a design
strength rather than a redundancy waste. Cite Tufte's
data-ink principle conventionally and then push past it
— in accessibility contexts, redundancy IS the design.

### 6. Palette variants — a brief exploration
The chapter's central comparative move. Five candidate
palettes side-by-side, each rendered with the same
underlying Whittaker biome polygons:

1. **Original Ricklefs** — what we vendored. The
   historical baseline. Documents the convention.
2. **Color-blind safe (viridis-based or Paul Tol's
   qualitative)** — perceptually uniform under common
   CVDs. Breaks convention (no green-for-forest) but
   succeeds at the accessibility test.
3. **Conventional ecological textbook** — light blue
   tundra, graded greens for forests, tan/yellow for
   arid biomes. Optimized for reader recognition; what
   most ecology textbook figures look like. Lies
   between Ricklefs and CVD-safe.
4. **High-contrast / print-friendly** — survives
   grayscale conversion (different lightness values per
   biome). Optimized for media survival rather than
   on-screen aesthetics.
5. **Custom hand-tuned** — the design problem the
   chapter ends on. Balance CVD-safety, convention, and
   grayscale survival. This is the practical synthesis
   of threads 2, 3, and 4.

Each variant gets its own rendered Whittaker diagram
in the chapter (small multiple). The reader sees the
design tradeoffs visually rather than just reading about
them. Possible additional variant: an Okabe-Ito-based
palette for a maximum-CVD-safety baseline (only 8
colors, would need to combine two biomes — itself a
teachable point about palette capacity).

## Implementation — the plot_biomes(palette = ...) parameter

The chapter ends on a function-level deliverable: a
parameter on `plot_biomes()` that selects palette. Something
like:

```r
plot_biomes(..., palette = c("ricklefs", "viridis",
                             "textbook", "print",
                             "custom"))
```

With each palette stored as a named vector parallel to
`Ricklefs_colors` (loaded from project-local CSVs
parallel to `data/ricklefs_colors.csv`). Adding a new
palette becomes adding a CSV. Open question for
implementation: should the labels CSV change too if
biome names differ between palettes? Probably not —
biomes are biomes; only colors change.

## Key formulations to preserve verbatim

Kim's framing of the chapter scope:
> "There is the aesthetic value of a palette. There is
> also a concern to match the general appearance of the
> biomes (light blue for tundra). Color blindness is a
> concern we've touched on. I can see that four or five
> (maybe more) variants would allow a brief exploration."

## Provisional structure

- **Opening** — palette as substantive design
  (Thread 1).
- **Middle** — Ricklefs palette and conventions
  (Thread 2); CVD as a design constraint (Thread 3);
  secondary encoding (Thread 4).
- **Comparative exploration** — five variants
  side-by-side (Thread 5), with brief commentary on
  the tradeoffs each makes visible.
- **Closing turn** — the custom hand-tuned palette as
  the synthesis problem; the `plot_biomes(palette = ...)`
  function delivering the variants.

## Open questions

- Where in the chapter sequence (after Basic Whittaker
  Diagrams, before, or as a section within)?
- Final title — "Colors and Palettes," "Palettes for
  the Whittaker Diagram," "Designing the Color Scheme,"
  "The Look of a Biome Map" — TBD.
- Which CVD-safe palette to use as the canonical
  alternative — viridis-derived (smooth but breaks
  convention) vs Paul Tol's qualitative (jumpy but
  category-honest)?
- Whether the custom hand-tuned palette becomes the
  project's recommended default (replacing Ricklefs as
  the default in `plot_biomes()`) or stays as an
  option alongside the original.
- Should there be a sixth Okabe-Ito variant
  illustrating the capacity constraint (only 8 colors,
  must merge two biomes)?

## Next session — drafting checklist

1. Re-read this file.
2. Decide chapter placement and final title.
3. Generate the five palette renderings as small
   multiples — the comparative figure is the chapter's
   centerpiece.
4. Draft section by section, preserving Kim's framing
   verbatim where relevant.
5. Implement `plot_biomes(palette = ...)` and store
   each palette as a CSV in `data/` parallel to
   `ricklefs_colors.csv`.
6. Cross-reference with the centroid-label work; if
   that's also implemented by then, the chapter can
   show diagrams with both alternative palette AND
   centroid labels — a fully-accessible variant as
   the chapter's closing figure.

Estimated length when drafted: ~1,500–2,500 words
plus five-panel comparison figure plus closing
implementation example.
