#' Find locations of stations/etc. from spatial inputs
#'
#' @param x The reference set of stations. This is in the case of point data, not
#' gridded data
#' @param lat,lon	(numeric) Latitude and longitude, in decimal degree. One or
#' more. The lat and lon vectors must be the same length.
#' @param radius (numeric) Radius (in km) to search from the lat,lon coordinates
#' @param bbox (numeric) Bounding box, of the form: min-longitude, min-latitude,
#' max-longitude, max-latitude
#' @examples \dontrun{
#' # Single point pair
#' x <- rnoaa::isd_stations()
#' find_locs(x, lat = 40, lon = -120, radius = 50)
#'
#' # Many point pairs
#' x <- rnoaa::isd_stations()
#' find_locs(x, lat = c(30, 40), lon = c(-120, -120), radius = 50)
#' }
find_locs <- function(x, lat = NULL, lon = NULL, radius = NULL, bbox = NULL,
          ...) {

  check4pkg("lawn")
  check4pkg("geojsonio")
  latlonrad <- spcl(list(lat, lon, radius))
  allargs <- spcl(list(llr = latlonrad, bb = bbox))
  allargs <- allargs[sapply(allargs, length) != 0]
  if (length(allargs) > 1) {
    stop("Only one of lat/lon/radius together, or bbox alone",
         call. = FALSE)
  }
  if (!is.null(bbox)) {
    poly <- lapply(bbox, function(x) lawn::lawn_featurecollection(lawn::lawn_bbox_polygon(x)))
    # poly <- lawn::lawn_featurecollection(lawn::lawn_bbox_polygon(bbox))
  } else {
    poly <- Map(function(x, y)
      lawn::lawn_buffer(lawn::lawn_point(c(x, y)), dist = radius),
      lon, lat)
    # poly <- lawn::lawn_buffer(lawn::lawn_point(c(lon, lat)),
    #                           dist = radius)
  }

  df <- clean_spdf(x)
  xx <- geojsonio::geojson_json(df)
  pts <- lawn::lawn_featurecollection(xx)

  # find matches
  lapply(poly, clip_points, pts = pts)
  # outout <- lawn::lawn_within(pts, poly)
  # tmp <- outout$features
  # cbind(tmp$properties,
  #       setNames(do.call("rbind.data.frame",
  #                        tmp$geometry$coordinates), c("lon", "lat")))
}

clip_points <- function(x, pts) {
  outout <- lawn::lawn_within(pts, x)
  tmp <- outout$features
  if (identical(tmp, list())) {
    NULL
  } else {
    cbind(tmp$properties,
          setNames(do.call("rbind.data.frame",
                           tmp$geometry$coordinates), c("lon", "lat")))
  }
}
