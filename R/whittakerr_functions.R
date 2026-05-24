## ============================================================
## whittakerr_functions.R
##
## Core biome classification (name_biome) and diagram-space
## plotting (plot_biomes). Precipitation is in centimeters
## throughout the public API; see ?whittakerr for the unit
## convention and the cover-art exception.
##
## ============================================================


#' Classify a climate point into a Whittaker biome
#'
#' Returns the biome name for a single (temperature, precipitation)
#' pair by point-in-polygon lookup against the digitized Whittaker
#' biome boundaries.
#'
#' @param mean_temp_c Annual mean temperature in degrees Celsius.
#'   Scalar.
#' @param total_ppt_cm Annual total precipitation in centimeters.
#'   Scalar. Matches the underlying \code{Whittaker_biomes$precp_cm}
#'   polygon data and the diagram's native unit.
#'
#' @return Character scalar: the name of the biome containing the
#'   given climate point, or \code{"unknown"} if the point falls
#'   outside all biome polygons.
#'
#' @details This function is scalar-only. For vectorized
#'   classification across a raster, loop over cells.
#'   \code{\link{map_biomes}} uses this pattern internally.
#'
#'   See \code{?whittakerr} for the unit convention
#'   (precipitation in cm).
#'
#' @importFrom dplyr filter
#' @importFrom sp point.in.polygon
#'
#' @export
#'
#' @examples
#' # Tropical rain forest territory
#' name_biome(mean_temp_c = 25, total_ppt_cm = 250)
#'
#' # Tundra
#' name_biome(mean_temp_c = -10, total_ppt_cm = 20)
#'
#' # Outside all polygons (e.g., extremely hot and dry)
#' name_biome(mean_temp_c = 35, total_ppt_cm = 5)
name_biome <- function(mean_temp_c, total_ppt_cm){

  biome_id <- NULL

  ## Extract biome names.
  id <- unique(Whittaker_biomes$biome_id)
  biome_id[id] <- unique(Whittaker_biomes$biome)

  ## Initialize the name (case: outside the diagram).
  biome_name <- "unknown"

  ## Look inside each boundary for the point.
  for(i in 1:9){
    ## Isolate one of the boundary polygons (i.e., biome).
    boundary <- Whittaker_biomes |>
      dplyr::filter(Whittaker_biomes$biome_id == i)
    ## Test if the data point is inside the polygon.
    inside <- sp::point.in.polygon(mean_temp_c,
                                   total_ppt_cm,
                                   boundary$temp_c,
                                   boundary$precp_cm,
                                   mode.checked = FALSE)

    ## If the point is inside, get the biome name.
    if(inside == 1){biome_name <- biome_id[i]}
  } ## End of boundary loop

  return(biome_name)

} ## End function name_biome


#' Plot the Whittaker biome diagram, optionally with data points
#'
#' Renders the Whittaker biome polygons in temperature-precipitation
#' space, with optional data points and labels overlaid. The base
#' diagram comes from the bundled \code{Whittaker_biomes} polygon
#' data; the biome colors come from \code{biome_palettes},
#' selectable through the \code{palette} argument.
#'
#' @param mean_temp_c Numeric vector of annual mean temperature
#'   values (degrees Celsius), one per point. Optional.
#' @param total_ppt_cm Numeric vector of annual total precipitation
#'   values (centimeters), one per point. Same length as
#'   \code{mean_temp_c}. Optional.
#' @param source Character scalar. Caption to display below the
#'   plot. Optional.
#' @param label Character vector of point labels, one per point.
#'   Same length as \code{mean_temp_c}. Optional.
#' @param palette The biome color palette. Either a string
#'   naming a built-in palette (a color column of
#'   \code{\link{biome_palettes}}): \code{"ricklefs"}
#'   (default), the iconic, convention-following palette;
#'   \code{"cvd"}, color-vision-deficiency-safe; or
#'   \code{"grayscale"}, engineered to survive
#'   black-and-white reproduction; or \code{"custom"}, a
#'   palette tuned for a specific map. Or a user-supplied
#'   named color vector, one hex entry per biome, for a
#'   palette tuned to a particular map.
#' @param biome_labels Logical. When \code{TRUE}, the short
#'   abbreviation for each biome (from
#'   \code{\link{biome_abbrev}}) is drawn at the centroid of
#'   that biome's polygon. Default \code{FALSE}.
#'
#' @return A ggplot2 plot object. Print to render; pass to
#'   \code{ggsave()} to save to file.
#'
#' @details Calling \code{plot_biomes()} with no arguments returns
#'   just the biome diagram. Supplying \code{mean_temp_c} and
#'   \code{total_ppt_cm} adds points; supplying \code{label}
#'   additionally adds labels. Setting \code{biome_labels = TRUE}
#'   writes each biome's short abbreviation at its centroid in
#'   the diagram.
#'
#'   The points and labels are passed via an explicit \code{data =}
#'   argument with \code{inherit.aes = FALSE} to avoid a ggplot2
#'   pitfall: without these, geom_point inherits the
#'   \code{Whittaker_biomes} data (775 rows) from the base
#'   plot, and the resulting length mismatch silently suppresses
#'   the points.
#'
#'   See \code{?whittakerr} for the unit convention. The project's
#'   cover-art image displays "mm" on its precipitation axis as an
#'   intentional in-joke about the unit-naming history; the
#'   function's output uses cm.
#'
#' @importFrom ggplot2 ggplot geom_polygon aes labs scale_fill_manual
#'   theme_bw geom_point geom_label
#'
#' @export
#'
#' @examples
#' # Bare biome diagram
#' plot_biomes()
#'
#' # Diagram with three labeled cities
#' plot_biomes(
#'   mean_temp_c  = c(23, 17, 11),
#'   total_ppt_cm = c(55, 30, 95),
#'   source       = "Three Pacific-coast cities",
#'   label        = c("Honolulu", "Los Angeles", "Seattle")
#' )
#'
#' # The color-vision-deficiency-safe palette
#' plot_biomes(palette = "cvd")
#'
#' # Biomes labeled with their short abbreviations
#' plot_biomes(biome_labels = TRUE)
plot_biomes <- function(mean_temp_c  = NULL,
                        total_ppt_cm = NULL,
                        source       = NULL,
                        label        = NULL,
                        palette      = "ricklefs",
                        biome_labels = FALSE){

  ## Select the biome color palette. `palette` is either the
  ## name of a built-in palette (a color column of
  ## biome_palettes) or a user-supplied named color vector
  ## (biome name -> hex), one entry per biome.
  builtin_palettes <- setdiff(names(biome_palettes), "biome")
  if(is.character(palette) && length(palette) == 1L &&
     palette %in% builtin_palettes){
    ## a built-in palette: take the named column
    pal_colors <- biome_palettes[[palette]]
    names(pal_colors) <- biome_palettes$biome
  } else {
    ## a user-supplied palette, tuned for a particular map
    pal_colors <- palette
    if(is.null(names(pal_colors)) ||
       !all(biome_palettes$biome %in% names(pal_colors))){
      stop("'palette' must name a built-in palette (",
           paste(builtin_palettes, collapse = ", "),
           ") or be a named color vector with one entry per biome.")
    }
  }

  ## Create the base plot.
  W_plot <- ggplot2::ggplot() +
    ## Create the biome polygons.
    ggplot2::geom_polygon(data = Whittaker_biomes,
                          ggplot2::aes(x    = .data$temp_c,
                                       y    = .data$precp_cm,
                                       fill = .data$biome),
                          # adjust polygon borders
                          colour    = "gray98",
                          linewidth = 1) +
    ## Add axis labels.
    ggplot2::labs(x = "Annual Mean Temperature (C)",
                  y = "Total Annual Precipitation (cm)") +
    ## Use the selected categorical palette.
    ggplot2::scale_fill_manual(
      name   = "Whittaker biomes",
      breaks = names(pal_colors),
      labels = names(pal_colors),
      values = pal_colors) +
    ggplot2::theme_bw()

  ## Add biome-name labels at biome centroids if requested.
  ## Each label is the short abbreviation from biome_abbrev,
  ## placed at the centroid (the mean vertex) of the biome's
  ## polygon in temperature-precipitation space. geom_label
  ## gives each label a white backing so it stays readable on
  ## any palette.
  if(isTRUE(biome_labels)){
    ## Centroid of each biome polygon: the mean of its vertices.
    cx <- tapply(Whittaker_biomes$temp_c,
                 Whittaker_biomes$biome, mean)
    cy <- tapply(Whittaker_biomes$precp_cm,
                 Whittaker_biomes$biome, mean)
    centroids_df <- data.frame(
      biome    = names(cx),
      temp_c   = as.numeric(cx),
      precp_cm = as.numeric(cy),
      stringsAsFactors = FALSE)
    ## Match each biome to its row in biome_abbrev.
    idx <- match(centroids_df$biome, biome_abbrev$biome)
    ## Attach each biome's abbreviation.
    centroids_df$abbrev <- biome_abbrev$abbrev[idx]
    ## Where biome_abbrev carries an explicit label position,
    ## use it in place of the computed centroid. The mean of a
    ## polygon's vertices sits poorly for some biomes; NA in
    ## label_temp/label_precp means "keep the centroid".
    over_t <- biome_abbrev$label_temp[idx]
    over_p <- biome_abbrev$label_precp[idx]
    centroids_df$temp_c[!is.na(over_t)]   <- over_t[!is.na(over_t)]
    centroids_df$precp_cm[!is.na(over_p)] <- over_p[!is.na(over_p)]
    W_plot <- W_plot +
      ggplot2::geom_label(data = centroids_df,
                          ggplot2::aes(x     = .data$temp_c,
                                       y     = .data$precp_cm,
                                       label = .data$abbrev),
                          inherit.aes = FALSE,
                          size        = 3,
                          fontface    = "bold",
                          colour      = "gray15",
                          fill        = "white",
                          label.size  = 0)
  } ## End biome-label addition

  ## Add data points if climate data are supplied.
  ##
  ## IMPORTANT: build an explicit data frame and pass it via
  ## data = ... with inherit.aes = FALSE. Without this, the
  ## geom inherits data = Whittaker_biomes (775 polygon-vertex
  ## rows) from the base ggplot call, and the length mismatch
  ## between the inherited data and the (usually much shorter)
  ## argument vectors silently suppresses the points.
  if(!is.null(mean_temp_c)) {
    points_df <- data.frame(mean_temp_c  = mean_temp_c,
                            total_ppt_cm = total_ppt_cm)
    W_plot <- W_plot +
      ggplot2::geom_point(data        = points_df,
                          ggplot2::aes(x = .data$mean_temp_c,
                                       y = .data$total_ppt_cm),
                          inherit.aes = FALSE,
                          size        = 3,
                          shape       = 21,
                          color       = "white",
                          fill        = "black",
                          stroke      = 0.7,
                          alpha       = 1.0)
  } ## End of data point addition

  ## Add label if label data are supplied.
  ## Same data-inheritance fix as the points geom above.
  if(!is.null(label)) {
    label_df <- data.frame(mean_temp_c  = mean_temp_c,
                           total_ppt_cm = total_ppt_cm,
                           label        = label)
    W_plot <- W_plot +
      ggplot2::geom_label(data        = label_df,
                          ggplot2::aes(x     = .data$mean_temp_c,
                                       y     = .data$total_ppt_cm,
                                       label = .data$label),
                          inherit.aes = FALSE,
                          color       = "white",
                          fill        = "black",
                          alpha       = 1.0,
                          hjust       = 0,
                          nudge_x     = 1.0)
  } ## End of label addition

  ## Add caption at bottom if source is specified.
  if(!is.null(source)){
    W_plot <- W_plot +
      ggplot2::labs(caption = source)
  } ## End caption addition

  return(W_plot)

} ## End function plot_biomes
