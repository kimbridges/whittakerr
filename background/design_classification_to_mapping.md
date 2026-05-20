# Design: Classification as a Step Toward Spatial Visualization
_Captured 2026-05-13 (evening session). Design-level thoughts
that affect multiple chapters and the project's overall scope._

## Context
Captured during the climate-retrieval session, after the
`get_climate()` function was written but before Kim ran it.
Kim flagged these as "thoughts on the overall design while
they are fresh in my mind." Substantive enough that they
likely reshape the document's structure and scope, not just
add details to existing chapters.

## Thread 1: Map resolution as a constraint on category count

Kim's framing: "The limit on categorization (i.e., the max
categories) is likely set by the resolution of the map that
shows the spatial distribution of the categories. Too many
categories and they won't be seen on a small map."

This adds a fourth constraint to the "right grain" discussion
in the planned "What Is a Biome?" chapter — alongside
bias-variance, cognitive load, and descriptor-space
dimensionality, there is **display constraint**. The map is the
deliverable; the map's resolution caps how many distinct visual
encodings (fills, patterns, hatches) can be perceived. Whittaker's
nine-ish biomes work as a world map because nine fills are
visually distinguishable at that scale. A 30-category scheme
would not render legibly on the same physical area.

Implication: the Whittaker diagram and the Whittaker map
**co-constrain each other**. Category grain has to satisfy both
the statistical/cognitive criteria and the visual-display
criterion of the intended map. The diagram alone doesn't tell
you the right number; the diagram-plus-the-map does. This is
elegant and worth elevating into the chapter as a named fifth
thread (after the four already there) or folded into Thread 2
as a specific kind of compression constraint.

## Thread 2: World-scale mapping as a missing/constrained element

The intent of Whittaker's biome scheme was global distribution.
But producing world maps of biome extent was itself a
substantial undertaking in his era — pen-and-ink rendering,
limited basemap data, no GIS. Modern computing makes such maps
trivial to generate from a classification scheme; Whittaker's
era did not. This positions the relative absence of large
published biome maps from his work as a technical-constraint
artifact, not a disciplinary disinterest.

Context for the History chapter (Ch 1) — worth a sentence or
two acknowledging that the mapmaking gap is a technology story,
not an interest story. It also reframes the present project:
producing the maps Whittaker couldn't easily produce is part of
what whittakerr is for.

**Direct authorial witness (added 2026-05-15).** Kim taught
the first course in computer cartography at the University of
Hawaii at Manoa, with a key to the cartography lab and
darkroom where the pre-digital tools were still in production
use — copy cameras, rubylith film, ruby-tipped cutters,
darkroom processing. His witness on this thread is no longer
speculative. The constraints that kept Whittaker's era from
producing more maps were the same physical-tool constraints
Kim worked inside while simultaneously teaching the digital
methods that would displace them. Kim's framing: "the
difficult act of creating maps in the 'old days' kept them
from being created." See `background/cartography_context.md`
for the full lineage and the implications for the eventual
Mapping chapter.

## Thread 3: Regional-scale biome mapping via tessellation

Kim's idea: plot biomes at a regional scale (Oregon as the
worked example) using tessellations. This is a NEW analytical
and visualization capability that goes beyond the original
outline's "Biomes shown on maps" demonstration, which framed
mapping as **points** on a map. Kim is now proposing
**areas** — tessellated cells (Voronoi, hex grid, or regular
grid) colored by the biome predicted at each cell's centroid.

Implementation sketch:
1. Define the region of interest (bounding polygon — Oregon
   state boundary, ecoregion polygon, etc.).
2. Generate a tessellation over the region. Options: Voronoi
   from sample points (Kim has existing capability via
   proj_Koch_voronoi.md), hexagonal grid (clean, predictable
   cells; packages like `sf` + `st_make_grid` or `h3jsr`),
   or regular grid.
3. For each cell, retrieve climate at the centroid via
   `get_climate()` (already vectorized — composes cleanly).
4. Run `name_biome()` per cell to get the biome label.
5. Plot the tessellation colored by biome.

This is feasible with the current toolset plus a tessellation
helper. It would also be the first whittakerr deliverable
that lives natively in geographic space rather than in
Whittaker-diagram space — the inverse projection from
classification back to geography.

Possible new chapter or example: "Regional Biome Maps via
Tessellation." Would land late in the document, between
Transitions and any appendix, or alongside the existing maps
demonstration.

## Thread 4: Classification as a step toward spatial visualization

Kim's framing: "Classification is a step toward spatial
visualization. Not just here; mapping is an end-point in
vegetation studies in general. We don't see many maps in the
historical documents as mapmaking was difficult."

This is the broadest claim — a meta-frame for the whole
project and for vegetation studies generally. The arc:
**observe → classify → map**. The map is the synthesis that
makes the classification useful to others. The Whittaker
diagram is a step; the geographic distribution is the
destination.

For whittakerr, this reframes the toolset's purpose. The
tools aren't just for placing points on an abstract diagram.
They are for building maps in real geography that show where
biomes are predicted to occur, how they shift under climate
change, and how they tessellate within regions. The Whittaker
diagram is an intermediate representation; the maps are the
deliverable.

This frame elevates Chapter 6 (Biome Characteristics) and
Chapter 7 (Transitions) — they become contextualizers for
mapping rather than terminal discussion chapters. It also
strongly justifies a dedicated mapping chapter as the
project's natural endpoint.

## Implications for the project

**For the "What Is a Biome?" chapter (Ch 2, ideation file).**
Add the display-constraint thread either as a fifth named
thread or as an extension of Thread 2 (compression). Both work;
the chapter outline will decide. (Pointer note now added to
`chapter_what_is_a_biome_ideas.md`.)

**For the History chapter (Ch 1, drafted).**
Small addition: a sentence or two acknowledging that the
relative scarcity of large-scale published biome maps in
Whittaker's era is a technical-constraint artifact. Not a new
section; just an observation woven into the existing prose.

**For the Document outline.**
A new chapter probably belongs at the end: "Mapping Biomes"
(or similar). Houses both world-scale mapping discussion
(building on Thread 2) and the regional-tessellation work
(Thread 3). Would push the existing Transitions chapter from
position 7 to position 7 still, with the new chapter as 8;
or insert before Transitions if the editorial flow wants
mapping before the discussion-of-transitions closer.

**For the R toolset.**
A new function or set of functions for regional-scale
tessellation mapping. Likely uses `sf` plus a tessellation
helper. Composition is clean: tessellation cells → centroids
→ `get_climate()` (vectorized) → `name_biome()` → plot. Could
become a separate proj_*.md if the tessellation work outgrows
whittakerr; the original Chapter 3 outline's "Possible
standalone tool" note applies here too.

**Reframe of the project's purpose statement.**
Current proj_whittakerr.md Objective frames whittakerr as
"a set of tools and a published reference for examining one or
many sites against the Whittaker biome classification."
Thread 4 suggests a broader framing: "a set of tools and a
published reference for moving from climate values through
biome classification to spatial visualization at multiple
scales." Worth Kim's consideration when he reviews this file.

## Thread 5: Tessellation maps as a hypothesis test

Added 2026-05-13 (later in the same session).

Kim's reframe: the tessellation work is not just an alternative
visualization — it's a hypothesis test. **Can an "objectively"
created map (climate-driven, automated, tessellation-based)
accurately portray the distribution of vegetation? The
alternative is the hand-drawn expert map.**

Kim's quotes around "objective" are deliberate. The objectivity
claim itself is part of what's being interrogated; the test is
not "objective beats expert" but more likely "where does each
method excel, and where does each fail." The latter framing is
both more honest and more likely to produce useful findings.

### Methodological considerations

- **Reference maps to test against.** Whittaker's own published
  biome maps (low spatial resolution, 1960s rendering
  constraints). Olson et al. 2001 "Terrestrial Ecoregions of
  the World" (the modern standard reference). WWF Ecoregions.
  Bailey ecoregions. Regional expert maps where available
  (Oregon Vegetation Classification, Hawaii ecological zones).
  Each has its own provenance and embeds expert judgment.
- **The recursion problem.** Reference maps themselves are
  constructed artifacts, not vegetation-as-it-is. "Accuracy" is
  measured against another constructed object. This needs to
  be named honestly in the chapter or document — the test
  produces a relative finding, not an absolute one.
- **Comparison approaches.** Visual side-by-side (qualitative);
  quantitative agreement at sampled points (categorical
  agreement, Cohen's kappa); spatial-overlap area calculations
  per biome; out-of-sample testing against vegetation survey
  data where it exists. Likely a combination is needed.
- **Data density as a variable.** Tessellation grain (cell
  size), climate data resolution (2.5' vs 30"), and
  tessellation type (Voronoi from sample points, hex grid,
  regular grid) all affect the answer. The hypothesis test
  should explore the response of the answer to these
  parameters, not pick one and call it done.
- **Expected failure modes (testable predictions).**
  Tessellations likely handle continuous environmental
  gradients well (smooth transitions reflected in cell
  transitions). They likely handle hard boundaries poorly
  (mountain rain-shadow edges; sharp ecotones). Expert maps
  may be the inverse: hard boundaries get the attention; mid-
  zone variation gets averaged. Characterizing this asymmetry
  is itself a finding.

### Scope question

Kim flagged this could happen "in this exercise, or, if
needed, in another document more specifically directed at
that topic." Both are viable. Path A — keep inside whittakerr
as a chapter or extended example — preserves the
classification-to-mapping arc as one document. Path B — spin
out a dedicated document on objective-vs-expert mapping —
gives the methodological inquiry room to develop without
distorting whittakerr's main arc. Decision deferred.

Suggested Path A treatment: a chapter late in the document
("Testing the Objective Map" or similar) that runs the
hypothesis test on a tractable region (Oregon, per the
existing tessellation example) and reports findings honestly,
including the recursion-problem caveat. Suggested Path B
treatment: a new project (proj_objective_maps.md or similar)
that uses whittakerr's functions as building blocks but
pursues the methodological question at greater depth.

## Thread 6: The tool-to-concept editorial principle

Added 2026-05-13 (later in the same session).

Kim's articulation: "I like to push these documents that are
superficially about a tool, into new conceptual areas. That's
the educational value, I believe. The Colors of the Year is a
prime example of how far things can go."

This names an editorial pattern that's evident in whittakerr's
own trajectory and that Kim applies (and expects to apply) more
broadly. The pattern:

1. Start with a concrete tool — two R functions, an audio
   workflow, etc. The tool is the entry point, not the
   destination.
2. Document the tool functionally — what it does, how to use
   it, where its inputs come from.
3. Push at the conceptual edges. Why does the tool work? What
   does its existence assume? What does using it imply about
   how we know what we know in this domain?
4. The educational value lives in steps 3–N, not in step 1–2.
   A tool-only document teaches a procedure. A tool-as-doorway
   document teaches a way of thinking.

### whittakerr as exemplar

The project's growth in this session demonstrates the pattern
operating live. Starting state: two functions
(`name_biome`, `plot_biomes`) and an outline. Layers added in
sequence:

- Functional extension: `get_climate()` to complete the
  coordinate-to-biome pipeline.
- Conceptual layer 1: a "What Is a Biome?" chapter (five
  threads on categorization).
- Conceptual layer 2: the classification-to-mapping arc (this
  design file's Threads 1–4).
- Conceptual layer 3: the objective-vs-expert hypothesis test
  (Thread 5).

The functional work would have been roughly a paragraph in a
README. The conceptual work is a multi-chapter document. The
ratio is the point.

### Color of the Year as referenced example

Kim's citation. The audio-workflow project (proj_audio.md)
followed the same pattern: a TTS / audio integration tool
became the entry point to broader work. Worth a brief lookup
when this principle is elevated to a project-independent note.

### Cross-project applicability

This principle is not whittakerr-specific. It applies to:
- Audio / Color of the Year (already documented)
- Anything in the R-package family where the package is the
  entry point to a wider conceptual frame
- Any future tool-centered document Kim builds

### Where this principle should live longer-term

Currently captured in this whittakerr-internal design file
because that's where it surfaced. The right longer-term home
is a Projects_Index-level note — perhaps
`design_principle_tool_to_concept.md` or a section in
`style_multichapter_doc.md` — so that future projects can
inherit it explicitly rather than having to rediscover the
pattern.

**Flagged for elevation.** No file moved or copied yet — wait
for Kim's direction on where it belongs.

## Thread 7: Edges as the locus of insight; the border-line question

Added 2026-05-13 (later in the same session — third
design-capture block).

Kim's framing bridges two of his backgrounds. "Edge cases" is
an IT term for inputs that reveal system behavior the interior
conceals. In ecology, the same attentional move operates:
range edges are where the interesting biology happens —
population dynamics under stress, evolutionary pressure,
climate-change leading-and-trailing-edge effects, ecotones.
The middle of a species' range tells you less than the edge
does, and an ecologist looks at edges by reflex. Kim notes
this is "shifting attention to ecotones, but not quite" — the
principle is broader than the ecotone concept. Ecotones are
one instance; the general principle is that **boundaries are
where mechanism becomes visible**.

This is a shared epistemic move across many disciplines.
Statistics: outliers as informative. Medicine: atypical
presentations diagnose. Machine learning: decision-boundary
analysis. Ecology: range-edge biology, climate-change focus on
leading/trailing edges, ecotone biodiversity, Connell's
intermediate disturbance. Kim's contribution is naming the
shared pattern, not inventing it.

### Implications for the project

**For the hypothesis test (Thread 5).** This clarifies where
the most informative findings will live. Disagreement between
objective tessellation maps and expert hand-drawn maps will
not be uniformly distributed — it will cluster at biome
boundaries. Interior agreement is uninformative noise; the
contested ground is at edges. The test design should weight
boundary regions heavily and report findings explicitly in
terms of boundary behavior. The Thread-5 failure-mode
prediction (tessellations handle gradients well, experts
handle hard boundaries well) is testable precisely at edges,
and only at edges.

**For "What Is a Biome?" (Ch 2).** A category's identity is
partly defined by its boundary. The edges-as-insight principle
deepens Thread 2 (categories as compression) by clarifying
that boundary placement is part of the compression choice,
not a downstream rendering decision. It also strengthens the
closing thread on the gradient-ecologist-who-drew-categories:
the boundary lines in Whittaker's diagrams are where his
theoretical commitments and his rendering constraints
collide.

**For the toolkit (plot_biomes).** Offer multiple boundary-
representation options as a parameter. Concrete proposal:
`plot_biomes(border = c("crisp", "soft", "none", "uncertainty"))`.

- `"crisp"`: conventional lines as in the existing function
  (default for backward compatibility).
- `"soft"`: blended fills with gradient transitions across
  several degrees of T or several cm of P at each boundary.
  Requires defining the transition width.
- `"none"`: no lines, just biome-colored fills. Closest to a
  pure-continuum view.
- `"uncertainty"`: probabilistic membership at each point in
  T×P space, rendered as a confidence band or color-mixing
  scheme. Requires a probability model for boundary
  uncertainty (could start with simple distance-from-line
  as a proxy).

The act of producing all four as parallel figures in the
document IS the visual essay on the boundary question. The
reader sees the same biome layout under four different
ontological commitments and decides for themselves what kind
of object a biome category is.

### The border-line question: would Whittaker draw the lines?

Kim's specific question: should the category limits in a
Whittaker diagram have a border line, or not? Conventional
drafting would draw the line. Would Whittaker?

The honest answer is that he drew them as a rendering
compromise, not a theoretical commitment. The pen-and-ink and
offset-printing era required discrete boundaries; gradient
fills were impractical at publication quality. His audience
also needed categories to function — a fuzzy-membership
diagram in 1975 would have failed pedagogically. So the lines
in his published diagrams are a tactical choice in the
service of communication, layered on top of an underlying
continuum view that the Smoky Mountains work had already
established.

The interesting implication: if modern visualization had been
available to Whittaker, the published diagrams would
probably look different. Soft boundaries or no boundaries
would be more consistent with his gradient-ecologist
commitments. The whittakerr document can make this argument
explicitly — show the conventional Whittaker diagram, then
show the soft-boundary version, and note that the latter
better reflects what the author of the original probably
believed.

### A possible new function: distance-to-boundary

Edge thinking also suggests a utility function: for any point
in T×P space (or any geographic point with retrieved climate),
how far is it from the nearest biome boundary? Points near a
boundary are the "edge cases" — the most informative, the
most vulnerable to climate-driven biome shift, the ones where
the categorization claim is weakest. A `boundary_distance()`
or `edge_index()` function would let `get_climate()` outputs
be flagged for boundary proximity. Useful for the Botanical
Gardens example (which gardens are at edges?) and the
hypothesis test (where are the disagreements most likely?).

## Thread 8: Classification systems encode implicit models of agency

Added 2026-05-14 (closing side thought of the day).

Kim's observation: the USDA Hardiness Zone system is similar
to the Whittaker biomes but is based on temperature only. How
do they eliminate precipitation? Their view is horticultural,
not ecological — and **people water their plants**. The
classification system gets simpler in exact proportion to
what its users are willing to manage.

This generalizes into a substantive epistemic point.
Classification systems encode implicit models of **agency**:
which factors are assumed uncontrolled by the user, and
which are assumed managed away. The descriptor space isn't
just "what matters biologically" — it's "what isn't being
controlled by the user."

- **Whittaker biomes** assume both temperature and
  precipitation are environmental givens; nature acts on
  plants with no human in the loop. Both axes required.
- **USDA Hardiness Zones** assume temperature is given but
  precipitation is controllable (gardener with hose). One
  axis sufficient.
- The reduction from two axes to one isn't because
  precipitation stopped mattering biologically — it stopped
  mattering *epistemically* once it's been moved out of the
  uncontrolled domain.

This connects to several earlier threads:
- **Thread 3 (descriptor-space dimensionality)** — granularity
  is tied to dimensionality, AND dimensionality is tied to
  what the user controls. A new dimension is needed only when
  the variable matters AND is uncontrolled.
- **Thread 4 (function over identity)** — both systems classify
  by function, but the function is different. Whittaker:
  ecological community. USDA: gardener's winter-survival
  decision. Different functions → different category schemes
  → different axes.
- **Thread 7 (edges)** — and here is the second sharp point —
  the two systems even use **different temperature statistics**.
  Hardiness zones use *average annual minimum temperature* —
  the cold extreme that kills the plant in a bad winter.
  Whittaker uses *mean annual temperature* — a long-term
  average. Same physical variable; two different
  failure-model assumptions. Hardiness implicitly assumes the
  plant is killed by a worst-case event (an edge of the
  temperature distribution); Whittaker implicitly assumes the
  plant is shaped by a long-term envelope (a moment of the
  distribution). Both views are correct for their respective
  purposes; neither subsumes the other.

### Built-in worked example

`data/Bot_Garden_Geocode_CSV.csv` already includes a
`Hardiness` column alongside `lon` and `lat`. The pipeline
`get_climate() → name_biome()` produces the climate-predicted
biome for each garden. Pairing these two — USDA Hardiness
Zone (from the CSV) and Whittaker biome (from the toolkit) —
gives a per-garden comparison of two classification systems
applied to the same locations.

Interpretable disagreements:
- **Hardiness "warm enough" but biome "desert"** — locations
  where winter temperature alone says "OK to plant tender
  things" but the biome envelope says "low rainfall is the
  constraint." Reveals the precipitation-decoupling
  assumption directly.
- **Hardiness "too cold" but biome "rich"** — locations where
  winter minimums veto cultivation despite favorable annual
  means and adequate precipitation. Reveals the
  mean-vs-extreme assumption directly.

These disagreements are the worked example. The exercise
itself demonstrates the chapter's underlying argument: what
a classification system attends to (and what it ignores) is
determined by what its users are willing to manage. This is
an unusually clean teaching example sitting in data Kim
already has — and it would be a strong addition to either
the "What Is a Biome?" chapter (Ch 2) or to a possible new
section/chapter on "Comparing classification systems."

### Heat-zone footnote

USDA also publishes an AHS Heat Zone Map for hot-season
constraints — implicit acknowledgment that one axis isn't
quite enough even within horticulture. Worth mentioning
briefly in the worked example: even within a single
managed-water assumption, temperature itself has multiple
relevant statistics (cold minimum AND hot maximum), and
serious horticulture has been quietly moving toward
multi-axis classification too. The Whittaker-vs-USDA dichotomy
is therefore a useful pedagogical contrast but not a static
one — the practical systems are evolving toward more axes,
not fewer.

### Connection to Thread 5 (hypothesis test) and Thread 1 (display)

This is also a hypothesis-test setup in miniature. Compare
two classification systems' assignments at a set of known
points, identify where they disagree, characterize the
disagreement. The methodology echoes Thread 5's
objective-vs-expert mapping comparison. And the display
question (Thread 1) applies: a side-by-side map of
Hardiness-Zone-California vs Whittaker-biome-California
would show the assumption differences spatially, not just
in a table.

## Thread 9: The diagram IS the system

Added 2026-05-15 (structural-thought opening of the session).

Kim's framing: most other vegetation classification systems
are *geometric* — they have a mathematical pattern. USDA
Hardiness Zones, Köppen, Thornthwaite, Holdridge. Given a
location's climate values, you can place it in a category by
equation. Whittaker's system doesn't allow that. You have to
interpret the location against irregularly shaped categories.
Punch line: **"The diagram is not an artifact of the system;
it is the system."**

### Why this matters

This is the meta-frame that justifies the whole whittakerr
toolkit. In rule-based classification systems, the diagram is
a *visualization of rules*. You could hand someone the formulas
and they could categorize without ever seeing the picture.
With Whittaker, there are no formulas. The polygons themselves
are the definitional object. Every implementation of
"Whittaker biomes" — plotbiomes, our vendored CSVs, any
future version — has to ship the polygons, because the
polygons aren't a data file the package happens to include;
they're what the package operationalizes.

Concretely, this is why:
- `name_biome()` uses `point.in.polygon`, not closed-form
  computation.
- We just spent the prior session vendoring 775 rows of
  polygon vertices, not a few lines of equation code.
- The 2026-05-14 plotbiomes → vendored-CSV switch wasn't
  trading one source of data for another; it was switching
  the canonical location of the system's definitional
  content.

### Why Whittaker chose this form

The choice connects directly to his gradient view (already
captured in the closing turn of the "What Is a Biome?"
chapter ideation file). The Smoky Mountains work argued
vegetation varies continuously along environmental gradients
— Clements's discrete community types were the position he
was arguing against. If you believe nature is fundamentally
continuous, you cannot write category boundaries as equations:
equations imply sharp rule-bounded categories. Polygons drawn
by hand from observation, by contrast, honor the continuum
view while still giving practitioners a usable categorization.
The irregularity is a feature, not a defect — it follows
from his theoretical commitments. He drew what he saw, not
what he could derive.

### The methodological inversion

Most classification systems: **rule → diagram**. The rule is
primary; the diagram visualizes it.

Whittaker: **observation → polygon → diagram**. The
observation is primary; the polygon captures it; the diagram
displays it. The diagram is closer to natural history than to
physics in its epistemic structure.

This inversion is not a casual stylistic choice. It encodes
a substantive position about what biomes are: empirically
shaped regions in T-P space, not derivable from first
principles. The system is honest about being a digitization
of expert judgment about observed patterns. Other systems
(Holdridge, Köppen) make the opposite epistemic claim — they
say biomes/zones follow from rules — and the difference is
visible in whether the system can be implemented as equations
or only as polygons.

### Connections to other threads

- **Thread 1 (display constraints).** Whittaker's category
  count is also tied to display constraints, but the diagram
  is doing more work than just displaying — it IS the system.
  The display-constraint argument applies more loosely here
  than for rule-based systems where the diagram is a separable
  pedagogical object.
- **Thread 4 (function over identity).** Both choices —
  life forms over taxonomy, polygons over equations — encode
  the same underlying commitment: respect what nature actually
  does, even when it resists clean abstraction.
- **Thread 5 (hypothesis test).** Strengthens the recursion-
  problem caveat. If biome boundaries were rule-based,
  "objective vs expert" mapping would be a trivial
  comparison. Because the boundaries themselves are
  expert-drawn polygons, the comparison is between different
  ways of operationalizing expert judgment, not between
  expert and machine in any pure sense. The Thread 5 footnote
  on this should be reinforced.
- **Thread 7 (edges).** Whittaker's irregular polygon edges
  are themselves expert-drawn objects. Boundary representation
  decisions (`border = c("crisp", "soft", "none",
  "uncertainty")`) are decisions about how to display
  digitized judgment, not equations.
- **Thread 8 (agency).** Different systems make different
  assumptions about user control AND about whether their
  categories are derivable. Hardiness Zones: precipitation
  controllable, temperature rule-based. Whittaker: nothing
  controllable, nothing rule-based — pure observation.

### Implications for the document

This thread belongs in the "What Is a Biome?" chapter (Ch 2)
as a section explicitly contrasting rule-based with
polygon-based systems. It also justifies the existence of
the toolkit: if Whittaker had given us an equation, the
package would be three lines of code; he gave us a diagram,
so we need polygons, point-in-polygon testing, and a
visualization function that ships the polygons as data.

Worth a sidebar in the History chapter (Ch 1) too: noting
that Whittaker's choice to define his system as a diagram
rather than as a rule is itself a methodological commitment,
not a presentation choice.

## Thread 10: Scale as an intrinsically ecological concern

Added 2026-05-15 (afternoon working session).

Kim's framing: scale has come up repeatedly across this
project — data scale (2.5' vs 30" WorldClim), map scale
(world vs region; what category counts are legible at
each), the cell-size variation with latitude, the
number-of-categories question itself. He argues that scale
is "intrinsically ecological" and "rarely discussed," and
draws a sharp parallel to taxonomy: taxonomists have
explicit hierarchical levels (kingdom, phylum, class,
order, family, genus, species) and choosing which level
to operate at is a deliberate methodological act
articulated in their vocabulary. Ecologists make equally
consequential scale choices but rarely with the same
explicit vocabulary.

### The three scales ecology must reckon with

Any ecological observation operates simultaneously at:

- **Spatial scale.** Microhabitat (cm) → habitat patch
  (m–km) → landscape (10s–100s km) → region (100s–1000s
  km) → continent → global.
- **Temporal scale.** Instant (seconds, photosynthesis
  rate) → diurnal → seasonal → interannual → decadal →
  centennial → millennial → geological.
- **Organizational scale.** Individual organism →
  population → community (multiple species) → ecosystem
  (community + abiotic) → landscape (multiple
  ecosystems) → biome → biosphere.

These three are partly independent and partly correlated.
A study can be cross-scaled in interesting ways
(short-time-scale processes at large spatial scales;
community-level work in a single habitat patch; etc.).

### Whittaker's scale choices

The diagram operates simultaneously at:

- **Spatial: regional to global.** Cell averages at
  whatever resolution (2.5' → ~5 km cells at most
  latitudes). The diagram itself is built for global
  applicability.
- **Temporal: long-term annual mean.** BIO1 (mean
  annual temperature) and BIO12 (annual precipitation)
  averaged over the 1970–2000 WorldClim baseline.
  Discards seasonality, droughts, fires, decadal
  variation.
- **Organizational: biome.** Community-level vegetation
  type, not individual species and not whole ecosystems.

The diagram is useful precisely because the chosen scale
is large enough to reveal climate-vegetation relationships
across continents and small enough to keep a world map
legible. It is not a defect that the diagram averages
over within-biome heterogeneity or sub-annual variation;
that averaging IS the scale choice. Finer-scale analyses
exist for finer-scale questions.

### What other scales reveal (and obscure)

- **Population-scale work** on a single species shows
  responses Whittaker's diagram averages over (range
  edges, local adaptation, density-dependent dynamics).
- **Landscape-scale work** shows mosaics Whittaker's
  diagram smooths (patch configuration, edge effects,
  meta-communities).
- **Sub-annual temporal work** shows seasonality the
  annual mean discards (phenology, fire regimes,
  drought cycles).
- **Decadal / centennial work** shows the climate change
  the historical average obscures (range shifts, biome
  boundary movement).
- **Microhabitat work** shows below-cell heterogeneity
  (windward vs leeward Oahu within a 2.5' cell;
  elevational shifts on Mauna Loa within a 30" cell).

Each scale has its place. The Whittaker diagram doesn't
replace finer-scale work; it complements it by operating
at a scale where finer-scale work would be incoherent.
This is the same epistemic logic that lets a taxonomist
work productively at the family level for a question
where species-level work would be either too detailed or
too granular.

### Why scale is rarely discussed explicitly

Modern landscape ecology and macroecology have made
scale central since the 1980s (Wiens 1989, Levin 1992).
But individual studies still tend to treat their scale
of analysis as given rather than defended. "We worked
in plot X, sampled monthly, identified to species" —
the scale choices are implicit in the design rather
than argued for. Making scale explicit is itself a
methodological move that has been historically rare.

For the whittakerr document, this matters because the
diagram's design decisions ARE scale decisions: the
choice of T and P over other descriptors (descriptor
scale), the choice of annual means (temporal scale),
the choice of biome polygons rather than rule-based
categories (organizational and analytical scale). Making
these explicit is part of making the diagram
intelligible as a tool with a deliberate scope.

### Connections to other threads

- **Thread 1 (display constraints).** Map scale
  constrains category count. A world map supports ~9
  fills; a regional map could support more or might
  support fewer if a finer-grained scheme is wanted.
  Scale-of-display is one of the constraints.
- **Thread 3 (descriptor-space dimensionality).** Scale
  of the descriptor space (how many axes, at what
  resolution). Adding axes increases descriptor scale;
  finer resolution increases data scale.
- **Thread 4 (function over identity).** Choice of life
  forms over taxonomy is itself a scale choice — life
  forms operate at a different organizational level than
  species do. Convergent evolution is visible at
  life-form scale and invisible at species scale.
- **Thread 5 (hypothesis test).** Tessellation maps at
  different cell sizes are explicitly different-scale
  analyses; the test should report findings AS A
  FUNCTION of scale rather than at a single scale.
- **Thread 7 (edges).** Edges and boundaries are
  scale-dependent — a biome boundary at world scale is
  a smooth transition zone at regional scale and a
  mosaic at landscape scale. The scale at which a
  boundary is studied changes what the boundary is.
- **Thread 8 (USDA agency).** Hardiness Zones use
  minimum-temperature statistic, Whittaker uses
  mean-annual statistic. Both are at annual aggregation
  but they probe different temporal scales within the
  year (extreme event vs long-term mean).
- **Thread 9 (diagram-as-system).** The polygons are
  scale-of-resolution choices made by the original
  digitizer; finer scales (more polygons, more
  detailed boundaries) and coarser scales (fewer
  polygons, smoothed boundaries) are possible
  re-renderings.

The interconnection density suggests scale might be the
unifying frame for all the prior threads — the meta-
thread under which the others sit. Worth considering
whether the document's organization can foreground
scale as an explicit organizing principle.

### Possible chapter

Strong candidate for its own chapter. Working title:
"Scale: the unstated dimension." Sits comfortably between
"What Is a Biome?" (Ch 2 candidate) and the technical
retrieval chapters. Makes explicit what is otherwise
implicit throughout the document. Closes with the
taxonomy parallel and an invitation to the reader to
recognize their own scale choices in any ecological work
they do.

Alternative: scale runs as a thread through multiple
chapters rather than getting its own. Each chapter notes
the scale assumptions it embeds. Less satisfying as a
synthesis but lighter to implement.

Decision deferred. Adding a `chapter_scale_ideas.md`
file would be premature without Kim's confirmation that
the chapter-form is desired.

## Open questions
- Title of the prospective mapping chapter — "Mapping Biomes,"
  "Biome Maps," "Spatial Visualization of Biomes," "From
  Classification to Map." The last reuses Kim's own framing.
- Should the tessellation work be inside whittakerr or a
  separate project? Tessellation has broader uses (Koch
  Voronoi already exists); a tessellation utilities tool
  could serve multiple projects.
- Tessellation approach for the Oregon example: Voronoi (Kim
  has existing capability), hex grid (clean, predictable),
  or admin boundaries (coarser but more intuitive)?
- Is Oregon a deliberate pick or a placeholder? (Distinct
  ecoregions plus a coastal-to-arid gradient make it a strong
  teaching region; Hawaii would be richer ecologically but
  smaller and more elevation-constrained.)
- Path A vs Path B for the hypothesis test (Thread 5): a
  chapter inside whittakerr, or a separate document devoted
  to the objective-vs-expert mapping question?
- Where does the tool-to-concept editorial principle (Thread 6)
  live longer-term — a Projects_Index design note, a section
  in `style_multichapter_doc.md`, or both?
- Implementation of the `border = c("crisp", "soft", "none",
  "uncertainty")` parameter in `plot_biomes()` — which
  variants to produce first, what transition widths to use
  for "soft," what probability model underlies "uncertainty"?
- Whether a `boundary_distance()` / `edge_index()` utility
  function gets built as a separate function or folded into
  `name_biome()` as an additional return column.

## Next session — resumption checklist for these threads
1. Re-read this file and chapter_what_is_a_biome_ideas.md.
2. Decide whether the display-constraint thread becomes a
   fifth thread or folds into Thread 2 (compression).
3. Decide whether to add a dedicated Mapping chapter to the
   document outline; if yes, sketch its structure.
4. Decide tessellation approach for the Oregon example.
5. Decide whether mapping work justifies its own proj_*.md or
   stays inside whittakerr.
6. Consider updating the proj_whittakerr.md Objective
   statement to reflect the classification-toward-mapping
   frame.
