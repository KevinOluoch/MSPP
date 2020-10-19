#' Interpolate mean days over the coordinates extent
#'
#' This function interpolates the mean days values over the extent of the input 
#' coordinates.
#' The function raises an error if the length of the inputs differ 
#'
#' @param Lon a vector of Longitude values
#' @param Lat  a vector of Latitude values
#' @param meandays a vector of values to be interpolatd
#' @return A raster of interpolaed mean days values covering the extent of 
#'     the coordinates
#' @export
interpolateMeanDays <- function(Lon, Lat, meandays) {
  if (!length(Lon) == length(Lat) & !length(Lon) == length(meandays)){
    stop("Lon, Lat and meandays have diffrent lengths")
  }
  
  # Create SpatialPointsDataFrame Object
  data.sp <- 
    sp::SpatialPointsDataFrame(base::data.frame(base::as.numeric(Lon),
                                                base::as.numeric(Lat)),
                               base::data.frame(Lon = Lon, Lat = Lat, meandays = meandays))
  
  # Create sf Object
  data.sf <- base::merge(sf::st_as_sf(data.sp), 
                   data.sp@data, 
                   base::names(data.sp))
  
  # Create an empty raster in the area
  paramsRaster <- raster::raster(raster::extent(data.sf), 
         ncols=1000, nrows=1000)
  res1kmInDeg <- 0.0083333
  raster::res(paramsRaster) <- res1kmInDeg
  
  # Convert the Study Area to a raster using parameters Raster
  gadmEmptyRaster <- raster::rasterize(raster::extent(data.sp), paramsRaster)

  # Create spatial grided spatial data
  gadmEmptyCells <- base::as.data.frame(raster::xyFromCell(gadmEmptyRaster, 
                                           1:raster::ncell(gadmEmptyRaster)))

  base::names(gadmEmptyCells)       <- c("X", "Y")
  sp::coordinates(gadmEmptyCells) <- c("X", "Y")
  sp::gridded(gadmEmptyCells)     <- TRUE  
  sp::fullgrid(gadmEmptyCells)    <- TRUE  
  # sp::proj4string(gadmEmptyCells) <- 
  #   proj4string(sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84"))
  
  output <- raster::raster( gstat::idw(meandays ~ 1,
                                       locations = data.sp,
                                       newdata = gadmEmptyCells,
                                       idp = 3.0))
  raster::crs(output) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs")
  output
}


