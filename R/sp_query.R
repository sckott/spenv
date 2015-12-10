#' Explore what data is available
#'
#' @export
#' @param variable Query for a variable
#' @param source Query for a data source
#' @examples \dontrun{
#' # THESE DON'T ACTUALLY WORK YET...
#' # Query by data variable
#' sp_query(variable = "precipitation")
#' sp_query(variable = "temperature")
#'
#' # Query by data variable
#' sp_query(source = "noaa")
#'
#' # Query by spatial resolution
#' sp_query(spatial_res = "noaa")
#'
#' # Query by temporal resolution
#' sp_query(temporal_res = "weekly")
#'
#' # Query by spatial coverage
#' sp_query(spatial_coverage = "global")
#'
#' # Query by temporal coverage
#' sp_query(temporal_coverage = "1950:1970")
#'
#' # Query by license
#' sp_query(license = "CC0")
#' }
sp_query <- function(variable = NULL, source = NULL) {
  lapply(dsets, function(z) {
    agrep(variable, z$data, value = TRUE)
  })
}

dsets <- list(
  rnoaa_buoy = list(
    pkg = "rnoaa",
    fxn = "buoy",
    data = c("precipitation")
  ),
  rnoaa_gefs = list(
    pkg = "rnoaa",
    fxn = "gefs",
    data = rnoaa::gefs_variables()
  )
)
