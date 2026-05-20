## ============================================================
## map_biomes.R
##
## Geographic biome mapping over a region polygon. Complements
## plot_biomes() (T-P diagram space) with map_biomes()
## (geographic space). See background/chapter_mapping_ideas.md
## for the design discussion.
##
## ============================================================


#' Build a biome map for a region polygon
#'
#' Fetches WorldClim climate data at the chosen resolution,
#' crops and masks to a region polygon, and classifies each
#' cell into a Whittaker biome. Returns a list bundling the
#' classified raster, the region polygon, and the biome
#' lookup, suitable for downstream rendering and KML export.
#'
#' @param region_polygon A SpatVector polygon (terra) or any
#'   object that \code{\link[terra]{vect}} can coerce. The
#'   geographic extent of the map.
#' @param resolution Numeric. WorldClim resolution in
#'   arc-minutes. Valid values: 10, 5, 2.5, or 0.5 (30
#'   arc-seconds). Default 2.5, the document's standard.
#' @param cache_path Character. Directory for cached
#'   WorldClim downloads. Default
#'   \code{"cache/worldclim_cache"} (relative to the current
#'   working directory). Override with another path (e.g.,
#'   \code{tools::R_user_dir("whittakerr", "cache")}) for a
#'   persistent user-level cache.
#'
#' @return A list with class \code{"biome_map"} containing:
#'   \describe{
#'     \item{biome_raster}{A \code{SpatRaster} of biome IDs
#'       (1-9; NA for ocean or out-of-extent cells).}
#'     \item{region}{The input region as a \code{SpatVector}.}
#'     \item{biome_names}{The ordered names from
#'       \code{Ricklefs_colors}.}
#'     \item{biome_colors}{The named character vector of
#'       biome colors (Ricklefs palette).}
#'     \item{resolution}{The resolution used.}
#'     \item{centroid_lon}{Region centroid longitude.}
#'     \item{centroid_lat}{Region centroid latitude.}
#'   }
#'
#' @details Pipeline: fetch the WorldClim bioclim raster
#'   (\code{worldclim_global} for res >= 2.5'; \code{worldclim_tile}
#'   for 30 arc-seconds via region centroid), subset to BIO1
#'   (annual mean temperature, °C) and BIO12 (annual
#'   precipitation, mm), crop and mask to the region polygon,
#'   apply \code{\link{name_biome}} to each cell with the
#'   appropriate mm-to-cm conversion, and return the bundled
#'   result.
#'
#'   Scale-choice context: at 2.5' resolution (~5 km cells),
#'   the climate raster averages substantial within-cell
#'   heterogeneity. At 30 arc-seconds (~1 km), local features
#'   like rain-shadow pockets become visible. See the Scale
#'   chapter of the whittakerr document for the worked
#'   discussion.
#'
#' @importFrom geodata worldclim_global worldclim_tile
#' @importFrom terra vect centroids geom values res ext crop mask
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Oregon at 2.5-minute resolution
#' us_states <- geodata::gadm(country = "USA", level = 1,
#'                            path = "data/gadm_cache")
#' oregon <- us_states[us_states$NAME_1 == "Oregon", ]
#' oregon_map <- map_biomes(region_polygon = oregon,
#'                          resolution     = 2.5)
#' plot_biome_map(oregon_map)
#' }
map_biomes <- function(region_polygon,
                       resolution = 2.5,
                       cache_path = "cache/worldclim_cache"){

  ## Coerce to SpatVector if not already.
  if (!inherits(region_polygon, "SpatVector")) {
    region_polygon <- terra::vect(region_polygon)
  }

  ## Region centroid for tile lookup at 30 arcsec.
  centroid    <- terra::centroids(region_polygon)
  cen_coords  <- terra::geom(centroid)
  lon         <- cen_coords[1, "x"]
  lat         <- cen_coords[1, "y"]

  ## Ensure cache exists.
  dir.create(cache_path,
             showWarnings = FALSE,
             recursive    = TRUE)

  ## Fetch bioclim raster. At 30 arcsec WorldClim is
  ## tile-distributed; at coarser resolutions it's global.
  if (resolution >= 2.5) {
    bio_raster <- geodata::worldclim_global(
      var  = "bio",
      res  = resolution,
      path = cache_path
    )
  } else {
    bio_raster <- geodata::worldclim_tile(
      var  = "bio",
      lon  = lon,
      lat  = lat,
      path = cache_path
    )
  }

  ## Subset to BIO1 (annual mean T, °C) and BIO12
  ## (annual precipitation, mm).
  bio_subset <- bio_raster[[c(1, 12)]]

  ## Crop and mask to the region polygon.
  cropped <- terra::crop(bio_subset, region_polygon)
  masked  <- terra::mask(cropped,    region_polygon)

  ## Extract climate values for every cell.
  vals <- terra::values(masked)

  ## Classify each cell. name_biome is scalar-only, so loop.
  ## Convert precipitation from mm (WorldClim native unit) to
  ## cm (the unit name_biome expects, matching the underlying
  ## Whittaker_biomes$precp_cm polygon data).
  biome_assignment <- character(nrow(vals))
  for (i in seq_len(nrow(vals))) {
    if (is.na(vals[i, 1]) || is.na(vals[i, 2])) {
      biome_assignment[i] <- NA_character_
    } else {
      biome_assignment[i] <- name_biome(
        mean_temp_c  = vals[i, 1],
        total_ppt_cm = vals[i, 2] / 10
      )
    }
  }

  ## Build a single-layer raster carrying biome IDs (1-9)
  ## matching the Ricklefs_colors order.
  biome_id_vec <- match(biome_assignment, names(Ricklefs_colors))

  biome_raster <- masked[[1]]
  terra::values(biome_raster) <- biome_id_vec
  names(biome_raster) <- "biome_id"

  ## Assemble result.
  result <- list(
    biome_raster  = biome_raster,
    region        = region_polygon,
    biome_names   = names(Ricklefs_colors),
    biome_colors  = Ricklefs_colors,
    resolution    = resolution,
    centroid_lon  = lon,
    centroid_lat  = lat
  )
  class(result) <- c("biome_map", "list")
  return(result)

} ## End function map_biomes


#' Smooth the biome boundaries in a biome_map
#'
#' Converts the classified raster to dissolved polygons (one
#' per biome), smooths the polygon edges, and adds the
#' result to the biome_map list as a parallel vector
#' representation. The original raster is preserved unchanged.
#'
#' @param biome_map A \code{"biome_map"} list returned by
#'   \code{\link{map_biomes}}.
#' @param method Smoothing method passed to
#'   \code{\link[smoothr]{smooth}}. Default \code{"ksmooth"}
#'   (natural curves). Other options: \code{"chaikin"}
#'   (corner-cutting), \code{"spline"} (smoothest curves).
#' @param smoothness Numeric. Smoothness factor for ksmooth.
#'   Higher = smoother. Default 1.
#'
#' @return The input \code{biome_map} augmented with two
#'   additional fields:
#'   \describe{
#'     \item{biome_polygons}{A \code{SpatVector} with one
#'       (multi-)polygon per biome type, edges smoothed.}
#'     \item{smoothing}{List with \code{method} and
#'       \code{smoothness} recorded.}
#'   }
#'
#' @details Data fidelity: vector smoothing changes ONLY how
#'   boundaries are drawn. The underlying biome assignment
#'   per cell is unchanged. Subtropical desert pockets at
#'   Kaena Point and the Waianae lee on Oahu survive this
#'   operation; they would not survive pre-classification
#'   smoothing of the climate raster.
#'
#'   Single-cell biome assignments smooth to small circles —
#'   a mathematical artifact of \code{ksmooth} on a
#'   four-vertex square polygon with no neighboring vertices.
#'   Visible most often in topographically complex islands
#'   (Oahu); not visible in continental-gradient regions
#'   (Oregon). See \code{background/chapter_mapping_ideas.md}
#'   for the discussion.
#'
#' @importFrom terra as.polygons vect
#' @importFrom sf st_as_sf
#' @importFrom smoothr smooth
#'
#' @export
#'
#' @examples
#' \dontrun{
#' oregon_map <- map_biomes(oregon, resolution = 2.5)
#' oregon_map <- smooth_biome_map(oregon_map)
#' plot_biome_map(oregon_map, render = "vector")
#' }
smooth_biome_map <- function(biome_map,
                             method     = "ksmooth",
                             smoothness = 1){

  if (!inherits(biome_map, "biome_map")) {
    stop("smooth_biome_map expects a 'biome_map' object from map_biomes()")
  }

  ## Convert the classified raster to polygons. dissolve =
  ## TRUE merges contiguous cells with the same biome_id
  ## into a single (multi-)polygon per biome type.
  poly_terra <- terra::as.polygons(biome_map$biome_raster,
                                   dissolve = TRUE)

  ## Hand off to sf for smoothing (smoothr operates on sf
  ## objects).
  poly_sf <- sf::st_as_sf(poly_terra)

  ## Smooth the polygon edges.
  poly_smooth_sf <- smoothr::smooth(poly_sf,
                                    method     = method,
                                    smoothness = smoothness)

  ## Convert back to terra SpatVector to match the rest of
  ## the biome_map's coordinate-handling stack.
  poly_smooth <- terra::vect(poly_smooth_sf)

  ## Augment the biome_map.
  biome_map$biome_polygons <- poly_smooth
  biome_map$smoothing      <- list(method     = method,
                                   smoothness = smoothness)

  return(biome_map)

} ## End function smooth_biome_map


#' Render a biome_map as a 2D geographic plot
#'
#' Plots a \code{biome_map} object using terra's native
#' plotting. Two render modes: \code{"grid"} (the raw
#' classified raster, cell-level fidelity, pixelated
#' appearance) or \code{"vector"} (the smoothed polygons,
#' aesthetic continuity).
#'
#' @param biome_map A \code{"biome_map"} list returned by
#'   \code{\link{map_biomes}}, optionally augmented by
#'   \code{\link{smooth_biome_map}} for vector rendering.
#' @param render One of \code{"grid"} (default) or
#'   \code{"vector"}.
#' @param border_color Color for the region-boundary line.
#'   Default \code{"black"}.
#' @param border_width Line width for the region boundary.
#'   Default 0.6.
#' @param legend Logical. Whether to display the biome-color
#'   legend. Default \code{TRUE}.
#'
#' @return Invisibly returns the input \code{biome_map}.
#'   Called for its side effect (the plot).
#'
#' @details Vector mode rasterizes the smoothed polygons back
#'   to a higher-resolution raster and then uses the same
#'   terra plotting code path as grid mode. This guarantees
#'   identical color application and legend formatting
#'   between the two renderings; the only visual difference
#'   becomes smooth vs jagged biome boundaries.
#'
#' @importFrom terra as.factor plot lines rasterize res<- ext<-
#'
#' @export
#'
#' @examples
#' \dontrun{
#' oregon_map <- map_biomes(oregon, resolution = 2.5)
#' plot_biome_map(oregon_map)                     # grid mode
#' oregon_map <- smooth_biome_map(oregon_map)
#' plot_biome_map(oregon_map, render = "vector")  # smoothed
#' }
plot_biome_map <- function(biome_map,
                           render       = c("grid", "vector"),
                           border_color = "black",
                           border_width = 0.6,
                           legend       = TRUE){

  if (!inherits(biome_map, "biome_map")) {
    stop("plot_biome_map expects a 'biome_map' object from map_biomes()")
  }

  render <- match.arg(render)

  main_title <- paste0("Biome map at ", biome_map$resolution,
                       " arc-minute resolution (",
                       render, ")")

  if (render == "grid") {

    ## Categorical raster rendering.
    r    <- terra::as.factor(biome_map$biome_raster)
    lvls <- data.frame(
      ID    = seq_along(biome_map$biome_names),
      biome = biome_map$biome_names
    )
    levels(r) <- lvls

    terra::plot(r,
                col    = biome_map$biome_colors,
                type   = "classes",
                legend = legend,
                main   = main_title,
                mar    = c(5.1, 4.1, 4.1, 12.1))

  } else {

    ## Vector rendering. Requires biome_polygons.
    if (is.null(biome_map$biome_polygons)) {
      stop("biome_map has no biome_polygons. Run smooth_biome_map() first, or use render = \"grid\".")
    }

    poly <- biome_map$biome_polygons

    ## Rasterize smoothed polygons at higher resolution to
    ## reuse the grid-mode plotting code path.
    template <- biome_map$biome_raster
    terra::res(template) <- terra::res(template) / 5
    terra::ext(template) <- terra::ext(biome_map$biome_raster)
    poly_raster <- terra::rasterize(poly,
                                    template,
                                    field = "biome_id")

    rv   <- terra::as.factor(poly_raster)
    lvls <- data.frame(
      ID    = seq_along(biome_map$biome_names),
      biome = biome_map$biome_names
    )
    levels(rv) <- lvls

    terra::plot(rv,
                col    = biome_map$biome_colors,
                type   = "classes",
                legend = legend,
                main   = main_title,
                mar    = c(5.1, 4.1, 4.1, 12.1))

    ## Overlay smoothed polygon boundaries.
    terra::lines(poly,
                 col = "black",
                 lwd = 0.3)

  }

  ## Overlay the region boundary.
  terra::lines(biome_map$region,
               col = border_color,
               lwd = border_width)

  invisible(biome_map)

} ## End function plot_biome_map
