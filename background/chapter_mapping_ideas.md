# Chapters: Build a Map and Beyond a Map — Ideation Notes
_Captured 2026-05-15 as a single "Mapping Biomes" chapter.
Split into two chapters on 2026-05-22 (see "Split into two
chapters" below): "Build a Map" and "Beyond a Map." This
file is the shared ideation scaffold for both._

## Status
Active ideation. Substantial design space remains open and
Kim has flagged this explicitly: "this is an area where we
are likely to have some in-depth discussion, not just about
techniques, but also about examples." Multiple technical
approaches on the table (basic tessellation, smoothing
variants, 3D overlay); multiple worked examples queued
(Oahu, Hawaii Island, IBP biome programs combined); strong
authorial-authority backing via the cartography lineage
(see `cartography_context.md`).

This file consolidates threads previously scattered across
`design_classification_to_mapping.md` (Threads 2, 3, 5, 7)
into a single chapter-level scaffold.

## Placement

Two adjacent chapters, late in the document. Earlier
chapters build the conceptual ground (History, What Is a
Biome?, Scale) and the diagram-side tools (Climate Data,
Whittaker Diagrams, Color, Biome Information, Roles Not
Rosters, Transitions). The map chapters are the
geographic-space synthesis that uses everything before them,
and they are the classification-to-mapping arc's
destination.

Position in the provisional sequence: after Transitions, as
"Build a Map" then "Beyond a Map," followed by Biomes on the
Earth and then the concluding chapter.

## Split into two chapters (2026-05-22)

The material was first scoped as a single "Mapping Biomes"
chapter. While a six-section structure for it was being
proposed, the top-heaviness concern from the scope-discipline
note below came to a head: one chapter carrying the whole
map story would run 2,500 to 4,000 words and four or five
figures, out of proportion with every other chapter. Kim's
resolution: split it in two, on the seam between making a
map and working with one.

**"Build a Map"** — sections 1 to 3. Producing a map.
Carries Thread 1 (mapping as the destination of the
classification-to-mapping arc, the opening), Thread 2 (the
pre-digital cartography setting and Kim's UHM witness, kept
compact, as the stage-setting opening), Thread 3 (the
tessellation pipeline via `map_biomes()`, with Oahu at 30
arcseconds as the canonical worked example), and the
"Outside Whittaker range" honesty point from Thread 8, which
surfaces naturally with the first basic maps.

**"Beyond a Map"** — sections 4 to 6. Working with a map you
already have, framed as both a tool (a surface for anchors)
and a data product (biome areas to analyze). Carries Thread
9 (points and labels as anchors), the composition half of
Thread 8 (`biome_composition()` as a region-oriented
product), Thread 4 (smoothing, with the Oahu-artifact and
Oregon-natural contrast pair), Thread 5 (boundary
representation, briefly), and Thread 7 (the hypothesis-test
framing and maps-as-arguments, the methodological close that
hands off to Biomes on the Earth).

The split falls on a real conceptual seam, make versus
interpret, and it matches the document's habit of many
focused chapters rather than a few sprawling ones. The
escalation across the three map-related chapters is then
clean: Build a Map, then Beyond a Map, then Biomes on the
Earth — build, work with, verify.

Titles: "Build a Map" and "Beyond a Map" are Kim's, set
2026-05-22. Both are treated as settled working titles and
could still be revised before drafting.

Threads 6 and 10 are unaffected by the split. Thread 6 (3D
overlay) was already promoted to the Biomes on the Earth
chapter; Thread 10 (the Solomon Islands inversion) has moved
to the concluding chapter (`chapter_concluding_ideas.md`).

## The Threads

### 1. Mapping as the destination of the classification-to-mapping arc
The whole document's structure is on a trajectory:
classification (Whittaker diagram in T-P space) → spatial
visualization (biome map in geographic space). Earlier
chapters build the classification apparatus; this chapter
delivers what the apparatus is FOR. Thread 4 of
`design_classification_to_mapping.md` makes this claim
explicitly — the diagram is the intermediate, the map is
the deliverable.

The chapter opens on this arc. It names the move from
T-P space to geographic space as the substantive
contribution the toolkit makes, and frames everything that
follows as the technique-side of that move.

### 2. The pre-digital constraint and what computing changed
Drawing on `cartography_context.md`. Kim taught the first
course in computer cartography at UHM and had a key to the
darkroom where the pre-digital tools (copy cameras,
rubylith film, ruby-tipped cutters) were still in
production use. His framing of the era: "the difficult act
of creating maps in the 'old days' kept them from being
created."

The chapter can carry this as a sidebar or short section.
The point isn't nostalgia; it's that the maps Whittaker
might have produced — biome distributions over actual
geography, climate-change shift maps, regional
ecotone studies — were technologically out of reach in his
era. Modern computing puts them in reach. The whittakerr
toolkit operates on the far side of a transition Kim
witnessed and helped teach.

This thread also justifies the chapter's relatively
ambitious scope. We are not making maps that should have
been routine 50 years ago and weren't; we are making maps
that couldn't have been made then.

### 3. Tessellation maps as the foundation technique
The `map_biomes()` function (queued in
`example_ideas.md` toolkit-features). Pipeline: fetch a
region polygon, fetch climate raster at chosen resolution,
crop and mask to the region, apply `name_biome()` per
cell, render with the polygon as boundary overlay. Design
file Thread 3 made this proposal; Oahu and Hawaii Island
are the first worked examples (see `example_ideas.md`).

The chapter introduces this as the basic move. A grid of
cells, each classified into a biome, rendered as a
colored map clipped to a coastline or other boundary.
Honest, deterministic, easy to reproduce.

The basic version raises an immediate visual question:
the raw tessellation looks like a pixelated mosaic with
hard cell edges. That visual quality is technically
faithful — every cell really IS one climate value, every
classification really IS discrete — but it doesn't read
the way a published biome map reads. The next two threads
address the response options.

### 4. Smoothing tessellation boundaries (Kim's extension)

**First implementation finding (2026-05-16).** Vector
smoothing via `smoothr::smooth(method = "ksmooth")` was
implemented as the lowest-risk first variant and tested on
Oahu. Two characteristics emerged from the test:

1. **Data fidelity preserved as expected.** No small areas
   were lost; the subtropical desert finding at Kaena
   Point and the Waianae lee survived the rendering
   transform. This was the theoretical expectation
   (vector smoothing operates on the polygon
   representation, not the underlying climate or
   classification data) and the observation matches.

2. **Single-cell-becomes-circle artifact.** Kim's
   observation: isolated single-cell biome assignments
   become rounded circles when smoothed. This is
   mathematically correct — `ksmooth` applies Gaussian
   smoothing to polygon vertices, and a four-vertex
   square has its corners aggressively rounded — but the
   visual reads as artifact rather than natural biome
   shape. The artifact appears specifically when isolated
   single cells exist with no contiguous same-biome
   neighbors to smooth into.

**Implication for example selection:** smoothing's visual
quality depends on the region's biome-transition scale.
For continental regions with slow gradients (Oregon's
Pacific maritime → Cascades rain shadow → high desert
transitions), biome regions span many cells and smoothing
produces natural boundaries. For islands with steep
gradients (Oahu's leeward dry pockets surrounded by
windward wet), biome regions are smaller, isolated cells
appear more often, and smoothing produces visible
artifacts.

**Pedagogical move for the chapter:** present BOTH
behaviors. Oahu (artifact present) and Oregon (artifact
absent) shown side-by-side make the data-fidelity-vs-
aesthetics tradeoff concrete. Smoothing is presented as
the right rendering choice for some regions and not for
others, which is more honest than presenting it as
universally good or universally bad. The toolkit supports
both renderings; the chapter teaches when to use each.

This also updates the Chapter scope discipline budget
(below) to include a complementary Oregon figure
alongside the Oahu canonical example.

---
Added 2026-05-15 from Kim's question: "can we take things
farther, such as smoothing tessellation boundaries?"

Three distinct smoothing approaches with different
tradeoffs:

- **Pre-classification smoothing** — apply a smoothing
  filter to the climate raster (T and P) before classifying
  each cell into a biome. Produces more cohesive regions
  but obscures sharp climate gradients. The smoothed
  Oahu map would lose the windward-leeward rain-shadow
  signal that makes Oahu interesting; the cost is real
  and decision-dependent on what the map is supposed to
  show.

- **Post-classification smoothing** — apply a majority
  filter or kernel smoother to the classified raster.
  Keeps the climate fidelity at the cell level but
  introduces classification noise at biome boundaries.
  Visually cleaner; data-honest at the cell level;
  boundary cells may flip in ways that don't correspond
  to underlying climate.

- **Vector smoothing** — convert the classified raster
  to polygons (one polygon per biome region), then
  simplify or smooth the polygon edges (Douglas-Peucker
  simplification, B-spline smoothing). Purely cosmetic;
  honest about being so. The data behind the smoothed
  boundary is the original tessellation; only the
  rendering changes.

The chapter can present all three as choices the
figure-maker makes consciously. The right choice depends
on the map's purpose: a publication-quality reference map
might smooth; a methodological figure showing data
fidelity should not. The chapter's pedagogical move is to
make the choice explicit rather than to hide it inside a
default.

Implementation: each approach corresponds to a
parameter or post-processing step in `map_biomes()` or a
companion function. Probably best implemented as a
`smoothing = c("none", "pre", "post", "vector")`
parameter with `"none"` as the default.

### 5. Boundary representation choices
Thread 7 of `design_classification_to_mapping.md`. The
diagram itself has multiple boundary representation
options (`plot_biomes(border = c("crisp", "soft", "none",
"uncertainty"))`); the map should have parallel options.
For maps specifically:

- **Crisp** — sharp polygon edges between biome regions.
  The default; matches conventional cartography.
- **Soft** — gradient blends at biome boundaries.
  Honors the continuum view (Whittaker the gradient
  ecologist would have preferred this if technology had
  allowed).
- **None** — color fills only, no boundary lines.
  Closest to a thematic map.
- **Uncertainty** — boundary regions shown with
  reduced saturation or hatched pattern indicating
  classification uncertainty (proximity to polygon
  edges in T-P space).

The map's boundary representation choice should be
considered separately from the smoothing choice — they
are orthogonal. A vector-smoothed map can have crisp,
soft, or uncertainty-shaded edges.

### 6. 3D overlay on Google Earth — PROMOTED to its own chapter (2026-05-17)

**Status update (2026-05-17).** This thread has been promoted
to a standalone chapter following the Mapping chapter. See
`chapter_3d_overlay_ideas.md` for the full ideation file.

The promotion was driven by Kim's articulation of a
verification rationale that lifts the 3D overlay from
"rendering option" to "structural verification step." Briefly:
the classifier consumes T and P only; elevation is not an
input; but at scales where orography dominates climate, the
biome map should track topography it never saw. The 3D
overlay tests that prediction by an independent physical
mechanism. That role earns chapter status.

Implications for THIS chapter:

- Thread 6 is no longer a refinement option for the Mapping
  chapter. The Mapping chapter ends at 2D and closes with
  the methodological frame (maps as arguments). The 3D
  Overlay chapter takes those maps and verifies them.
- The provisional structure below (Refinements section)
  drops the 3D overlay sub-section. Smoothing (Thread 4)
  and Boundary representation (Thread 5) remain as Mapping
  chapter refinements.
- The cartography-lineage third leg (digital → immersive
  3D) moves to the 3D Overlay chapter, where the immersive
  mode is the chapter's subject.

Original Thread 6 content (2026-05-15) preserved verbatim
below for the historical record; the live ideation has moved
to `chapter_3d_overlay_ideas.md`.

---

_Original 2026-05-15 ideation, retained for reference:_

Added 2026-05-15 from Kim's question: "applying the map
on top of Google Earth to see the 3D aspects."

Particularly compelling for Hawaii because Google Earth
handles terrain natively — no elevation data needed, the
map sits on the existing topography. A biome map overlaid
via KML lets the reader see climate-vegetation regions in
their actual physical setting: the windward Koolau ridge
as a green wall, the leeward south shore in its rain
shadow, the central plain transition, the Mauna Kea and
Mauna Loa elevational stacks. Spatial logic of biome
distribution — usually INFERRED from a flat map —
becomes directly OBSERVABLE on the terrain.

Two implementation paths:

- **Raster GroundOverlay (KML)** — render the biome map
  as a georeferenced PNG, wrap in a KML GroundOverlay
  pointing at the bounding-box coordinates. Simpler;
  loses vector quality; transparency over terrain works
  well; biome colors visible against landscape.

- **Vector KML polygons** — write the classified
  polygons directly as KML Placemarks with Polygon
  geometry and color fills via Style elements.
  Vector-quality but each polygon needs explicit color
  encoding in the KML; more lines of code; more
  faithful at boundaries.

R toolchain candidates: `sf::st_write()` with the KML
driver handles both (the polygon path is cleaner); the
older `plotKML` package was purpose-built for this; the
`leaflet` package can also export to KML-adjacent
formats.

Vertical exaggeration considerations: Google Earth lets
the viewer set a vertical exaggeration factor. For Hawaii,
the natural terrain already shows substantial relief;
exaggeration adds dramatic effect but distorts the
spatial relationships. The chapter can show with and
without exaggeration and let readers see what each
emphasizes.

The 3D overlay extends `cartography_context.md`'s
pre-digital → digital arc with a third leg:
**digital → immersive 3D**. Kim's career has now spanned
all three production modes — pre-digital
(rubylith and copy cameras), digital cartography (the
UHM course he taught), and now immersive 3D visualization
(Google Earth). That trajectory could appear as a
sidebar in the chapter.

### 7. The hypothesis-test framing
Thread 5 of `design_classification_to_mapping.md`. The
tessellation-vs-expert-map comparison is the
methodological inquiry that justifies the mapping work
beyond demonstration value. The chapter can include this
either as a section or as a forward reference to a
separate document (Path A vs B from Thread 5; Kim still
to decide).

If included here, the section addresses: how do we
evaluate a biome map? What does "accuracy" mean when both
the objective and expert maps embed expert judgment
(Thread 9, diagram-as-system)? At which scale does
disagreement cluster (Thread 7, edges)? The chapter
closes on the recognition that the maps it produces are
arguments, not facts — and that this is the strength of
the approach, not a weakness.

### 8. Cells outside the Whittaker envelope; composition as a product (2026-05-22)

Two points emerged while building `plot_biome_map()`'s color
support and surfaced as chapter material.

**The "Outside Whittaker range" category.** The Whittaker
scheme is a bounded envelope in temperature-precipitation
space, not an exhaustive partition. Real climates can fall
outside every biome polygon. The Oregon map made this
concrete: the very wet, mild cells of the Coast Range and the
western Cascades exceed the precipitation ceiling of the
temperate rain forest polygon, so `name_biome()` cannot place
them. They are off the top of the diagram. `map_biomes()` now
records such cells as a distinct tenth category, "Outside
Whittaker range," rendered in a fixed neutral gray and listed
in the legend, kept separate from out-of-region area (which
stays the white background). This is a real result, not an
error, and it belongs in the chapter as an honesty point. It
is the spatial face of the maps-as-arguments-not-facts
closing (Thread 7): the Pacific Northwest temperate rain
forest is wetter than the classic diagram's envelope, and the
map should say so rather than force a misclassification.

**Composition as a product.** `biome_composition()` returns
the area and percentage share of each biome on a map, sorted
by abundance, including the "Outside Whittaker range" share.
For biome-focused regional studies the percentage breakdown
is often a primary product in its own right, independent of
the map image. The chapter should present it as a worked
example: a horizontal bar chart with bars ordered by
percentage and each bar filled with its own biome color from
the active palette, the gray bar for the outside category.
The bar chart ties the Mapping chapter back to the Color
chapter, since the palette choice carries directly into the
bar fills.

Both are queued as worked examples for the chapter. Oregon is
the natural region to carry them, since it already shows the
off-the-diagram cells.

**Placement (settled while drafting Retrieving Biome
Information).** The composition bar chart's first worked
appearance is in the Retrieving Biome Information chapter,
not here. There it is place-oriented: it gives a retrieved
point its regional context, answering whether a point's
biome is typical of its region or a rare pocket within it.
In the Mapping chapter `biome_composition()` is
region-oriented, describing a region in its own right. It is
a shared capability with two framings; the Mapping chapter
uses it without re-introducing it.

### 9. Points and labels as anchors (2026-05-22)

Looking ahead to the chapter, Kim reframed the `points` and
`biome_labels` overlays on `plot_biome_map()`. They do more
than mark and identify; they give the map anchors. A biome map
is an abstraction, a classification draped over geography, and
a reader meets it more readily when it carries a few known
places. In Kim's words, these anchors, "often places that are
intrinsic to our understanding of the region, are vital as
they tie our experiences in the region to the abstractness of
the biome map."

This makes the point overlay a teaching device, not a
convenience. The worked examples should choose anchor points
deliberately, places the intended reader is likely to know, so
the biome map is read against something familiar. It also
pairs with the verification theme (Threads 5 and 7): an anchor
the reader knows is a spot where they can check the
classification against their own experience.

### 10. The Solomon Islands inversion — ecotones as the named categories (2026-05-22)

Kim's story, surfaced while reviewing the Transitions chapter
draft. A Pacific Island society, Kim believes from the Solomon
Islands, organizes its land classification around the
ecotones: the transition zones are the named categories, and
the areas in between, the biome interiors, are treated as the
unnamed "lines." It is the exact inverse of the Whittaker
scheme. The diagram draws polygons and treats the boundary as
a thin line with no width; this classification names the
boundary zone and treats the interior as the residual.

Why it matters here. The whole document spends six chapters
drawing clean lines and then one chapter (Transitions)
showing the lines were always a convenience, ending on the
move to read the picture as a field of gradients rather than
a set of boxes. The Solomon Islands classification made the
gradient primary from the start. For a society to whom
diversity is what matters, naming the diversity-rich edge and
leaving the interiors unnamed is the natural ordering. Our
diagram has to draw polygons because the data structure
needs an edge; their classification never paid that tax.

Status and placement. Kim: "not for use here" — it does not
belong in the Transitions chapter. But "there might be a role
for this in some wrap-up words." This is the candidate home:
the document's closing, where a brief account of an inverse
way of carving up the world would land well as a final
loosening of the classification's grip. The story is not
well known; the Solomon Islands attribution is Kim's best
recollection and should be verified before it appears in
print.

Update (2026-05-22): the home is now settled. The story
belongs in the document's concluding chapter, and the full
ideation for that chapter has moved to its own file,
`chapter_concluding_ideas.md`, where the Solomon Islands
inversion is Thread 2. The live ideation continues there.

## First worked result — Oahu at 30 arcsec (2026-05-16)

The basic `map_biomes()` pipeline ran end-to-end against
Oahu on first attempt. Kim's observation on the 30 arcsec
output: "the 30" resolution where a few locations where
subtropical deserts were identified. That was a good
surprise!"

The subtropical desert assignments are ecologically
defensible. Kaena Point (extreme NW Oahu) and the lee of
the Waianae Range record under 400 mm/year of precipitation
while remaining warm (MAT around 23°C), placing them inside
Whittaker's subtropical desert polygon in T-P space.
Hawaiian vegetation ecologists know these dry zones;
Mueller-Dombois (Kim's long-time lab partner) wrote about
them. The classification machinery detected what local
experts have always known but that general intuition about
Hawaii completely misses — "Hawaii doesn't have deserts" is
what most readers would assume; the climate envelopes say
otherwise.

**Why this is a strong validation point for the chapter:**

- **Thread 9 (diagram-as-system)** confirmed in practice.
  The point-in-polygon machinery returns biome
  assignments determined entirely by Whittaker's digitized
  boundaries; the polygons are doing the work, not any
  rule or equation.

- **Thread 7 (edges as locus of insight)** confirmed at the
  observational level. The dry pockets sit at the lee
  edge of the windward-wet pattern. The most interesting
  signal in the map is at a climate-gradient boundary,
  not in any biome's interior.

- **Scale chapter prescription operationalized.** At 2.5'
  the dry pockets average away; at 30 arcsec they appear.
  The chapter's claim that scale choice IS finding
  visibility now has a concrete worked demonstration.
  This becomes the canonical example in the Scale
  chapter's section on data-resolution choice.

- **Thread 5 (hypothesis test) gains a positive case.**
  The objective tessellation and expert ecological
  knowledge converge on the dry zones. The hypothesis
  test was designed expecting boundary disagreement to
  be the informative outcome; this is the complementary
  case — convergence as confidence. The chapter can
  use Oahu as an example of where the methods agree and
  the convergence is itself evidence.

**Observed limitation:** "a tiny bit of island truncation"
in the rendered map. Almost certainly a consequence of
GADM polygon simplification — GADM's level-2 county
polygons are simplified for storage efficiency. The biome
classifications themselves are unaffected (they're computed
from the climate raster cells, not from the polygon
boundary), but the visible coastline is slightly inside
the true shoreline in places. Queued refinement: try
`rnaturalearth` at large scale, USGS state shapefiles, or
OpenStreetMap data via `osmdata` for a higher-fidelity
boundary. Not a blocker.

**Verification as test-case-selection (Kim, 2026-05-16).**
Kim's methodological observation on the Oahu result:
choosing the right test case is part of the verification
process, not separate from it. The Oahu choice had two
independent verification paths — Kim's lived knowledge of
the island (he is "actually looking out at one of the
subtropical desert locations") and the published literature
(Mueller-Dombois on Hawaiian dry zones). When two
independent paths agree, the verification is strong.
Without an independent verification path, running code
that produces output isn't verification at all; the output
is just output.

This becomes a selection criterion for the rest of the
example catalog:

- **Hawaii Island** — both paths available. Kim's Island
  Ecosystems IRP research site (direct knowledge);
  substantial published vegetation work in Hawaiian
  ecology. **Strong choice.**
- **IBP biome programs combined** — both paths. Kim's
  Asst. Director years across two programs; published
  synthesis volumes from the IBP era. **Strong choice.**
- **California botanical gardens** — partial. Less of Kim's
  direct knowledge; standard horticultural expertise is
  documented. Moderate verification surface.
- **International cities** — weakest verification surface.
  Makes decent figures but doesn't carry the same
  evidential weight.

The chapter benefits from preferring examples with strong
verification surfaces, because the chapter can show not
just what the toolkit produces but that what it produces
is right. That's a meaningful pedagogical step up from
demonstration-only figures.

## Worked examples to draw on (see `example_ideas.md` for full entries)

- **Oahu biome map at 30" with coastline boundary** —
  first concrete tessellation map. Demonstrates the
  windward-leeward rain shadow at fine resolution.
- **Hawaii Island biome map at 30"** — likely the
  stronger example; larger canvas, more biome diversity,
  Mauna Loa transect overlay as research-historical
  connection.
- **IBP biome programs combined** — all five US/IBP
  biome programs' study sites on one Whittaker diagram
  AND optionally on a North American basemap.
  Self-referential: biome research mapped onto biome
  classification.
- **California botanical gardens** — already
  implemented in `Whittakerr_climate.Rmd`. Could be
  extended to a geographic map version (gardens as
  points on a California-shape basemap, possibly with
  predicted biome regions tessellated underneath).

## Key formulations to preserve verbatim

Kim's framing of the chapter's purpose:
> "This is an area where we are likely to have some
> in-depth discussion, not just about techniques, but
> also about examples. We have a good base established
> with the scale discussion and the tessellation
> techniques look promising. But can we take things
> farther, such as smoothing tessellation boundaries,
> or applying the map on top of Google Earth to see
> the 3D aspects. This is a topic that needs
> exploration and having a formal place to hold our
> ideas is important."

Kim's framing of the historical constraint
(`cartography_context.md`):
> "The difficult act of creating maps in the 'old days'
> kept them from being created."

## Provisional structure

Two chapters (see "Split into two chapters" above).

### "Build a Map"

- **Opening (Thread 1)** — Mapping as the destination of the
  classification-to-mapping arc, made explicit.
- **Historical setting (Thread 2)** — The pre-digital
  cartography constraints and what computing changed; Kim's
  UHM witness. Compact, the stage-setting opening.
- **The basic move (Thread 3)** — Tessellation maps via
  `map_biomes()`. Oahu at 30 arcseconds as the canonical
  worked example, carrying the subtropical-desert finding.
- **Off the diagram (Thread 8, first half)** — The "Outside
  Whittaker range" category as an honesty point, surfacing
  with the first basic maps.
- **Close** — hands off to "Beyond a Map": the map is built;
  what remains is to read, refine, and use it.

### "Beyond a Map"

- **On-ramp** — a brief re-entry: a map in hand, now treated
  as both a tool and a data product.
- **Anchors (Thread 9)** — points and labels as anchors that
  tie the abstract map to known places.
- **Composition as a product (Thread 8, second half)** —
  `biome_composition()`, region-oriented; used, not
  re-introduced (Retrieving Biome Information introduced it).
- **Refinements** — Smoothing (Thread 4): the three
  approaches and the Oahu-artifact / Oregon-natural contrast
  pair. Boundary representation (Thread 5): parallel to the
  diagram-side options, orthogonal to smoothing, briefly.
- **Methodological close (Thread 7)** — The hypothesis-test
  frame, kept light; maps as arguments, not facts. Hands off
  to Biomes on the Earth.

The 3D overlay (formerly Thread 6) is its own chapter after
these two. See `chapter_3d_overlay_ideas.md`. "Beyond a
Map"'s closing on maps-as-arguments hands off to it, and it
takes up the arguments and tests them against physical
reality.

## Chapter scope discipline (2026-05-16)

Kim flagged a scope discipline point during the smoothing
implementation discussion: "I'm inclined to not provide too
many examples in the mapping chapter as it could become
'top heavy' relative to the other chapters."

This shapes example selection. The full catalog in
`example_ideas.md` is the bench; the chapter draws from it
selectively. Working principle: the Mapping chapter should
be comparable in length and density to the other chapters,
not weighted disproportionately just because the worked-
example surface is large.

Proposed example budget for the chapter (revised 2026-05-16):

- **One canonical worked example** (Oahu at 30 arcsec) as
  the primary demonstration. Already produced; carries the
  subtropical desert finding and the scale-resolution
  demonstration.
- **One contrast pair on smoothing** — Oahu (single-cell
  circle artifacts visible) plus Oregon (smoothing produces
  natural boundaries on a continental-gradient region).
  Both shown gridded-vs-smoothed; together they make the
  data-fidelity-vs-aesthetics tradeoff concrete. Smoothing
  earned its place in the toolkit this session, with the
  refinement that example selection determines whether the
  rendering looks like a published map or like processed
  output.
- **One alternative example** for variation — Hawaii
  Island for the research-historical Mauna Loa transect
  overlay, held in reserve. Use if the chapter wants the
  research-history grounding; otherwise reference only.
- **Reference, not implementation**, for the other queued
  examples (IBP biome programs combined, California map
  version, comparative cross-continental pairs). The chapter
  mentions them as further demonstrations the toolkit
  supports without including their figures.

This keeps the chapter from accumulating figures
proportionate to the toolkit's flexibility. The toolkit is
extensible; the chapter is selective.

**Update (2026-05-22).** The top-heaviness this section
guards against is now addressed structurally as well: the
material is two chapters, not one (see "Split into two
chapters" above). The example budget still holds, now
distributed across the pair — Oahu as the canonical example
in "Build a Map," the Oahu and Oregon smoothing contrast
pair in "Beyond a Map," Hawaii Island still in reserve,
the rest reference-only. Two chapters of ordinary length
replace one oversized one.

## Open questions

- **Smoothing implementation**: which approach goes into
  the toolkit first? Vector smoothing is purely cosmetic
  and lowest-risk; pre-classification smoothing has the
  largest data-fidelity impact and may want to be
  user-applied rather than toolkit-provided.

- **KML export**: which R toolchain (`sf::st_write`,
  `plotKML`, `leaflet`)? Vector or raster default?

- **3D overlay as core toolkit feature vs. demonstration-only**:
  is `export_kml()` a real function the document expects
  users to call, or is the Google Earth integration a
  one-off demonstration the chapter walks through?

- **The hypothesis-test section (Thread 7)**: include in
  this chapter, or reference forward to a separate
  document (Path B from design file Thread 5)?

- **Sidebar on the pre-digital tools**: how detailed?
  Naming copy cameras, rubylith, ruby cutters in passing,
  or a longer descriptive paragraph with Kim's
  first-person witness?

- **Chapter title**: "Mapping Biomes," "From Classification
  to Map," "Biome Maps," "Spatial Visualization of Biomes."
  Working title is "Mapping Biomes" — concrete and
  specific.

- **Final ordering of refinement threads (4, 5, 6)**:
  smoothing then boundary then 3D, or some other
  sequence? Each is independent so order is editorial.

- **Relationship to the Scale chapter**: how much
  forward-reference to scale concepts (`name_biome()`
  at 2.5' vs 30" is a scale choice; smoothing is a
  scale choice; map vs region is a scale choice). The
  Mapping chapter is the place where scale choices
  become most visible; possibly the chapter where the
  Scale chapter's prescriptions get exercised most
  thoroughly.

## Next session — drafting / continued ideation checklist

1. Re-read this file plus
   `design_classification_to_mapping.md` Threads 2, 3,
   5, 7, plus `cartography_context.md` plus the
   relevant `example_ideas.md` entries.
2. Implement `map_biomes()` with at least the basic
   tessellation pipeline (Thread 3). Oahu as the first
   smoke test.
3. Try one smoothing approach (likely vector smoothing
   first — lowest risk).
4. Attempt a small KML export (Hawaii Island would be a
   strong test).
5. Draft the chapter only after the toolkit has
   produced at least one tessellation map and one KML
   overlay — the chapter benefits from concrete figures
   to discuss rather than abstract proposals.

Estimated length when drafted: ~2,500–4,000 words —
the longest of the chapters because it carries multiple
techniques, multiple examples, and the methodological
closing. Plus four or five figures: basic tessellation,
smoothed variant(s), boundary-representation variants,
the 3D overlay screenshot.
