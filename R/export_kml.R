## ============================================================
## export_kml.R
##
## KML export for biome maps. Vector approach (not raster
## GroundOverlay) with per-biome Style elements and
## clampToGround draping so polygons follow Google Earth's
## terrain. This is what enables the orographic-verification
## view: biome polygons computed from T-P alone visibly track
## ridgelines, saddles, and windward/leeward divides even
## though the classifier never saw elevation.
##
## See background/chapter_3d_overlay_ideas.md for the design
## rationale.
##
## ============================================================


#' Convert an R hex color to KML AABBGGRR byte order
#'
#' KML reverses RGB byte order and puts alpha first. This
#' helper handles the conversion.
#'
#' @param hex Hex color string, with or without leading
#'   \code{#}. Accepts 6-digit (\code{#RRGGBB}) or 8-digit
#'   (\code{#RRGGBBAA}) forms.
#' @param alpha Two-character hex alpha (\code{"00"} =
#'   transparent, \code{"FF"} = opaque). Default
#'   \code{"B0"} (~69\% opaque). Ignored if \code{hex}
#'   includes an alpha component.
#'
#' @return Eight-character KML color string in AABBGGRR
#'   order.
#'
#' @keywords internal
hex_to_kml_color <- function(hex, alpha = "B0") {

  hex <- gsub("^#", "", hex)

  if (nchar(hex) == 8) {
    alpha <- substr(hex, 7, 8)
    hex   <- substr(hex, 1, 6)
  }

  rr <- substr(hex, 1, 2)
  gg <- substr(hex, 3, 4)
  bb <- substr(hex, 5, 6)

  paste0(alpha, bb, gg, rr)

} ## End function hex_to_kml_color


#' Minimal XML escaping for KML text content
#'
#' @param s Character string.
#'
#' @return Character string with \code{&}, \code{<}, and
#'   \code{>} escaped to their XML entity forms.
#'
#' @keywords internal
escape_xml <- function(s) {
  s <- gsub("&", "&amp;", s, fixed = TRUE)
  s <- gsub("<", "&lt;",  s, fixed = TRUE)
  s <- gsub(">", "&gt;",  s, fixed = TRUE)
  s
} ## End function escape_xml


#' Build a KML-safe style ID from a biome name
#'
#' KML id attributes must avoid spaces and special characters.
#' This helper replaces any non-alphanumeric character with an
#' underscore and prefixes \code{"biome_"}.
#'
#' @param biome_name Character scalar.
#'
#' @return Character scalar suitable as a KML \code{id}
#'   attribute.
#'
#' @keywords internal
biome_style_id <- function(biome_name) {
  paste0("biome_", gsub("[^A-Za-z0-9]", "_", biome_name))
} ## End function biome_style_id


#' Serialize an sf geometry to KML XML
#'
#' Converts an sf geometry to KML XML lines (without the
#' enclosing Placemark). Handles POLYGON and MULTIPOLYGON.
#' Each polygon includes \code{altitudeMode = clampToGround}
#' and \code{tessellate = 1} so Google Earth drapes the
#' polygon over terrain rather than rendering it as a flat
#' sheet.
#'
#' @param geom An sfg object (POLYGON or MULTIPOLYGON).
#' @param indent Indentation prefix for the outer element.
#'   Default four spaces.
#'
#' @return Character vector of XML lines.
#'
#' @importFrom sf st_geometry_type
#'
#' @keywords internal
geometry_to_kml <- function(geom, indent = "    ") {

  format_ring <- function(coords) {
    parts <- apply(coords, 1, function(r) {
      paste(r[1], r[2], "0", sep = ",")
    })
    paste(parts, collapse = " ")
  }

  one_polygon <- function(poly, ind) {
    out <- c(
      paste0(ind, '<Polygon>'),
      paste0(ind, '  <altitudeMode>clampToGround</altitudeMode>'),
      paste0(ind, '  <tessellate>1</tessellate>'),
      paste0(ind, '  <outerBoundaryIs>'),
      paste0(ind, '    <LinearRing>'),
      paste0(ind, '      <coordinates>',
             format_ring(poly[[1]]),
             '</coordinates>'),
      paste0(ind, '    </LinearRing>'),
      paste0(ind, '  </outerBoundaryIs>')
    )

    if (length(poly) > 1) {
      for (j in 2:length(poly)) {
        out <- c(out,
          paste0(ind, '  <innerBoundaryIs>'),
          paste0(ind, '    <LinearRing>'),
          paste0(ind, '      <coordinates>',
                 format_ring(poly[[j]]),
                 '</coordinates>'),
          paste0(ind, '    </LinearRing>'),
          paste0(ind, '  </innerBoundaryIs>')
        )
      }
    }

    out <- c(out, paste0(ind, '</Polygon>'))
    return(out)
  }

  ## sf's sfg objects carry a multi-class vector with the
  ## dimensionality first ("XY") and the geometry type
  ## second ("POLYGON" or "MULTIPOLYGON"). Use
  ## sf::st_geometry_type() to read the geometry type
  ## robustly regardless of dimensionality.
  geom_type <- as.character(sf::st_geometry_type(geom))

  if (geom_type == "POLYGON") {

    return(one_polygon(geom, indent))

  } else if (geom_type == "MULTIPOLYGON") {

    out <- c(paste0(indent, '<MultiGeometry>'))
    for (k in seq_along(geom)) {
      out <- c(out,
               one_polygon(geom[[k]],
                           paste0(indent, "  ")))
    }
    out <- c(out, paste0(indent, '</MultiGeometry>'))
    return(out)

  } else {

    stop(paste("geometry_to_kml: unsupported geometry type",
               geom_type))

  }

} ## End function geometry_to_kml


#' Export a biome map as KML for Google Earth
#'
#' Writes a KML file with per-biome Style elements and vector
#' polygons that drape over Google Earth's terrain via
#' \code{altitudeMode = clampToGround} and
#' \code{tessellate = 1}. This rendering supports the
#' orographic-verification view: biome polygons computed from
#' T and P alone visibly track topography the classifier
#' never saw.
#'
#' @param biome_map A \code{"biome_map"} list returned by
#'   \code{\link{map_biomes}}, optionally augmented by
#'   \code{\link{smooth_biome_map}}.
#' @param file Character. Output path (should end in
#'   \code{.kml}).
#' @param smoothed Logical. If \code{TRUE} (default) and
#'   \code{biome_polygons} is present in \code{biome_map},
#'   use the smoothed polygons. Otherwise derive polygons
#'   from the classified raster via
#'   \code{\link[terra]{as.polygons}}.
#' @param alpha Two-character hex alpha for polygon fill.
#'   Default \code{"B0"} (~69\% opaque) — visible biome
#'   colors with terrain showing through underneath.
#' @param outline Logical. \code{TRUE} to draw polygon
#'   outlines (helps distinguish adjacent same-shade biomes
#'   such as the three forest greens); \code{FALSE} for a
#'   softer look. Default \code{TRUE}.
#' @param name KML document name (shown in Google Earth's
#'   Places panel). Default \code{"Biome Map"}.
#' @param description Optional KML document description.
#'
#' @return The file path, invisibly.
#'
#' @details The KML uses vector polygons rather than a raster
#'   GroundOverlay so the polygons retain vector quality at
#'   any zoom. For coarse-resolution global views, a future
#'   raster-GroundOverlay option may be added; for the
#'   region-scale and island-scale work this package targets,
#'   vector polygons are the right choice.
#'
#'   Smoothed polygons read more naturally on 3D terrain than
#'   gridded raster polygons (which produce stepped edges
#'   that look like rendering artifacts).
#'
#' @importFrom terra as.polygons
#' @importFrom sf st_as_sf st_crs st_transform st_geometry st_crs<-
#'
#' @export
#'
#' @examples
#' \dontrun{
#' oregon_map <- map_biomes(oregon, resolution = 2.5)
#' oregon_map <- smooth_biome_map(oregon_map)
#' export_biome_kml(
#'   biome_map = oregon_map,
#'   file      = "oregon_biomes.kml",
#'   name      = "Oregon Biome Map"
#' )
#' # Open the resulting file in Google Earth and tilt the
#' # view to see biome boundaries draped on terrain.
#' }
export_biome_kml <- function(biome_map,
                             file,
                             smoothed    = TRUE,
                             alpha       = "B0",
                             outline     = TRUE,
                             name        = "Biome Map",
                             description = NULL){

  if (!inherits(biome_map, "biome_map")) {
    stop("export_biome_kml expects a 'biome_map' object from map_biomes()")
  }

  ## ---------- Get polygons ----------
  if (smoothed && !is.null(biome_map$biome_polygons)) {
    poly_terra <- biome_map$biome_polygons
  } else {
    poly_terra <- terra::as.polygons(biome_map$biome_raster,
                                     dissolve = TRUE)
  }

  ## ---------- Convert to sf and ensure WGS84 ----------
  poly_sf <- sf::st_as_sf(poly_terra)

  current_crs <- sf::st_crs(poly_sf)
  if (!is.na(current_crs$epsg) && current_crs$epsg != 4326) {
    poly_sf <- sf::st_transform(poly_sf, 4326)
  } else if (is.na(current_crs$epsg)) {
    warning("biome_polygons has no CRS metadata; assuming WGS84.")
    sf::st_crs(poly_sf) <- 4326
  }

  ## ---------- Map biome_id to names and colors ----------
  if (!"biome_id" %in% names(poly_sf)) {
    stop("biome_polygons does not carry a 'biome_id' column. Re-run smooth_biome_map() or rebuild polygons from the raster.")
  }

  biome_id_vals  <- poly_sf$biome_id
  poly_biome     <- biome_map$biome_names[biome_id_vals]

  ## Drop polygons with NA biome assignment.
  keep <- !is.na(poly_biome)
  poly_sf    <- poly_sf[keep, ]
  poly_biome <- poly_biome[keep]

  if (nrow(poly_sf) == 0) {
    stop("No polygons with valid biome assignments to export.")
  }

  ## ---------- Build the KML ----------
  kml_lines <- c(
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<kml xmlns="http://www.opengis.net/kml/2.2">',
    '<Document>',
    paste0('  <name>', escape_xml(name), '</name>')
  )

  if (!is.null(description)) {
    kml_lines <- c(kml_lines,
      paste0('  <description>',
             escape_xml(description),
             '</description>')
    )
  }

  ## Style block per unique biome present.
  unique_biomes <- unique(poly_biome)

  for (bn in unique_biomes) {
    sid       <- biome_style_id(bn)
    kml_color <- hex_to_kml_color(biome_map$biome_colors[bn],
                                  alpha = alpha)

    line_color   <- if (outline) "FF000000" else "00000000"
    line_width   <- if (outline) "1"        else "0"
    outline_flag <- if (outline) "1"        else "0"

    kml_lines <- c(kml_lines,
      paste0('  <Style id="', sid, '">'),
      '    <LineStyle>',
      paste0('      <color>', line_color, '</color>'),
      paste0('      <width>', line_width, '</width>'),
      '    </LineStyle>',
      '    <PolyStyle>',
      paste0('      <color>', kml_color, '</color>'),
      '      <fill>1</fill>',
      paste0('      <outline>', outline_flag, '</outline>'),
      '    </PolyStyle>',
      '  </Style>'
    )
  }

  ## Placemark block per polygon row.
  for (i in seq_len(nrow(poly_sf))) {
    bn   <- poly_biome[i]
    sid  <- biome_style_id(bn)
    geom <- sf::st_geometry(poly_sf)[[i]]

    kml_lines <- c(kml_lines,
      '  <Placemark>',
      paste0('    <name>', escape_xml(bn), '</name>'),
      paste0('    <styleUrl>#', sid, '</styleUrl>'),
      geometry_to_kml(geom, indent = "    "),
      '  </Placemark>'
    )
  }

  kml_lines <- c(kml_lines,
    '</Document>',
    '</kml>'
  )

  writeLines(kml_lines, file, useBytes = TRUE)

  message("Wrote ", nrow(poly_sf), " polygons across ",
          length(unique_biomes), " biomes to ", file)

  invisible(file)

} ## End function export_biome_kml
