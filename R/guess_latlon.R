###### code adapted from the leaflet package - source at github.com/rstudio/leaflet
spenv_guess_latlon <- function(x, lat=NULL, lon=NULL) {
  xnames <- names(x)
  if (is.null(lat) && is.null(lon)) {
    lats <- xnames[grep("^(lat|latitude)$", xnames, ignore.case = TRUE)]
    lngs <- xnames[grep("^(lon|lng|long|longitude)$", xnames, ignore.case = TRUE)]

    if (length(lats) == 1 && length(lngs) == 1) {
      if (length(x) > 2) {
        message("Assuming '", lngs, "' and '", lats,
                "' are longitude and latitude, respectively")
      }
      x <- rename(x, setNames('latitude', eval(lats)))
      rename(x, setNames('longitude', eval(lngs)))
    } else {
      stop("Couldn't infer longitude/latitude columns, please specify with 'lat'/'lon' parameters", call. = FALSE)
    }
  } else {
    message("Using user input '", lon, "' and '", lat,
            "' as longitude and latitude, respectively")
    x <- rename(x, setNames('latitude', eval(lat)))
    rename(x, setNames('longitude', eval(lon)))
  }
}
