#' Create vector of fullpaths to netCDF files in the folder
#'
#' This function get the full path to all netCDF files in a folder. The 
#' function is recursive: it will search the sub folders.
#'
#' @param folder Path to folder with netCDF files
#' @return A dataframe of extracted temperature values
#' @export

nc4fullpaths <- function(folder) {
  list.files(folder,
             pattern = "*.nc4",
             full.names = TRUE, 
             recursive = TRUE)
}