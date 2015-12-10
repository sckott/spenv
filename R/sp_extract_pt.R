#' Extract environmental data - pt based
#'
#' @export
#' @param x input data.frame
#' @details Works for the use case of finding locations for point based stations,
#' floats/buoys type data
#' @examples \dontrun{
#' file <- system.file("examples", "obis_mola_mola.csv", package = "spenv")
#' dat <- read.csv(file)
#' head(dat)
#' res <- sp_extract_pt(x = dat[1:10,], radius = 20)
#' }
sp_extract_pt <- function(x, from = "noaa_isd", radius = 50, select = "first",
  date = NULL) {

  switch(from,
     noaa_isd = {
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
           isd(x[1, 'usaf'], x[1, 'wban'], date)
         }
       })
     })
}
