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
#'       (centimeters). Note: the column is in cm; this is
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


#' Biome color palettes
#'
#' A data frame of color palettes for the Whittaker biome
#' diagram, one palette per column, each mapping the nine
#' biomes to hex colors. \code{\link{plot_biomes}} selects a
#' palette through its \code{palette} argument.
#'
#' @format A data frame with 9 rows, one per biome, and the
#'   columns:
#'   \describe{
#'     \item{biome}{Biome name, matching
#'       \code{Whittaker_biomes$biome}.}
#'     \item{ricklefs}{The iconic Ricklefs palette: greens for
#'       forests, tans for arid biomes, pale tones for cold
#'       types. Identical to \code{\link{Ricklefs_colors}}.}
#'     \item{cvd}{A color-vision-deficiency-safe palette, Paul
#'       Tol's muted qualitative scheme. Its colors stay
#'       distinct under the common forms of color blindness;
#'       it does not follow landscape convention.}
#'     \item{grayscale}{A palette whose nine colors sit on an
#'       even luminance ladder, so the biomes stay distinct
#'       when the figure is converted to grayscale or
#'       photocopied. Biomes are ordered along a
#'       vegetation-density gradient, pale to dark.}
#'     \item{custom}{A purpose-tuned palette, built for an
#'       Oregon biome map. The design effort goes to the five
#'       biomes that occur in Oregon: the three forest types
#'       pushed far apart, the large expanses given calm
#'       colors, the small meandering biomes given salient
#'       ones. An example of tuning a palette to a specific
#'       map.}
#'   }
#'
#' @source The \code{ricklefs} column: see
#'   \code{\link{Ricklefs_colors}}. The \code{cvd} column: the
#'   muted qualitative scheme from Paul Tol, \emph{Colour
#'   Schemes} (SRON; \url{https://personal.sron.nl/~pault/}).
#'   The \code{grayscale} column: constructed for this
#'   package, nine colors on an even Rec.601 luminance
#'   ladder. The \code{custom} column: constructed for this
#'   package, tuned for the Oregon biome map.
#'
#' @examples
#' biome_palettes
#' # One palette as a named vector, ready for scale_fill_manual:
#' cvd <- biome_palettes$cvd
#' names(cvd) <- biome_palettes$biome
#' cvd
"biome_palettes"


#' Biome name abbreviations
#'
#' A data frame mapping each Whittaker biome's full name to a
#' short CamelCase abbreviation. The abbreviations are compact
#' enough to place as labels inside a Whittaker diagram or a
#' biome map, where the full names are too long to fit.
#' \code{\link{plot_biomes}} and \code{\link{plot_biome_map}}
#' use them through their \code{biome_labels} arguments.
#'
#' @format A data frame with 9 rows, one per biome, and the
#'   columns:
#'   \describe{
#'     \item{biome}{Biome name, matching
#'       \code{Whittaker_biomes$biome}.}
#'     \item{abbrev}{Short CamelCase abbreviation, for example
#'       \code{"TropRainFst"} for tropical rain forest. The
#'       pattern is consistent (Tmp, Trop, SubTrop for the
#'       climate zone; Fst, Seas, Rain, Gras, Dsrt for the
#'       rest), so a reader who sees a few can read the rest.}
#'     \item{label_temp}{Optional. Annual mean temperature
#'       (degrees C) at which to anchor this biome's label in
#'       a Whittaker diagram. \code{NA} means use the computed
#'       polygon centroid; a value overrides it, for biomes
#'       whose centroid sits poorly.}
#'     \item{label_precp}{Optional. Annual precipitation (cm),
#'       the counterpart to \code{label_temp}.}
#'   }
#'
#' @details The two-column structure also accommodates biome
#'   names in another language: add a further column and point
#'   the label-drawing code at it.
#'
#' @source Constructed for this package.
#'
#' @examples
#' biome_abbrev
#' # Look up one abbreviation:
#' biome_abbrev$abbrev[biome_abbrev$biome == "Tundra"]
"biome_abbrev"
