## ============================================================
## map_biomes.R
##
## Geographic biome mapping over a region polygon. Complements
## plot_biomes() (T-P diagram space) with map_biomes()
## (geographic space). See background/chapter_mapping_ideas.md
## for the design discussion.
##
## ============================================================


## ------------------------------------------------------------
## Sentinel category for in-region cells whose climate falls
## outside every Whittaker biome polygon. It occupies a
## reserved raster id (10, one past the nine biomes) and is
## always rendered in a fixed neutral gray, never recolored by
## a palette. This keeps unclassified land distinct from
## out-of-region area, which stays NA and renders as the plot
## background.
## ------------------------------------------------------------
.outside_label <- "Outside Whittaker range"
.outside_color <- "#C8C8C8"


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
#'   arc-seconds). Default 2.5, the document's standard. The
#'   0.5 (30-arcsecond) option is available for historical
#'   climate only.
#' @param scenario One of \code{"historical"} (default,
#'   1970-2000 WorldClim baseline) or \code{"future"} (a
#'   CMIP6 projection parameterized by \code{gcm},
#'   \code{ssp}, and \code{period}). A future scenario lets
#'   the same region be mapped under a projected climate, so
#'   a historical and a future biome map can be compared.
#' @param gcm Character. Global Climate Model identifier for
#'   future scenarios. Default \code{"MPI-ESM1-2-HR"}. See
#'   \code{\link[geodata]{cmip6_world}} for the supported set.
#' @param ssp Character. Shared Socioeconomic Pathway code
#'   for future scenarios. Default \code{"245"} (SSP2-4.5,
#'   middle-of-the-road emissions).
#' @param period Character. Time window for future scenarios.
#'   Default \code{"2041-2060"} (mid-century).
#' @param cache_path Character. Directory for cached
#'   WorldClim downloads. Default
#'   \code{"cache/worldclim_cache"} (relative to the current
#'   working directory). Override with another path (e.g.,
#'   \code{tools::R_user_dir("whittakerr", "cache")}) for a
#'   persistent user-level cache.
#'
#' @return A list with class \code{"biome_map"} containing:
#'   \describe{
#'     \item{biome_raster}{A \code{SpatRaster} of biome IDs.
#'       IDs 1-9 match the \code{Ricklefs_colors} order; id 10
#'       marks in-region cells whose climate falls outside the
#'       Whittaker scheme. NA marks ocean and out-of-region
#'       cells.}
#'     \item{region}{The input region as a \code{SpatVector}.}
#'     \item{biome_names}{The ordered names from
#'       \code{Ricklefs_colors}.}
#'     \item{biome_colors}{The named character vector of
#'       biome colors (Ricklefs palette).}
#'     \item{resolution}{The resolution used.}
#'     \item{scenario}{The climate scenario,
#'       \code{"historical"} or \code{"future"}.}
#'     \item{centroid_lon}{Region centroid longitude.}
#'     \item{centroid_lat}{Region centroid latitude.}
#'   }
#'   A future scenario also carries \code{gcm}, \code{ssp},
#'   and \code{period}.
#'
#' @details Pipeline: fetch the bioclim raster (for a
#'   historical scenario, \code{worldclim_global} for
#'   res >= 2.5' or \code{worldclim_tile} for 30 arc-seconds
#'   via the region centroid; for a future scenario,
#'   \code{cmip6_world}), subset to BIO1 (annual mean
#'   temperature, °C) and BIO12 (annual precipitation, mm),
#'   crop and mask to the region polygon, apply
#'   \code{\link{name_biome}} to each cell with the
#'   appropriate mm-to-cm conversion, and return the bundled
#'   result.
#'
#'   A future scenario draws on the same CMIP6 projections
#'   \code{\link{get_climate}} uses, set by \code{gcm},
#'   \code{ssp}, and \code{period}. It is available at 2.5
#'   arc-minutes and coarser, not at 30 arc-seconds.
#'
#'   Cells outside the Whittaker scheme: the Whittaker
#'   classification is a bounded envelope in
#'   temperature-precipitation space, not an exhaustive
#'   partition. A cell whose climate falls outside every
#'   biome polygon, for example the very wet, mild cells of
#'   the Pacific Northwest coastal mountains, cannot be
#'   classified. \code{name_biome} reports these as
#'   "unknown", and \code{map_biomes} records them under id
#'   10 as a distinct "Outside Whittaker range" category
#'   rather than discarding them. This is a real result, not
#'   an error.
#'
#'   Scale-choice context: at 2.5' resolution (~5 km cells),
#'   the climate raster averages substantial within-cell
#'   heterogeneity. At 30 arc-seconds (~1 km), local features
#'   like rain-shadow pockets become visible. See the Scale
#'   chapter of the whittakerr document for the worked
#'   discussion.
#'
#' @importFrom geodata worldclim_global worldclim_tile cmip6_world
#' @importFrom terra vect centroids geom values res ext crop mask
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Oregon at 2.5-minute resolution
#' us_states <- geodata::gadm(country = "USA", level = 1,
#'                            path = "cache/gadm_cache")
#' oregon <- us_states[us_states$NAME_1 == "Oregon", ]
#' oregon_map <- map_biomes(region_polygon = oregon,
#'                          resolution     = 2.5)
#' plot_biome_map(oregon_map)
#'
#' # The same region under a CMIP6 future projection
#' oregon_future <- map_biomes(region_polygon = oregon,
#'                             scenario       = "future")
#' }
map_biomes <- function(region_polygon,
                       resolution = 2.5,
                       scenario   = c("historical", "future"),
                       gcm        = "MPI-ESM1-2-HR",
                       ssp        = "245",
                       period     = "2041-2060",
                       cache_path = "cache/worldclim_cache"){

  ## Coerce to SpatVector if not already.
  if (!inherits(region_polygon, "SpatVector")) {
    region_polygon <- terra::vect(region_polygon)
  }

  ## Resolve the scenario and validate the combination.
  scenario <- match.arg(scenario)
  if (scenario == "future" && resolution == 0.5) {
    stop("30-arcsecond resolution (0.5) is available for historical climate only. CMIP6 future projections are distributed at 2.5 arc-minutes and coarser.")
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

  ## Fetch the bioclim raster for the chosen scenario. A
  ## future scenario uses the CMIP6 projection; a historical
  ## scenario uses WorldClim, which is one global grid at
  ## res >= 2.5' and tile-distributed at 30 arc-seconds.
  if (scenario == "future") {
    bio_raster <- geodata::cmip6_world(
      model = gcm,
      ssp   = ssp,
      time  = period,
      var   = "bioc",
      res   = resolution,
      path  = cache_path
    )
  } else if (resolution >= 2.5) {
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
      ## No climate data: the cell lies outside the region.
      biome_assignment[i] <- NA_character_
    } else {
      this_biome <- name_biome(
        mean_temp_c  = vals[i, 1],
        total_ppt_cm = vals[i, 2] / 10
      )
      ## name_biome returns "unknown" when a cell's climate
      ## falls outside every Whittaker polygon. Tag those
      ## in-region cells with the sentinel label so they stay
      ## distinct from the out-of-region NA cells above.
      biome_assignment[i] <- if (identical(this_biome, "unknown")) {
        .outside_label
      } else {
        this_biome
      }
    }
  }

  ## Build a single-layer raster carrying biome IDs. IDs 1-9
  ## match the Ricklefs_colors order; id 10 is the reserved
  ## sentinel for in-region cells outside the Whittaker
  ## scheme. Out-of-region cells stay NA.
  biome_id_vec <- match(biome_assignment,
                        c(names(Ricklefs_colors), .outside_label))

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
    scenario      = scenario,
    centroid_lon  = lon,
    centroid_lat  = lat
  )
  ## Record the projection parameters for a future scenario.
  if (scenario == "future") {
    result$gcm    <- gcm
    result$ssp    <- ssp
    result$period <- period
  }
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
#' aesthetic continuity). Supports alternate color palettes,
#' per-biome labels, location-point overlays, and direct
#' PNG export.
#'
#' @param biome_map A \code{"biome_map"} list returned by
#'   \code{\link{map_biomes}}, optionally augmented by
#'   \code{\link{smooth_biome_map}} for vector rendering.
#' @param render One of \code{"grid"} (default) or
#'   \code{"vector"}.
#' @param palette Color palette for the biomes. \code{NULL}
#'   (default) keeps the Ricklefs colors stored in the
#'   \code{biome_map}. Otherwise either the name of a
#'   built-in palette column in \code{\link{biome_palettes}}
#'   (for example \code{"cvd"}, \code{"grayscale"}, or
#'   \code{"custom"}) or a user-supplied named character
#'   vector of colors with one entry per biome.
#' @param border_color Color for the region-boundary line.
#'   Default \code{"black"}.
#' @param border_width Line width for the region boundary.
#'   Default 0.6.
#' @param legend Logical. Whether to display the biome-color
#'   legend. Default \code{TRUE}.
#' @param biome_labels Logical. Whether to draw each biome's
#'   short abbreviation (from \code{\link{biome_abbrev}}) at
#'   the centroid of its mapped area. Only biomes actually
#'   present on the map are labeled. Default \code{FALSE}.
#' @param points Optional data frame of location points to
#'   overlay. Must contain \code{lon} and \code{lat}
#'   columns. May also carry optional \code{color},
#'   \code{size}, and \code{label} columns; when present
#'   these override the function-level point defaults for
#'   individual points. Default \code{NULL} (no points).
#' @param point_color Default border color for overlaid
#'   points. Default \code{"black"}.
#' @param point_fill Default fill color for overlaid points
#'   (used by the bordered plotting symbols, pch 21 to 25).
#'   Default \code{"white"}.
#' @param point_size Default size (cex) for overlaid points.
#'   Default 1.2.
#' @param point_shape Default plotting symbol (pch) for
#'   overlaid points. Default 21, a bordered circle whose
#'   separate fill and border read clearly against any
#'   biome color.
#' @param file Optional output path for a PNG file. When
#'   supplied, the function opens a PNG graphics device,
#'   draws the map, and closes the device automatically (via
#'   \code{on.exit}) so the file is finalized even if
#'   plotting stops with an error. Default \code{NULL}
#'   (draw to the active device).
#' @param width,height,res PNG width, height, and
#'   resolution, used only when \code{file} is supplied.
#'   Width and height are in inches. Defaults: 9, 7, 200.
#'
#' @return Invisibly returns the input \code{biome_map}.
#'   Called for its side effect (the plot, or the PNG file
#'   when \code{file} is supplied).
#'
#' @details Vector mode rasterizes the smoothed polygons back
#'   to a higher-resolution raster and then uses the same
#'   terra plotting code path as grid mode. This guarantees
#'   identical color application and legend formatting
#'   between the two renderings; the only visual difference
#'   becomes smooth vs jagged biome boundaries.
#'
#'   Palette resolution happens at plot time, so a single
#'   computed \code{biome_map} can be re-rendered under
#'   several palettes without recomputing the classified
#'   raster.
#'
#'   Cells outside the Whittaker scheme are drawn in a fixed
#'   light gray and labeled "Outside Whittaker range" in the
#'   legend, distinct from out-of-region area, which stays
#'   the plot background. This gray is never affected by the
#'   \code{palette} argument.
#'
#'   PNG export wraps the plot in an explicitly sized
#'   graphics device. On Windows the cairo device type is
#'   requested for consistent text rendering. Owning the
#'   device inside the function, rather than leaving
#'   \code{png()} and \code{dev.off()} to the caller, makes
#'   the output reproducible and avoids a device left open
#'   by a mid-plot error.
#'
#'   Location points and biome labels are drawn in plain
#'   longitude and latitude, matching the WorldClim
#'   coordinate reference system of the biome raster, so no
#'   reprojection is needed.
#'
#' @importFrom terra as.factor plot lines rasterize res<- ext<- as.polygons centroids crds values
#' @importFrom grDevices png dev.off
#' @importFrom graphics points text
#'
#' @export
#'
#' @examples
#' \dontrun{
#' oregon_map <- map_biomes(oregon, resolution = 2.5)
#' plot_biome_map(oregon_map)                     # grid mode
#'
#' # Color-vision-deficient palette with biome labels
#' plot_biome_map(oregon_map,
#'                palette      = "cvd",
#'                biome_labels = TRUE)
#'
#' # Overlay location points and export a PNG
#' gardens <- data.frame(
#'   lon   = c(-123.29, -122.57),
#'   lat   = c(44.57, 45.52),
#'   label = c("Corvallis", "Portland")
#' )
#' plot_biome_map(oregon_map,
#'                points = gardens,
#'                file   = "oregon_biomes.png")
#' }
plot_biome_map <- function(biome_map,
                           render       = c("grid", "vector"),
                           palette      = NULL,
                           border_color = "black",
                           border_width = 0.6,
                           legend       = TRUE,
                           biome_labels = FALSE,
                           points       = NULL,
                           point_color  = "black",
                           point_fill   = "white",
                           point_size   = 1.2,
                           point_shape  = 21,
                           file         = NULL,
                           width        = 9,
                           height       = 7,
                           res          = 200){

  if (!inherits(biome_map, "biome_map")) {
    stop("plot_biome_map expects a 'biome_map' object from map_biomes()")
  }

  render <- match.arg(render)

  ## ----- Validate the points table (fail before drawing) -----
  ## Catching a malformed table here avoids opening a PNG
  ## device or drawing a partial map.
  if (!is.null(points)) {
    if (!is.data.frame(points)) {
      stop("'points' must be a data frame with 'lon' and 'lat' columns.")
    }
    if (!all(c("lon", "lat") %in% names(points))) {
      stop("'points' must contain 'lon' and 'lat' columns.")
    }
  }

  ## ----- Resolve the color palette -----
  ## NULL keeps the colors already stored in the biome_map
  ## (the Ricklefs palette assigned by map_biomes). Otherwise
  ## rebuild the colors, in biome_names order, from either a
  ## built-in palette name or a user-supplied named vector.
  if (is.null(palette)) {
    plot_colors <- biome_map$biome_colors
  } else {
    builtin_palettes <- setdiff(names(biome_palettes), "biome")
    if (is.character(palette) && length(palette) == 1L &&
        palette %in% builtin_palettes) {
      ## Built-in palette: look up colors by biome name.
      pal_lookup        <- biome_palettes[[palette]]
      names(pal_lookup) <- biome_palettes$biome
    } else {
      ## User-supplied named color vector.
      pal_lookup <- palette
      if (is.null(names(pal_lookup)) ||
          !all(biome_map$biome_names %in% names(pal_lookup))) {
        stop("'palette' must name a built-in palette (",
             paste(builtin_palettes, collapse = ", "),
             ") or be a named color vector covering every ",
             "biome in the map.")
      }
    }
    ## Order the colors to match this map's biome sequence.
    plot_colors <- unname(pal_lookup[biome_map$biome_names])
  }

  ## ----- Append the sentinel category -----
  ## "Outside Whittaker range" occupies the reserved id one
  ## past the nine biomes. It is always drawn in a fixed gray
  ## and is never recolored by a palette.
  all_levels  <- c(biome_map$biome_names, .outside_label)
  plot_colors <- c(plot_colors, .outside_color)

  ## ----- Restrict to the categories present on this map -----
  ## all_levels and plot_colors cover all ten categories, but
  ## almost every real map holds only some of them. terra's
  ## plot() draws the categories that occur and assigns the
  ## color vector to them in order, so a full-length color
  ## vector pairs colors with the wrong biomes as soon as a
  ## category is missing. Subsetting the level table and the
  ## colors to the ids actually present keeps every color with
  ## its own biome.
  present_ids <- sort(unique(as.vector(
    terra::values(biome_map$biome_raster))))

  ## the level table terra uses to label the categories, and
  ## the colors in the same id order
  lvls <- data.frame(ID    = present_ids,
                     biome = all_levels[present_ids])
  plot_colors <- plot_colors[present_ids]

  ## ----- Optional PNG output -----
  ## When 'file' is supplied the function owns the graphics
  ## device: open it, draw, and close it via on.exit so the
  ## file is finalized even if plotting errors partway. The
  ## cairo type is requested on Windows for consistent text.
  if (!is.null(file)) {
    if (.Platform$OS.type == "windows") {
      grDevices::png(filename = file,
                     width    = width,
                     height   = height,
                     units    = "in",
                     res      = res,
                     type     = "cairo")
    } else {
      grDevices::png(filename = file,
                     width    = width,
                     height   = height,
                     units    = "in",
                     res      = res)
    }
    on.exit(grDevices::dev.off(), add = TRUE)
  }

  main_title <- paste0("Biome map at ", biome_map$resolution,
                       " arc-minute resolution (",
                       render, ")")

  if (render == "grid") {

    ## Categorical raster rendering.
    r <- terra::as.factor(biome_map$biome_raster)
    levels(r) <- lvls

    terra::plot(r,
                col    = plot_colors,
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

    rv <- terra::as.factor(poly_raster)
    levels(rv) <- lvls

    terra::plot(rv,
                col    = plot_colors,
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

  ## ----- Optional per-biome name labels -----
  ## Dissolve the classified raster to one (multi-)polygon
  ## per biome and write each biome's name at its centroid.
  ## as.polygons drops NA cells, so only biomes present on
  ## the map are labeled. inside = TRUE keeps each label
  ## anchor within the biome's area.
  if (isTRUE(biome_labels)) {
    biome_poly <- terra::as.polygons(biome_map$biome_raster,
                                     dissolve = TRUE)
    biome_cent <- terra::centroids(biome_poly, inside = TRUE)
    cent_xy    <- terra::crds(biome_cent)
    cent_ids   <- terra::values(biome_poly)[, 1]
    ## Label each biome with its short abbreviation from
    ## biome_abbrev. id 10 is the "Outside Whittaker range"
    ## sentinel, which is not a biome and has no abbreviation.
    all_abbrev <- c(biome_abbrev$abbrev[match(biome_map$biome_names,
                                              biome_abbrev$biome)],
                    "Outside")
    graphics::text(x      = cent_xy[, 1],
                   y      = cent_xy[, 2],
                   labels = all_abbrev[cent_ids],
                   cex    = 0.75,
                   font   = 2,
                   col    = "black")
  }

  ## ----- Optional location-point overlay -----
  ## Per-point styling: optional data-frame columns (color,
  ## size, label) override the function-level defaults. The
  ## default bordered symbol (pch 21) takes a border color
  ## via 'col' and a fill via 'bg'.
  if (!is.null(points)) {
    pt_col  <- if ("color" %in% names(points)) points$color else point_color
    pt_size <- if ("size"  %in% names(points)) points$size  else point_size
    graphics::points(x   = points$lon,
                     y   = points$lat,
                     pch = point_shape,
                     col = pt_col,
                     bg  = point_fill,
                     cex = pt_size,
                     lwd = 1.2)
    ## Optional per-point labels, placed just above each point.
    if ("label" %in% names(points)) {
      graphics::text(x      = points$lon,
                     y      = points$lat,
                     labels = points$label,
                     pos    = 3,
                     cex    = 0.8)
    }
  }

  ## Report the output file, if one was written.
  if (!is.null(file)) {
    message("Biome map written to: ",
            normalizePath(file, mustWork = FALSE))
  }

  invisible(biome_map)

} ## End function plot_biome_map


#' Biome composition of a biome_map
#'
#' Summarizes a \code{biome_map} as the area and share of
#' mapped land in each biome. For biome-focused regional
#' studies this percentage breakdown is often a primary
#' product in its own right, independent of the map image.
#'
#' @param biome_map A \code{"biome_map"} list returned by
#'   \code{\link{map_biomes}}.
#' @param digits Integer. Decimal places for the rounded
#'   \code{percent} column. Default 1.
#'
#' @return A \code{\link[tibble]{tibble}} with one row per
#'   biome category present on the map, sorted by descending
#'   percentage:
#'   \describe{
#'     \item{biome}{Biome name. Includes \code{"Outside
#'       Whittaker range"} when the map has cells whose
#'       climate falls outside the Whittaker scheme.}
#'     \item{n_cells}{Number of raster cells in the biome.}
#'     \item{area_km2}{Biome area in square kilometers.}
#'     \item{percent}{Share of total mapped (in-region) area,
#'       as a percentage. The column sums to 100.}
#'   }
#'
#' @details Area is computed with
#'   \code{\link[terra]{cellSize}}, which accounts for the
#'   shrinking ground area of cells toward the poles in an
#'   unprojected longitude/latitude raster; \code{percent} is
#'   therefore an area share, not a raw cell-count share. The
#'   denominator is every in-region cell, so unclassified
#'   "Outside Whittaker range" land is counted in the total
#'   rather than silently dropped.
#'
#' @importFrom terra values cellSize
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples
#' \dontrun{
#' oregon_map <- map_biomes(oregon, resolution = 2.5)
#' biome_composition(oregon_map)
#' }
biome_composition <- function(biome_map, digits = 1){

  if (!inherits(biome_map, "biome_map")) {
    stop("biome_composition expects a 'biome_map' object from map_biomes()")
  }

  ## Per-cell biome id and per-cell ground area. cellSize with
  ## unit = "km" returns each cell's area in square kilometers,
  ## correcting for latitude on an unprojected raster.
  ids       <- terra::values(biome_map$biome_raster)[, 1]
  cell_area <- terra::values(
    terra::cellSize(biome_map$biome_raster, unit = "km")
  )[, 1]

  ## Keep only in-region cells. NA ids mark out-of-region area.
  in_region <- !is.na(ids)
  ids       <- ids[in_region]
  cell_area <- cell_area[in_region]

  if (length(ids) == 0L) {
    stop("biome_map has no classified cells.")
  }

  ## Category names: ids 1-9 are biomes, id 10 the sentinel.
  all_levels <- c(biome_map$biome_names, .outside_label)

  ## Aggregate cell counts and ground area by biome id. tapply
  ## keys both results on the same sorted ids, so the rows
  ## stay aligned.
  n_by_id    <- tapply(ids,       ids, length)
  area_by_id <- tapply(cell_area, ids, sum)
  present_id <- as.integer(names(n_by_id))
  total_area <- sum(cell_area)

  result <- tibble::tibble(
    biome    = all_levels[present_id],
    n_cells  = as.integer(n_by_id),
    area_km2 = round(as.numeric(area_by_id), 1),
    percent  = round(100 * as.numeric(area_by_id) / total_area,
                     digits)
  )

  ## Most-abundant biome first.
  result <- result[order(-result$percent), ]

  return(result)

} ## End function biome_composition
