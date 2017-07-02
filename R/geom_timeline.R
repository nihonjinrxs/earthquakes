library(readr)
library(dplyr)
library(stringr)
library(ggplot2)
library(geosphere)
library(grid)
library(gridExtra)

# TODO: Update docs!

#' GeomTimeline class - ggplot2 geom that shows a timeline plot of earthquakes along a date axis
#'
#' @description
#' This class creates a ggplot2 geom showing ...
#'
#' @note
#' This class, and the accompanying geom function \code{\link{geom_timeline}}.
#'
#' @seealso \code{\link{geom_timeline}}, \code{\link{geom_timeline_label}}
#'
#' @importFrom dplyr mutate select
#' @importFrom ggplot2 Geom draw_key_polygon ggproto_parent Coord::transform
#' @importFrom grid gpar polygonGrob grobTree
#' @importFrom geosphere destPoint
#'
#' @export
GeomTimeline <- ggproto("GeomTimeline", ggplot2::Geom,
                         required_aes = c("x"),
                         default_aes = aes(y = factor(),
                                           color = grey,
                                           size = 1,
                                           alpha = 0.2),
                         draw_key = ggplot2::draw_key_polygon,
                         setup_data = function(self, data, params) {
                           data <- ggplot2::ggproto_parent(Geom, self)$setup_data(data, params)
                           data
                         },
                         # From GeomHurricane -- draw_panel or draw_group needed here.
                         # docs at: https://bookdown.org/rdpeng/RProgDA/building-new-graphical-elements.html
                         draw_group = function(data, panel_scales, coord) {
                           ## Helper function to get xy points for polygons
                           getGeoPoints <- function(obs) {
                             dat <- rbind(geosphere::destPoint(c(obs$x, obs$y), b=0:90, d=obs$r_ne*1852*obs$scale_radii),
                                          geosphere::destPoint(c(obs$x, obs$y), b=90:180, d=obs$r_se*1852*obs$scale_radii),
                                          geosphere::destPoint(c(obs$x, obs$y), b=180:270, d=obs$r_sw*1852*obs$scale_radii),
                                          geosphere::destPoint(c(obs$x, obs$y), b=270:360, d=obs$r_nw*1852*obs$scale_radii)
                             ) %>% as.data.frame() %>% dplyr::mutate(x=lon, y=lat) %>% dplyr::select(x, y)
                             return(dat)
                           }

                           ## Construct polygons for each wind speed value
                           xy_data <- getGeoPoints(data) %>% coord$transform(panel_scales)
                           gp_fill <- grid::gpar(fill = data$fill, col = NA, alpha = 0.6)
                           gp_outline <- grid::gpar(fill = NA, col = data$colour, alpha = 1.0, lwd = 2)

                           poly_grob <- grid::polygonGrob(x = xy_data$x, y = xy_data$y, gp = gp_fill)
                           poly_outline <- grid::polygonGrob(x = xy_data$x, y = xy_data$y, gp = gp_outline)
                           coords <- coord$transform(data, panel_scales)

                           hurricane_windspeed = grid::grobTree(poly_grob, poly_outline)
                           hurricane_windspeed
                         })

# TODO: Update docs!

#' geom_timeline - adds an earthquake timeline plot to a ggplot2/grid graphics object
#'
#' @description
#' This function creates a ggplot2 geom showing ...
#'
#' @note
#' This function accompanies the Geom class \code{\link{GeomTimeline}}.
#'
#' @seealso \code{\link{GeomHurricane}}
#'
#' @importFrom ggplot2 layer
#'
#' @param mapping	Set of aesthetic mappings created by \code{\link{aes}} or \code{\link{aes_}}. If specified and \code{inherit.aes = TRUE} (the default), it is combined with the default mapping at the top level of the plot. You must supply mapping if there is no plot mapping.
#'   Required aesthetics are: \code{x} (usually center longitude), \code{y} (usually center latitude), \code{r_ne}, \code{r_se}, \code{r_sw}, \code{r_nw}  (the northeast, southeast, southwest, and northwest wind radius measurements, respectively), \code{fill}, \code{color} (values to use for fill and color, usually wind speed for the measurements)
#'   Optional aesthetics are: \code{scale_radii} (optional scaling factor for the wind radii, default is \code{1.0})
#' @param data The data to be displayed in this layer. There are three options:
#'   If \code{NULL}, the default, the data is inherited from the plot data as specified in the call to \code{\link{ggplot}}.
#'   A \code{data.frame}, or other object, will override the plot data. All objects will be fortified to produce a data frame. See \code{\link{fortify}} for which variables will be created.
#'   A \code{function} will be called with a single argument, the plot data. The return value must be a \code{data.frame.}, and will be used as the layer data.
#' @param stat The statistical transformation to use on the data for this layer, as a string.
#' @param position Position adjustment, either as a string, or the result of a call to a position adjustment function.
#' @param ...	other arguments passed on to layer. These are often aesthetics, used to set an aesthetic to a fixed value, like \code{color = "red"} or \code{size = 3}. They may also be parameters to the paired geom/stat.
#' @param na.rm	If \code{FALSE}, the default, missing values are removed with a warning. If \code{TRUE}, missing values are silently removed.
#' @param show.legend	logical. Should this layer be included in the legends? \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE} never includes, and \code{TRUE} always includes.
#' @param inherit.aes	If \code{FALSE}, overrides the default aesthetics, rather than combining with them. This is most useful for helper functions that define both data and aesthetics and shouldn't inherit behaviour from the default plot specification, e.g. borders.
#'
#' @return This function returns a \code{ggplot2::layer} with the wind radii plot.
#'
#' @examples
#' storm_observation <- load_hurricane_data() %>% clean_hurricane_data() %>% select_katrina_measurement()
#' get_map("Louisiana", zoom = 6, maptype = "toner-background", source = "stamen") %>%
#'   ggmap(extent = "device") +
#'   geom_hurricane(data = storm_observation, aes(x = longitude, y = latitude,
#'                  r_ne = ne, r_se = se, r_nw = nw, r_sw = sw, fill = wind_speed, color = wind_speed)) +
#'   scale_color_manual(name = "Wind speed (kts)",values = c("red", "orange", "yellow")) +
#'   scale_fill_manual(name = "Wind speed (kts)", values = c("red", "orange", "yellow"))
#'
#' @export
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomTimeline, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
