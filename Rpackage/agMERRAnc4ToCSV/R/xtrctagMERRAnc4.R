#' Extract a netCDF file downloaded from agMERRA
#'
#' This function extracts data from a netCDF file using a 
#' SpatialPointsDataframe and ouptus the data in a format usable in MSPP tool
#'
#' @param nc4Files a vector of fullpaths to netCDF files
#' @param shpdf Object of class SpatialPointsDataFrame
#' @param name_1 column name in shpdf to be added in the output
#' @param name_2 column name in shpdf to be added in the output
#' @return A dataframe of extracted temperature values
#' @export
xtrctagMERRAnc4 <- function(nc4Files, shpdf, name_1, name_2) {
  
  outputfile <- cbind( rbind(c("Date", "Day", "Month", "Year"), 
                             data.frame(character(3), character(3), 
                                        character(3), character(3))),
                       rbind( t(shpdf@data[,c(name_1, 
                                              name_2)]),
                              t(sp::coordinates(shpdf))))
  
  row.names(outputfile) <- c()
  colnames(outputfile) <- c()
  print("Running......")
  suppressWarnings(library(raster))
  for (nc4File in nc4Files) {

    rasterbrick <- raster::brick(nc4File) #, varname = "tmin", lvar, level)
    
    # Save files
    for (layer in names(rasterbrick)) {
      date.count <- as.numeric(sub("X", "", layer))
      
      outputrow <- c(format(as.Date("1980-01-01") + date.count,  "%d/%m/%Y"),
                     as.numeric(format(as.Date("1980-01-01") + date.count,  "%d")),
                     as.numeric(format(as.Date("1980-01-01") + date.count,  "%m")),
                     as.numeric(format(as.Date("1980-01-01") + date.count,  "%Y")),
                     round(raster::extract(rasterbrick[[layer]], 
                                   shpdf, 
                                   sp = FALSE), 
                           digits = 1))
      
      outputfile <- rbind(outputfile, outputrow)
      
    }
  }
  print("Done")
  outputfile
}
