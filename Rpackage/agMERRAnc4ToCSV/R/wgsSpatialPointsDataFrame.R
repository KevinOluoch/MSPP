#' Create a SpatialPointsDataframe in WGS coordinate system fron a CSV file
#'
#' This function returns a SpatialPointsDataframe in WGS coordinate system 
#' generated from a csv file with coordinates in any system. This function 
#' removes entries in the csv with NAs
#'
#' @param filepath path to csv file with coordianes
#' @param crsobject object of 
#'        class \CRS{http://127.0.0.1:35826/help/library/sp/help/CRS}
#' @return object of class SpatialPointsDataframe in WGS coordinate system
#' @export
wgsSpatialPointsDataFrame <- function(filepath, crsobject, LongitudeColumn, LatitudeColumn) {
  defaultW <- getOption("warn") 
  options(warn = -1) 
  

  
  if(missing(crsobject)) crsobject <- 
      sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  wgs.prj <- 
    sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  
  extractLocations <- read.csv(filepath)
  extractLocations <- extractLocations[complete.cases(extractLocations), ]
  
  extractLocations.shp <-
    sp::SpatialPointsDataFrame(data.frame(extractLocations[,LongitudeColumn], 
                                      extractLocations[,LatitudeColumn]), 
                           data = extractLocations, 
                           proj4string = crsobject)
  
  output <- sp::spTransform(extractLocations.shp, CRSobj = wgs.prj)
  
  options(warn = defaultW)
  output
  }