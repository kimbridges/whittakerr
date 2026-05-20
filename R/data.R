## ============================================================
## data.R
##
## Roxygen2 documentation for the bundled package datasets.
## The actual binary .rda files in data/ are generated from
## the CSVs in data-raw/ by usethis::use_data().
##
## ============================================================


#' Whittaker biome polygon vertices
#'
#' A data frame of vertices defining the polygons in
#' Whittaker's biome diagram. Each row is one vertex of one
#' biome polygon; rows are ordered so that the polygons can
#' be reconstructed in sequence.
#'
#' @format A data frame with 775 rows and 4 columns:
#'   \describe{
#'     \item{temp_c}{Annual mean temperature at the vertex
#'       (degrees Celsius).}
#'     \item{precp_cm}{Annual precipitation at the vertex
#'       (centimetres). Note: the column is in cm; this is
#'       the diagram's native unit.}
#'     \item{biome_id}{Integer 1-9 identifying which biome
#'       polygon this vertex belongs to.}
#'     \item{biome}{Character. The biome name corresponding
#'       to \code{biome_id}. One of: tropical seasonal forest,
#'       subtropical desert, temperate rain forest, tropical
#'       rain forest, woodland/shrubland, tundra, boreal
#'       forest, temperate grassland, temperate seasonal
#'       forest.}
#'   }
#'
#' @source Digitized originally from Ricklefs, R. E. (2008).
#'   \emph{The Economy of Nature} (6th ed.), Figure 5.5.
#'   Vendored to this package from the plotbiomes R package
#'   (Ștefan, V. and Levin, S., 2018,
#'   \url{https://github.com/valentinitnelav/plotbiomes}).
#'   See \code{data-raw/SOURCES.md} in the package source for
#'   the full attribution block and digitization protocol.
#'
#' @examples
#' head(Whittaker_biomes)
#' table(Whittaker_biomes$biome)
"Whittaker_biomes"


#' Ricklefs biome color palette
#'
#' A named character vector mapping each of Whittaker's nine
#' biomes to a hex color string. The colors are the
#' categorical palette used in Ricklefs's textbook figure,
#' digitized from the original PostScript.
#'
#' @format A named character vector of length 9. Names are
#'   biome names (matching \code{Whittaker_biomes$biome});
#'   values are hex color strings (\code{"#RRGGBB"}).
#'
#' @source Color values originally extracted from the
#'   Ricklefs 2008 PostScript figure. Vendored to this
#'   package from the plotbiomes R package
#'   (Ștefan, V. and Levin, S., 2018). See
#'   \code{data-raw/SOURCES.md} in the package source for the
#'   full attribution block.
#'
#'   Users who want to build their own palette can copy this
#'   structure: a named character vector with biome names as
#'   names and hex colors as values.
#'
#' @examples
#' Ricklefs_colors
#' # Pull the color for one biome:
#' Ricklefs_colors[["Tropical rain forest"]]
"Ricklefs_colors"
