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

**Sharpened 2026-05-21 (framework confirmed with Kim).** The
principle has a sharper form, and it is the chapter's spine:
a tension between two jobs a palette must do. Informative —
the colors carry meaning; an iconic palette (green for
forest, tan for desert) recruits the reader's landscape
knowledge, so the color works before the legend. Useful —
every category is distinguishable for every reader in every
medium (color-vision deficiency, grayscale, dim projector).
The tension is genuine, not two goods to balance: the
features that make a palette informative (convention clusters
colors by resemblance, so the several forest biomes all get
greens) are exactly the features that make it fail at useful
(clustered greens are what CVD and grayscale cannot
separate). Arc: open with the tension; the Ricklefs palette
as the informative pole; CVD and print as the useful pole,
the Ricklefs greens the concrete failure; the variants as
positions on the trade-off; then the resolution. The
resolution (Kim's): you do not find a perfect palette, you
stop making one channel do both jobs. The centroid label
(Thread 5) is that resolution — color stays informative, the
label carries robust discrimination, a separation of
concerns. This promotes Thread 5 from accessibility add-on to
the chapter's conceptual landing. The tension recurs
elsewhere (nine biomes; map resolution); Color is the
cleanest instance, so it is where the document names it.
Title locked: "Color: more than decoration." Drafting staged
— conceptual half (opening, informative pole, useful pole)
drafted first as pure prose in `color.qmd`; demonstrative
half (variants, resolution, `plot_biomes(palette = ...)`)
after the function work.

**Further sharpened 2026-05-22 (designing the custom palette, with Kim).**
Building the custom palette surfaced three ideas that deepen
the framework, especially its "useful" pole.

**Separation is a finite budget.** Nine biomes, and a color
space — particularly a constrained one, CVD-safe or
grayscale — holds only so much distinctness. You cannot make
all nine maximally distinct from all eight others. A palette
is always an allocation; the real question is where to spend
the budget.

**The palette is tied to the purpose.** What decides the
allocation is the map. An Oregon biome map is mostly forest
types, so the forest greens must be sharply separated and the
dry biomes can sit closer; a Great Basin map inverts it. Same
nine biomes, different best palettes. This makes "useful"
purpose-relative: not "all nine maximally distinct" (a
fiction the budget will not fund) but "the distinctions this
map needs are clear."

**The diagram and the map are different design problems.**
For many years the Whittaker diagram was the endpoint, and
the Ricklefs palette meets that goal: the diagram is a
fixed-geometry problem, nine polygons of fixed shape, size,
and adjacency. A map is variable-geometry — a biome becomes a
geographic area, large or tiny, compact or meandering. That
imposes constraints the diagram never did: a color must not
get lost on a thin sliver, and must not over-dominate as a
large field. The color chapter re-derives, for color, the
diagram-to-map shift the whole document is built on.

**Category reduction is design freedom.** A regional map
rarely needs all nine biomes; Oregon has five. Fewer biomes
means more budget per biome, and the design effort
concentrates on the biomes actually present. This is part of
why the user-supplied-palette capability matters: a user
tunes a palette for their own map and its biome subset.

These ideas land mainly in the custom-palette section and
sharpen the "useful" pole throughout. The redundant-encoding
resolution (the centroid label) still stands beyond them all:
purpose-tuning is the best the palette itself can do.

**Further sharpened 2026-05-22 (what the label does beyond identifying).**
A note from Kim once the abbreviated labels were running on
the diagram: the abbreviations are not just compact, they are
"reinforced by the color they sit on." "Fst" sits on green
panels, "Dsrt" on tans; the abbreviation's word-stem echoes
what the palette's convention already says.

This sharpens the resolution. The separation of concerns
(color informative, label robust) still holds, but the two
channels are not neutral toward each other. On a
convention-following palette the label reinforces the color,
and the reader gets one coherent doubled signal. On the
useful-pole palettes (cvd, grayscale, colors distinct but
carrying no landscape meaning) that reinforcement is gone and
the label carries identification more on its own. The label
is universal insurance; on the iconic palette it is also a
duet with the color. A quiet argument for abbreviation stems
that track the palette's semantics, which the project set
does (Fst, Dsrt, Rain, Seas, Gras).

There is more, and it does not depend on color at all. With
the abbreviations in place, Kim saw the systematic stems line
up into a pattern: the Trop labels on the warm right of the
diagram, the Tmp labels in the temperate middle, SubTropDsrt
in line with TmpGrasDsrt along the dry edge. Because the
stems are consistent, the repeated prefixes and suffixes,
sitting where their biomes fall, trace the diagram's own two
axes. The shared "Trop" marks the warm zone, the shared
"Dsrt" the dry end. The label set makes the
temperature-precipitation structure of the classification
visible at a glance.

This lifts the label from convenience to teaching device. It
is not only a robust identification channel and not only a
reinforcement of the color; the systematic label set carries
the diagram's structure, with no color involved, so it still
teaches on a cvd or grayscale palette. Kim's framing: "Having
labels is more than a convenience. They help teach the
pattern, even in the absence of corresponding colors." The
consistency he required of the abbreviations is what makes
this work; an ad hoc set would identify the biomes but would
not line up into a pattern. The label resolution is not a
consolation for when color fails; it adds something the color
channel alone never gave.

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
