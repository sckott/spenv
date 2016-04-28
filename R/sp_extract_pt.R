#' Extract environmental data - pt based
#'
#' @export
#' @param x input data.frame
#' @param from which data source, only 'noaa_isd' for now OR an object with data
#' in it, including data.frame or SpatialPointsDataFrame
#' @param radius radius, in km, for which to search for stations/point locations
#' from each input point in \code{x}
#' @param select Ignored right now
#' @param date Date to search for data for. Ignored if you supply your own
#' env data in \code{from}
#' @details Works for the use case of finding locations for point based stations,
#' e.g., floats/buoys type data
#' @author Scott Chamberlain
#' @examples \dontrun{
#' file <- system.file("examples", "obis_mola_mola.csv", package = "spenv")
#' dat <- read.csv(file, stringsAsFactors = FALSE)
#' head(dat)
#'
#' # data.frame input
#' res <- sp_extract_pt(x = dat[1:10,], radius = 10)
#' dplyr::bind_rows(lapply(res, function(x) x$data))
#'
#' # spatial objects
#' ## SpatialPointsDataFrame - w/ NOAA remote data
#' library("sp")
#' coordinates(dat) <- ~longitude + latitude
#' sp_extract_pt(dat, radius = 10)
#'
#' ## SpatialPointsDataFrame - w/ data.frame
#' file <- system.file("examples", "noaa_data.csv", package = "spenv")
#' ref <- read.csv(file, stringsAsFactors = FALSE)
#' sp_extract_pt(x = dat, from = ref, radius = 10)
#' }
sp_extract_pt <- function(x, from = "noaa_isd", radius = 50, select = "first",
                          date = NULL) {
  UseMethod("sp_extract_pt")
}

#' @export
sp_extract_pt.default <- function(x, from = "noaa_isd", radius = 50, select = "first",
                                     date = NULL) {
  stop("No sp_extract_pt() method for ", class(x), call. = FALSE)
}

#' @export
sp_extract_pt.data.frame <- function(x, from = "noaa_isd", radius = 50, select = "first",
  date = NULL) {

  # toggle different data sources, only noaa isd for now
  switch(from,
     'noaa_isd' = {
       isdstat <- rnoaa::isd_stations()
       tmp <- find_locs(isdstat, lat = x$latitude, lon = x$longitude, radius = radius)
       lapply(tmp, function(x) {
         if (is.null(x)) {
           NULL
         } else {
           if (is.null(date)) {
             # use latest date if user doesn't give
             date <- year(ymd(x[1, "end"]))
           }
           rnoaa::isd(x[1, 'usaf'], x[1, 'wban'], date)
         }
       })
     }
  )
}

#' @export
sp_extract_pt.SpatialPointsDataFrame <- function(x, from = "noaa_isd", radius = 50, select = "first",
                                     date = NULL) {
  x <- data.frame(x)
  res <- find_locs(x = from, lat = x$latitude, lon = x$longitude, radius = radius)
  bind_rows(res)
}

#' @export
sp_extract_pt.SpatialPointsDataFrame <- function(x, from = "noaa_isd", radius = 50, select = "first",
                                                 date = NULL) {
  x <- data.frame(x)
  res <- find_locs(x = from, lat = x$latitude, lon = x$longitude, radius = radius)
  bind_rows(res)
}
