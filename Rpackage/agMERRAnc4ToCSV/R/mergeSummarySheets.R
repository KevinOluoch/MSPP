#' Merge the summary sheets
#'
#' This function merges the summary sheets of workbooks generated from the MSPP
#' Tool. It adds a column with the filename for ease in identifying the source file.
#'
#' @param xlsxfiles.dir a path to the directory of xlsx files
#' @return A dataframe of data in the xlsx files. The files are bind rowwise 
#'    and an extra column with file names added.
#' @export
mergeSummarySheets <- function(xlsxfiles.dir) {
  # Arusha_Varieties.dir <- "MSPP110_tests/Arusha/Arusha_Varieties"
  xlsxfiles.dir.files <- list.files(xlsxfiles.dir, pattern = "*.xlsx", full.names = TRUE)
  first <- TRUE
  for (xlsxfile in xlsxfiles.dir.files) {
    xlsxfile.basename <- sub(".xlsx", "", basename(xlsxfile))
    xlsxfile.data <- readxl::read_xlsx(xlsxfile)
    
    # Create output and store first columns
    if (first){
      all.xlsxfiles <- cbind(filename=rep(xlsxfile.basename, 
                                          dim(xlsxfile.data)[1]),
                             xlsxfile.data)
      first <- FALSE
      next
    }
    all.xlsxfiles <- rbind(all.xlsxfiles, 
                           cbind(filename=rep(xlsxfile.basename, 
                                              dim(xlsxfile.data)[1]),
                                 xlsxfile.data))
    
  }
  all.xlsxfiles
}


