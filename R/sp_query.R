#' Explore what data is available
#'
#' @export
#' @param query Query terms
#' @examples \dontrun{
#' sp_query(query = "precipitation")
#' sp_query("temperature")
#' }
sp_query <- function(query) {
  lapply(dsets, function(z) {
    agrep(query, z$data, value = TRUE)
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