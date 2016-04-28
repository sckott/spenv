#' Find locations of stations/etc. from spatial inputs
#'
#' @export
#' @param x The reference set of stations. This is in the case of point data, not
#' gridded data
#' @param lat,lon	(numeric) Latitude and longitude, in decimal degree. One or
#' more. The lat and lon vectors must be the same length.
#' @param radius (numeric) Radius (in km) to search from the lat,lon coordinates
#' @param bbox (numeric) Bounding box, of the form: min-longitude, min-latitude,
#' max-longitude, max-latitude. IGNORED FOR NOW.
#' @examples \dontrun{
#' # Single point pair
#' x <- rnoaa::isd_stations()
#' find_locs(x, lat = 40, lon = -120, radius = 50)
#'
#' # Many point pairs
#' x <- rnoaa::isd_stations()
#' find_locs(x, lat = c(30, 40), lon = c(-120, -120), radius = 50)
#' }
find_locs <- function(x, lat = NULL, lon = NULL, radius = NULL, bbox = NULL) {

  check4pkg("sp")
  check4pkg("rgeos")

  x <- spenv_guess_latlon(x)
  df2sp <- df <- clean_spdf(x)
  sp::coordinates(df2sp) <- ~longitude + latitude
  sp::proj4string(df2sp) <- sp::CRS("+init=epsg:3395")
  df2sp <- as(df2sp, "SpatialPoints")

  # find matches
  out <- list()
  for (i in seq_along(lat)) {
    pt <- buffer_pt(lon[i], lat[i], radius)
    out[[i]] <- clip_points2(pt = pt, refdat = df2sp, orig = df)
  }
  out
  # lapply(list(lat, lon), clip_points2, refdat = df2sp, orig = df)
}

# buffer a point
buffer_pt <- function(lon, lat, radius) {
  spt <- sp::SpatialPoints(cbind(lon, lat))
  sp::proj4string(spt) <- sp::CRS("+init=epsg:3395")
  rgeos::gBuffer(spt, width = radius)
}

clip_points2 <- function(pt, refdat, orig) {
  tmp <- sp::over(pt, refdat)[[1]]
  if (is.na(tmp)) {
    NULL
  } else {
    orig[tmp,]
  }
}

clean_spdf <- function(x) {
  df <- x[complete.cases(x$lat, x$lon), ]
  df <- df[abs(df$lat) <= 90, ]
  df <- df[abs(df$lon) <= 180, ]
  df <- df[df$lat != 0, ]
  row.names(df) <- NULL
  df
}
