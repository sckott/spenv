#' Extract environmental data - gridded data based
#'
#' @export
#' @param x input data.frame
#' @param from Data source, only noaa_sst for now, from
#' http://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.html
#' @param latitude Latitude variable name
#' @param longitude Longitude variable name
#' @param origin Date origin, Default: 1800-1-1
#' @details Works for the use case of finding locations for point based stations,
#' floats/buoys type data
#' @author Tom Webb, Scott Chamberlain
#' @examples \dontrun{
#' library("spocc")
#' res <- occ(query = 'Mola mola', from = 'obis', limit = 200)
#' res_df <- occ2df(res)
#' sp_extract_gridded(x=res_df)
#'
#' # pass in lat/lon variable names if needed
#' names(res_df)[2] <- "mylong"
#' head(res_df)
#' sp_extract_gridded(res_df, latitude = "latitude", longitude = "mylong")
#' }
sp_extract_gridded <- function(x, from = "noaa_sst", latitude = NULL,
                               longitude = NULL, origin = as.Date("1800-1-1")) {

  x <- spenv_guess_latlon(x, latitude, longitude)
  switch(from,
     noaa_sst = {
       mb <- sst_prep()
       out <- list()
       x <- x[ !is.na(x$date), ]
       x$date <- as.Date(x$date)
       x <- x[x$date >= min(mb@z[["Date"]]), ]
       x$lon_adj <- x$longitude
       x$lon_adj[x$lon_adj < 0] <- x$lon_adj[x$lon_adj < 0] + 360
       for (i in seq_len(NROW(x))) {
         out[[i]] <- get_env_par_space_x_time(mb, x[i, ], origin = origin)
       }
       x$sst <- unlist(out)
       x
     }
  )
}

sst_prep <- function(path = "~/.spenv/noaa_sst") {
  x <- file.path(path, "sst.mnmean.nc")
  if (!file.exists(x)) {
    dir.create(dirname(x), recursive = TRUE, showWarnings = FALSE)
    download.file("ftp://ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/sst.mnmean.nc", destfile = x)
  }
  raster::brick(x, varname = "sst")
}

get_env_par_space_x_time <- function(
  env_dat, occ_dat, origin = as.Date("1800-1-1")){

  # calculate starting julian day for each month in env_dat
  month_intervals <- as.numeric(env_dat@z[["Date"]] - origin)
  # calculate julan day for the focal date (eventDate in occ_dat)
  focal_date <- as.numeric(occ_dat$date - origin)

  # extract environmental variable (SST here) for this point
  as.numeric(extract(
    env_dat,
    cbind(occ_dat$lon_adj, occ_dat$latitude),
    layer = findInterval(focal_date, month_intervals),
    nl = 1
  ))
}
