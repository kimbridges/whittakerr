# whittakerr

Whittaker biome classification and mapping in R.

`whittakerr` classifies locations into Whittaker biomes using two
climate variables: annual mean temperature and annual
precipitation. It supports point-based classification,
Whittaker-diagram plotting, geographic biome mapping at multiple
resolutions, vector smoothing of biome boundaries, and KML export
for viewing biome maps draped on Google Earth's terrain.

Climate data is retrieved from WorldClim via the `geodata`
package. Both the 1970–2000 historical baseline and CMIP6
future-scenario projections are supported under one function
signature.

## Installation

`whittakerr` is not on CRAN. Install it from GitHub:

```r
library(devtools)
install_github("kimbridges/whittakerr")
```

## Quick start

Classify a single climate point. Precipitation is in centimetres
throughout the package (matching the Whittaker diagram's native
unit).

```r
library(whittakerr)

# A warm, moderately wet location
name_biome(mean_temp_c = 25, total_ppt_cm = 250)
#> "Tropical seasonal forest/savanna"

# A cold, dry location
name_biome(mean_temp_c = -10, total_ppt_cm = 20)
#> "Tundra"
```

Plot the Whittaker diagram, with or without data points:

```r
# The bare diagram
plot_biomes()

# The diagram with three labeled cities
plot_biomes(
  mean_temp_c  = c(23, 17, 11),
  total_ppt_cm = c(55, 30, 95),
  label        = c("Honolulu", "Los Angeles", "Seattle")
)
```

## What the package provides

**Climate retrieval**

- `get_climate()` — annual mean temperature and annual
  precipitation at one or more points, from WorldClim v2.1
  (historical or CMIP6 future).

**Classification**

- `name_biome()` — classify a single temperature-precipitation
  pair into a Whittaker biome.
- `map_biomes()` — build a biome map for a region polygon at a
  chosen resolution.

**Rendering**

- `plot_biomes()` — render in temperature-precipitation diagram
  space, with optional point and label overlays.
- `smooth_biome_map()` — add smoothed boundary polygons to a
  biome map.
- `plot_biome_map()` — render a biome map in geographic space,
  in gridded or smoothed form.
- `export_biome_kml()` — write a KML file for Google Earth,
  with biome polygons clamped to terrain.

**Bundled data**

- `Whittaker_biomes` — polygon vertices defining the nine biomes.
- `Ricklefs_colors` — the categorical color palette.

## Climate data and caching

The first call to `get_climate()` or `map_biomes()` for a given
resolution downloads the relevant WorldClim dataset (several
hundred MB at 2.5-minute resolution). Downloads are cached. The
default cache location is `cache/worldclim_cache` relative to the
working directory; override the `cache_path` argument to use
another location, such as
`tools::R_user_dir("whittakerr", "cache")` for a persistent
user-level cache.

## Data sources and attribution

The bundled `Whittaker_biomes` and `Ricklefs_colors` datasets are
vendored from the `plotbiomes` R package, which digitized them
from Whittaker's biome diagram as presented in Ricklefs's
textbook. Any use of this package's data should cite both
sources:

> Ștefan, V. & Levin, S. (2018). plotbiomes: R package for
> plotting Whittaker biomes with ggplot2. v1.0.0. Zenodo.
> https://doi.org/10.5281/zenodo.7145245

> Ricklefs, R. E. (2008). *The Economy of Nature* (6th ed.).
> W. H. Freeman and Company.

See `data-raw/SOURCES.md` in the package source for the full
attribution block and digitization protocol.

## License

MIT. See the `LICENSE` file.
