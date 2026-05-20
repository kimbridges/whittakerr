## ============================================================
## get_climate.R
##
## Climate-data retrieval for biome classification. Wraps the
## geodata package's WorldClim and CMIP6 access in a single
## function with biome-oriented output.
##
## See background/chapter_scale_ideas.md for the scale-choice
## discussion (the 2.5-minute default is the document's
## standard spatial resolution; the 1970-2000 average is its
## temporal scale).
##
## ============================================================


#' Retrieve climate values at one or more points
#'
#' Returns annual mean temperature and annual precipitation
#' at one or more (lon, lat) points from WorldClim v2.1.
#' Supports the 1970-2000 historical baseline and CMIP6
#' future projections under a single signature.
#'
#' @param lon Numeric vector of longitudes (decimal degrees,
#'   WGS84). Same length as \code{lat}.
#' @param lat Numeric vector of latitudes (decimal degrees,
#'   WGS84). Same length as \code{lon}.
#' @param scenario One of \code{"historical"} (default,
#'   1970-2000 WorldClim baseline) or \code{"future"}
#'   (CMIP6 projection parameterized by \code{gcm},
#'   \code{ssp}, and \code{period}).
#' @param gcm Character. Global Climate Model identifier for
#'   future scenarios. Default \code{"MPI-ESM1-2-HR"}. See
#'   \code{\link[geodata]{cmip6_world}} for the supported set.
#' @param ssp Character. Shared Socioeconomic Pathway code
#'   for future scenarios. Default \code{"245"} (SSP2-4.5,
#'   middle-of-the-road emissions).
#' @param period Character. Time window for future scenarios.
#'   Default \code{"2041-2060"} (mid-century).
#' @param resolution Numeric. Spatial resolution in
#'   arc-minutes. Valid values: 10, 5, 2.5, or 0.5
#'   (30 arc-seconds). Default \code{2.5}, the document's
#'   standard. The 0.5 (30-arcsecond) option is available
#'   for historical climate only; CMIP6 future projections
#'   are distributed at 2.5 arc-minutes and coarser.
#' @param cache_path Character. Directory for cached WorldClim
#'   downloads. Default \code{"cache/worldclim_cache"} (relative
#'   to the current working directory). The first call for a
#'   given resolution and scenario downloads the data;
#'   subsequent calls reuse the cache. Override this path if
#'   you want the cache somewhere else, e.g.,
#'   \code{tools::R_user_dir("whittakerr", "cache")} for the
#'   R-standard user-cache location.
#'
#' @return A tibble with columns: \code{lon}, \code{lat},
#'   \code{mat_c} (annual mean temperature, degrees C),
#'   \code{map_mm} (annual precipitation, mm), \code{map_cm}
#'   (annual precipitation, cm), \code{scenario}, and (for
#'   future scenarios) \code{gcm}, \code{ssp}, \code{period}.
#'   Ocean points and points outside the data extent return
#'   NA for the climate values.
#'
#' @details Layer order in WorldClim's bioclimatic variables:
#'   BIO1 is annual mean temperature; BIO12 is annual
#'   precipitation. Both are pulled from the bio (historical)
#'   or bioc (CMIP6) variable set.
#'
#'   At the three coarser resolutions (10, 5, and 2.5
#'   arc-minutes) WorldClim is one global grid, downloaded
#'   once. At 30 arc-seconds (resolution 0.5) WorldClim is
#'   tile-distributed; \code{get_climate()} fetches the tile
#'   covering each query point. Points clustered in one
#'   region resolve in a single tile.
#'
#'   The function is vectorized: pass vectors of any length
#'   for \code{lon} and \code{lat} and get one tibble row per
#'   point.
#'
#' @importFrom geodata worldclim_global worldclim_tile cmip6_world
#' @importFrom terra vect extract ext
#' @importFrom tibble tibble
#' @importFrom dplyr mutate
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Historical climate at three Pacific-coast cities
#' cities <- get_climate(
#'   lon = c(-157.86, -118.24, -122.33),
#'   lat = c(21.31, 34.05, 47.61)
#' )
#'
#' # Fine-resolution (30 arc-second) historical climate
#' fine <- get_climate(
#'   lon        = -157.86,
#'   lat        = 21.31,
#'   resolution = 0.5
#' )
#'
#' # Future projection (SSP2-4.5, 2041-2060, MPI-ESM1-2-HR)
#' cities_future <- get_climate(
#'   lon      = c(-157.86, -118.24, -122.33),
#'   lat      = c(21.31, 34.05, 47.61),
#'   scenario = "future"
#' )
#' }
get_climate <- function(lon, lat,
                        scenario   = c("historical", "future"),
                        gcm        = "MPI-ESM1-2-HR",
                        ssp        = "245",
                        period     = "2041-2060",
                        resolution = 2.5,
                        cache_path = "cache/worldclim_cache"){

  scenario <- match.arg(scenario)

  ## Validate inputs.
  if(length(lon) != length(lat)){
    stop("lon and lat must be the same length.")
  }
  if(!resolution %in% c(10, 5, 2.5, 0.5)){
    stop("resolution must be one of 10, 5, 2.5, or 0.5 (arc-minutes).")
  }
  if(scenario == "future" && resolution == 0.5){
    stop("30-arcsecond resolution (0.5) is available for historical climate only. CMIP6 future projections are distributed at 2.5 arc-minutes and coarser.")
  }

  ## Ensure cache directory exists.
  dir.create(cache_path, showWarnings = FALSE, recursive = TRUE)

  if(scenario == "historical" && resolution == 0.5){

    ## --- Historical at 30 arc-seconds: tile-distributed ---
    ##
    ## WorldClim's 30-arcsecond data is delivered as tiles,
    ## not a single global grid. Fetch tiles as needed: take
    ## the tile covering the first not-yet-resolved point,
    ## extract every query point that falls within that tile,
    ## then repeat for any points left over. Points clustered
    ## in one region resolve in a single tile.

    ## prepare result vectors and a SpatVector of all points
    mat <- rep(NA_real_, length(lon))
    map <- rep(NA_real_, length(lon))
    pts <- terra::vect(cbind(lon, lat), crs = "EPSG:4326")

    ## indices of points still needing a climate value
    remaining <- seq_along(lon)

    while(length(remaining) > 0){
      ## fetch the tile covering the first unresolved point
      seed <- remaining[1]
      tile <- geodata::worldclim_tile(
        var  = "bio",
        lon  = lon[seed],
        lat  = lat[seed],
        path = cache_path
      )
      ## subset to BIO1 (temperature) and BIO12 (precipitation)
      tile_subset <- tile[[c(1, 12)]]

      ## the tile's geographic extent: c(xmin, xmax, ymin, ymax)
      tile_box <- as.vector(terra::ext(tile))
      ## which remaining points fall within this tile
      in_tile  <- remaining[
        lon[remaining] >= tile_box[1] & lon[remaining] <= tile_box[2] &
        lat[remaining] >= tile_box[3] & lat[remaining] <= tile_box[4]
      ]

      ## extract those points (NA where the cell has no data)
      vals <- terra::extract(tile_subset, pts[in_tile])
      mat[in_tile] <- vals[, 2]
      map[in_tile] <- vals[, 3]

      ## these points are now resolved; drop them
      remaining <- setdiff(remaining, in_tile)
    }

  } else {

    ## --- Coarser resolutions: one global grid ---
    ##
    ## Historical uses worldclim_global; CMIP6 future uses
    ## cmip6_world. Layer order in both is BIO1 through BIO19.

    ## fetch the appropriate global bioclim raster
    if(scenario == "historical"){
      bio_raster <- geodata::worldclim_global(
        var  = "bio",
        res  = resolution,
        path = cache_path
      )
    } else {
      bio_raster <- geodata::cmip6_world(
        model = gcm,
        ssp   = ssp,
        time  = period,
        var   = "bioc",
        res   = resolution,
        path  = cache_path
      )
    }

    ## subset to BIO1 and BIO12
    bio_subset <- bio_raster[[c(1, 12)]]
    ## build a SpatVector of the query points (WGS84)
    pts <- terra::vect(cbind(lon, lat), crs = "EPSG:4326")
    ## extract values at each point
    extracted <- terra::extract(bio_subset, pts)
    mat <- extracted[, 2]
    map <- extracted[, 3]

  }

  ## Assemble the result.
  result <- tibble::tibble(
    lon      = lon,
    lat      = lat,
    mat_c    = mat,
    map_mm   = map,
    map_cm   = map / 10,
    scenario = scenario
  )

  ## Tack on future-scenario metadata when relevant.
  if(scenario == "future"){
    result <- result |>
      dplyr::mutate(gcm    = gcm,
                    ssp    = ssp,
                    period = period)
  }

  return(result)

} ## End function get_climate
