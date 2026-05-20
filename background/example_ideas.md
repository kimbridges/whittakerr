# Whittakerr Example Ideas — a working catalog

_Started 2026-05-15. A curated list of demonstration ideas
that the whittakerr document can draw on when showing
features or building chapter examples. Not a commitment list
— a stocked bench, so figure-building work doesn't drag
scope-finding work behind it._

## How this file is used

When the document needs a figure that demonstrates a specific
feature (color-by-group encoding, climate-change shift,
labels at low N, etc.), browse the catalog for an example
that fits. When a new example idea occurs, add an entry here
with its status, data, what it shows, and which features it
would demonstrate. Use the reverse mapping at the bottom of
the file to go from feature → example.

---

## Entries

### CA Botanical Gardens — historical and future (implemented)
- **Status**: Working as the smoke test (`Whittakerr_climate.Rmd`).
  Produces two figures saved to `images/`.
- **Data**: `data/Bot_Garden_Geocode_CSV.csv`, filtered to
  `State == "CA"` (~50 gardens).
- **Shows**: Distribution of a regional plant-collection set
  across multiple biomes; per-garden biome shift under
  climate change (historical vs SSP2-4.5 mid-century).
- **Features demonstrated**: `get_climate()` (historical and
  future), `plot_biomes()` with multiple points and source
  caption.
- **Notes**: Labels intentionally dropped — at this N,
  distribution carries the story.

### NE US Botanical Gardens (queued)
- **Status**: Data available (same CSV, different state
  filter).
- **Shows**: Comparative regional contrast with CA —
  continental seasonal climate vs Mediterranean dry-summer
  climate. Should occupy a markedly different region of the
  Whittaker diagram.
- **Features demonstrated**: regional comparison; multi-panel
  figures; color-by-region encoding when paired with CA.
- **To decide**: which states constitute "NE US" — strict
  (ME/NH/VT/MA/RI/CT) or extended (add NY/NJ/PA/MD/DE).
- **Variant**: a single combined figure with CA in one color
  and NE US in another, both on the same diagram, illustrates
  cross-regional biome separation at a glance.

### IBP Desert Biome study sites (queued)
- **Status**: Locations need assembly. Kim has firsthand
  authority — he was Asst. Director of the Desert Biome
  study (one of the US/IBP biome programs of the early
  1970s). See `background/ibp_desert_biome_context.md`.
- **Shows**: Five study sites *within* the Desert biome
  category, each in a different desert type (Great Basin,
  Mojave, Sonoran, Chihuahuan, and one more). Sites occupy
  different positions in T-P space despite all being
  "desert" — intra-biome heterogeneity that categorical
  schemes gloss. Edge-thinking payoff (Thread 7): even
  inside one category, the variation matters.
- **Features demonstrated**: small-N labeled scatter; color
  by desert type; the gradient view operating within a
  category.
- **Self-referential note**: these were explicitly *biome*
  studies. Plotting their sites on the Whittaker biome
  diagram is biome research history meeting biome
  classification — a pedagogically pleasing recursion.

### IBP Grassland Biome study sites (queued)
- **Status**: Public record; site list findable. Kim's
  memory of site count is fuzzy.
- **Shows**: Same form as Desert Biome but for grassland —
  pair with Desert Biome sites as a multi-program plot.
- **Features demonstrated**: cross-program color encoding;
  biome-typed sites all on one diagram.

### IBP biome programs combined (queued)
- **Status**: Synthesis of the above; data assembly
  required. Five US/IBP biome programs: Eastern Deciduous
  Forest (Oak Ridge), Grassland (Pawnee), Desert (Utah State
  + sites), Coniferous Forest (Pacific Northwest), Tundra
  (Alaska / Barrow).
- **Shows**: All five major NSF biome programs' study sites
  on one Whittaker diagram — direct visualization of the
  era's biome categorization choice mapped onto Whittaker's
  classification. Each program's sites cluster in or near
  its named biome's polygon — except where the field sites
  push the category boundary.
- **Features demonstrated**: large multi-color scatter;
  legend by research program; possibly highlight relevant
  biome polygons for each program in the same color.
- **Pedagogical value**: shows the institutional shape of
  biome research and Whittaker's scheme as the underlying
  map. This is also strong material for the History chapter
  (Ch 1).

### Mauna Loa elevational transect (queued)
- **Status**: Data may be available via Kim's Island
  Ecosystems IRP work. See
  `background/island_ecosystems_context.md`. Original
  transect data accessibility is queued.
- **Shows**: Multiple biomes within ~30 km horizontal
  distance; tropical lowland → alpine cold via single
  vertical traverse. One transect crossing several Whittaker
  positions.
- **Features demonstrated**: elevation gradient as a path
  on the diagram; possibly an animated or trace-style
  figure; one transect, many biomes.
- **Authorial-authority note**: Kim was Asst. Director of
  this study; the transect data is his.

### Comparative cross-continental pairs (from original outline)
- **Status**: Listed in `background/Whittakerr Notes.md` as
  part of the original document outline.
- **Shows**: Southern California vs South Africa
  (Mediterranean-type climates on different continents);
  Japan vs Pacific Northwest (temperate maritime
  convergence).
- **Features demonstrated**: convergent evolution made
  visible — distant places occupying the same biome on the
  diagram despite zero floristic overlap. The
  function-over-identity thread (design file Thread 4) made
  concrete.

### Major international cities (queued)
- **Status**: City coordinates publicly available; no data
  assembly difficulty.
- **Shows**: Global climate diversity; cities at biome
  edges; "where I live" intuitive uptake for international
  readers.
- **Features demonstrated**: large-N scatter (optionally
  labeled for a smaller subset); grouping by continent or
  Köppen class for comparison; helps non-North-American
  readers locate themselves on the diagram.

### Oahu biome map at 30" with coastline boundary (queued)
- **Status**: Implementation pending; data accessible via
  `geodata` package we already use.
- **Shows**: A regional biome map at fine resolution (~1 km
  cells) over a single Hawaiian island, with the coastline
  rendered as the boundary. Windward Koolau (wet, possibly
  tropical rain forest territory), leeward south shore
  (rain shadow — subtropical desert or woodland/shrubland),
  central plain, and Wahiawa highlands would likely show
  as distinct biome assignments within the island.
- **Why Oahu specifically**: Kim lives on the leeward side
  and registered the idea while watching a passing shower
  from a rain-shadow vantage point. The roughly 4× rain
  shadow effect between windward and leeward Oahu, within
  ~5 km horizontal, is exactly the case where the 2.5'
  resolution averages distinct climates and 30" doesn't.
  Honolulu (lon -157.86, lat 21.31) is the leeward anchor;
  Kaneohe / Lanikai on windward; Mt Kaala the central
  peak.
- **Features demonstrated**: regional biome mapping at fine
  resolution (the first concrete instance of design file
  Thread 3); coastline boundary as both visual context and
  data edge; intra-island biome heterogeneity; the
  windward-leeward distinction made spatial; the case for
  30" resolution made tangible.
- **Implementation outline**:
  1. Fetch Oahu polygon via `geodata::gadm(country = "USA",
     level = 2, path = ...)`, filter to Honolulu County,
     and crop to Oahu's bounding box (Honolulu County
     legally includes the Northwestern Hawaiian Islands so
     a bounding-box crop is needed). Alternative:
     `rnaturalearth::ne_states()` or a Hawaii state
     shapefile for cleaner single-island geometry.
  2. Call `get_climate()` with `resolution = 0.5` (30"
     in `geodata` terms; ~1 km cells). Note 30" is
     available for historical but not CMIP6 future
     scenarios.
  3. `terra::crop()` then `terra::mask()` the climate
     raster to the Oahu polygon.
  4. Apply `name_biome()` to each remaining cell — likely
     via `terra::app()` or by extracting centroid
     coordinates and looping.
  5. Plot with `ggplot2::geom_spatraster()` (from
     `tidyterra`) for the biome-colored cells, plus
     `geom_sf()` for the coastline overlay.
- **Edge concerns**: WorldClim cells straddling the coast
  may have land-sea-mixed values or come back as NA. The
  map will need to either tolerate NA cells (rendering them
  as transparent or a neutral color) or clip more
  aggressively. Worth showing the unmasked vs masked
  versions side-by-side as a teaching point about what
  "biome of an island" means.
- **Possible extension**: same treatment for the Big Island
  (Mauna Loa transect example would then be a line through
  this map rather than a standalone abstraction), Kauai,
  Maui. A Hawaii-wide multi-panel becomes plausible.

### Hawaii Island biome map at 30" with coastline boundary (queued)
- **Status**: Implementation pending; same toolchain as
  Oahu entry. Likely the stronger of the two Hawaii
  examples once both are built.
- **Shows**: A regional biome map at fine resolution (~1
  km cells) over the Big Island, with the coastline as the
  boundary. The Hilo-Kawaihae precipitation gradient (~14×,
  Hilo ~3,500 mm/year, Kawaihae ~250 mm/year within ~80 km
  horizontal) and the sea-level-to-4,200m elevational range
  on Mauna Kea and Mauna Loa together produce a much
  richer biome diversity per frame than Oahu.
- **Why it's the stronger example**: bigger canvas means
  more cells (~10,000 km² vs Oahu's ~1,500 km²), reduced
  proportional impact of coastal NA values, more biome
  variation visible per single map. Also fewer
  cell-spans-coast edge cases as a fraction of total
  cells.
- **Research-historical overlay**: Kim's Mauna Loa transect
  from the Island Ecosystems IRP work runs through this
  terrain, with Kilauea as the lower anchor (see
  `island_ecosystems_context.md`). The transect points
  can be overlaid as a line on the biome map, making the
  IBP-era research sites visible against the climate-
  predicted biomes. This is the same self-referential
  move proposed for the IBP biome programs combined
  figure, but at the island scale.
- **Features demonstrated**: regional biome mapping at
  fine resolution; large-scale climate gradient
  (precipitation and temperature both varying
  dramatically); transect-as-line overlay on a biome map;
  research-historical context as figure content.
- **Implementation**: Same pipeline as Oahu (GADM via
  geodata, terra crop/mask, get_climate at resolution =
  0.5, name_biome per cell, ggplot2 + geom_spatraster +
  geom_sf). For the transect overlay, an additional
  `geom_path()` or `geom_point()` layer with the transect
  coordinates. Hawaii County is the GADM filter (the
  island IS one county, no bounding-box gymnastics
  needed unlike Oahu).
- **Possible extension**: a Hawaii-archipelago multi-panel
  with all eight major islands at fixed scale, each showing
  its own biome map. Demonstrates regional biome variation
  at archipelago scale.

### USDA Hardiness Zones vs Whittaker biomes (queued)
- **Status**: Data already in hand — `Bot_Garden_Geocode_CSV.csv`
  has a `Hardiness` column alongside `lon`/`lat`. Compute
  biome via `get_climate() → name_biome()` and pair with
  the existing Hardiness column.
- **Shows**: Two classification systems applied to the
  same points. Disagreements are interpretable — "hardiness
  warm enough but biome desert" reveals the
  precipitation-decoupling assumption; "hardiness too cold
  but biome rich" reveals the mean-vs-extreme assumption.
- **Features demonstrated**: side-by-side categorization;
  comparison-of-classification-systems frame. Design file
  Thread 8 (agency model) made concrete; Thread 9
  (diagram-as-system) made comparative.

---

## Reverse mapping — feature → example

| Feature to demonstrate | Examples to draw on |
|---|---|
| Multiple-point overlay with labels | CA gardens (small N), Cities plot, IBP Desert Biome |
| Multiple-point overlay without labels (dense) | CA gardens future-scenario, International cities (large N) |
| Color-by-group encoding | IBP programs combined, CA + NE US gardens combined |
| Climate-change biome shift | Any with historical + future via `get_climate()`; CA gardens implemented |
| Single-region elevation traverse | Mauna Loa transect |
| Cross-continental same-biome (convergent evolution) | Comparative pairs (SC↔SA, Japan↔PNW) |
| Intra-biome heterogeneity | IBP Desert Biome (5 sites within one category) |
| Accessibility-first labeled diagram | Centroid-labeled variant (toolkit feature, see below) |
| Comparison of classification systems | USDA Hardiness vs Whittaker biomes (gardens CSV) |
| Self-referential (biome research × biome scheme) | IBP biome programs combined |

---

## Toolkit features that the examples will need

These are queued toolkit enhancements that the examples list
implies. Listed here so the example catalog doesn't lose
sight of the implementation work behind it.

- **`plot_biomes(legend_style = "color_labeled" | ...)`** —
  centroid labels at each polygon, secondary encoding for
  accessibility. Centroid computation: group polygon
  vertices by `biome_id`, compute mean (quick) or true
  polygon centroid (cleaner, e.g., via `sf::st_centroid()`).
  Numbered legend matches the labels. Queued.
- **`map_biomes(region_polygon, resolution = 0.5, ...)`** —
  a new function (vs `plot_biomes`'s diagram-space plotting)
  that produces a *geographic* biome map for a specified
  region. Bundles the crop-mask-classify-plot pipeline:
  fetch climate raster at the requested resolution, crop
  and mask to the region polygon, apply `name_biome()` per
  cell, render with the polygon as boundary overlay.
  Connects design file Thread 3 (regional tessellation
  maps) to concrete implementation. First worked example:
  Oahu at 30" (see Oahu entry above). Requires `terra`,
  `sf`, and either `tidyterra` (for `geom_spatraster`) or
  base `terra::plot`. Queued.
- **Per-point color and size on plot_biomes()** —
  `plot_biomes(..., point_size = 3, point_color = "white",
  point_fill = "black")` where each of those three accepts
  either a scalar (uniform across all points, current
  behavior) or a vector (element-wise, one per point).
  Captures three distinct use cases Kim flagged 2026-05-15:

  1. **Visual hierarchy via size**: primary location as
     large point, secondary/peripheral locations as smaller
     points. Worked example: Mauna Loa transect with
     Kilauea as the lower anchor (large) and sample sites
     as secondaries (smaller). Belongs near where labels
     are taught — probably the Basic Whittaker Diagrams
     chapter (Ch 6 in the provisional sequence).

  2. **Color by data origin**: distinguish WorldClim
     retrievals from METAR observations or from station
     data when a figure mixes sources. Useful for honesty
     (these are different kinds of data) and for
     interpretation (different temporal aggregation,
     different spatial scale). Belongs in the Colors
     chapter.

  3. **Color for visibility against biome backgrounds**: a
     black point on dark-green tropical rain forest reads
     poorly; white points on tan subtropical desert read
     poorly. Configurable border (color) and fill (color)
     parameters let the figure-maker choose for the
     specific layout. Also belongs in the Colors chapter
     as the practical-visibility companion to palette
     choice.

  Implementation note: the API takes raw vectors rather
  than introducing a grouping abstraction. Users who want
  grouped color do the mapping in their own code (a
  one-liner with `dplyr::case_when()` or named-vector
  lookup). The chapter can demonstrate both styles. If a
  grouped/palette interface eventually proves desirable,
  it can be added as a layer on top without breaking the
  raw-vector version. Implementation effort small —
  parameters pass through to `geom_point()`.

  Supersedes the earlier "Color-by-group for points"
  entry, which expressed the same need at a smaller
  scope.
- **Multi-panel / faceted figures** — for historical vs
  future side-by-side at fixed scale, or for region
  comparisons. ggplot2 facet support is fine but would need
  a wrapper convention. Queued.
- **Pair-with-reference annotation** — for cross-continental
  pairs, would want to connect paired points with a thin
  line. Queued.
- **Label-subset / "auto" labeling** — labels at low N work
  fine; at high N they clutter. Auto-labeling logic (edges,
  one-per-biome, user-selected subset) was flagged in
  session_log.md 2026-05-14 and remains queued.

---

## Sidebars and teaching elements

Smaller content pieces — tables, callouts, sidebar
explanations — that aren't figures themselves but should be
ready when the relevant chapter gets drafted.

### Cell-size-by-latitude sidebar (queued)

- **Status**: Content drafted; goes in Chapter 3
  (Retrieving Climate Data).
- **What it is**: A short numbered table showing the
  approximate ground area of a 2.5-arcminute WorldClim cell
  at different latitudes, plus a brief explanation of why
  cells shrink toward the poles, plus a "what this means
  for point retrievals" paragraph.

- **The table (from Kim 2026-05-15)**:

| Latitude | Side (long. × lat.) | Cell area |
|---|---|---|
| 0° (Equator) | 4.63 km × 4.63 km | 21.45 km² |
| 21° (Honolulu) | 4.32 km × 4.63 km | ~20.0 km² |
| 30° (New Orleans) | 4.01 km × 4.63 km | 18.60 km² |
| 45° (Minneapolis) | 3.27 km × 4.63 km | 15.18 km² |
| 60° (Oslo) | 2.32 km × 4.63 km | 10.75 km² |

  (Honolulu row computed locally to show the Hawaii case
  explicitly; other rows from the source table Kim shared.)

- **The geometry to explain**: an arcminute of latitude is
  essentially constant in distance (~1.85 km per minute,
  ~4.63 km per 2.5 minutes). An arcminute of longitude is
  `cos(latitude) × 1.85 km`, so it shrinks toward the
  poles. At the equator, cells are square; at higher
  latitudes, they're rectangular (narrow east-west, normal
  north-south).

- **What it means for point retrievals**: a "point" climate
  value from `get_climate()` is actually a cell average over
  the area in the table. In flat regions with low climate
  variation, this is fine. In regions with sharp gradients
  — coast vs interior, windward vs leeward, lowland vs
  upland — a 2.5' cell can average across distinct climates.

- **Hawaii-specific note**: at Honolulu's ~21°N, cells are
  ~4.3 × 4.6 km. Hawaii's elevational gradient covers
  sea-level to 4,200m within ~30 km horizontal (Mauna Kea),
  so a single 2.5' cell can span 600m of elevation. The
  windward-leeward rain shadow boundary on Oahu can also
  fall within a single cell, even though precipitation
  differs ~4× across it. This is the case where the 30"
  WorldClim option (~1 km, available for historical but
  not CMIP6 future) would help.

- **Why it belongs in the chapter**: the chapter is about
  retrieving climate data; readers need to understand what
  resolution means before they trust the values. The
  sidebar also connects to design file Thread 1 (display
  constraints) and Thread 7 (edges as locus of insight) —
  resolution matters most at climate boundaries, exactly
  where the most informative findings live.

- **Possible extension**: a small R chunk computing and
  visualizing the cell sizes — a horizontal bar plot or
  small map could make the variation tangible. Optional.

---

## Adding new examples

When a new example occurs, add an entry above with: status,
data needed, what it shows, which features it would
demonstrate, and provenance / notes. Sidebar entries
(tables, callouts, teaching elements) go in the Sidebars
section above. Keep it lean — the goal is a ready bench,
not a comprehensive treatise.
