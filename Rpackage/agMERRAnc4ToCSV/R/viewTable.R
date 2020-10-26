#' View data per Variety
#'
#' This function views MSPP output as a table of variety with each "Name 2" 
#' location as a column heading. The rows contain data per date
#'
#' @param inputData a data frame, or filepath to a xlsx file, generated 
#'     by MSPP tool or agMERRAnc4ToCSV::mergeSummarySheets().
#' @return A plot of the data in viewer that can be exported or saved.
#' @export
viewTable <- function(inputData, table.title="'Variety Table'", variety=1 ) {
  # Check if input is data or filepath
  # inputData <- qqq
   if(base::is.data.frame(inputData) && base::nrow(inputData)> 0){
    inputData.df <- inputData
    # If table.title input is missing, use 'Variety Table'
    if(base::missing(table.title)) table.title <- 'Variety Table'
    
  } else if (base::is.character(inputData) & base::length(inputData)==1 & 
      base::file.exists(inputData) & tools::file_ext(inputData, 
                                                      compression = FALSE) == "xlsx" ){
    inputData.df <- readxl::read_xlsx(inputData)
    
    # If table.title input is missing, use file name
    if(base::missing(table.title)) table.title <- base::basename(inputData)
    
  } else{stop("Invalid inputData")}
  
  # Prepare data
  if("filename" %in% base::colnames(inputData.df )){
    options(warn = -1)
    
    Vdf4 <- list()
    # Prepare agMERRAnc4ToCSV::mergeSummarySheets() data
    file_variety_names <- unique(inputData.df[, "filename"])
    
    # Get Variety Id  
    defaultW <- base::getOption("warn") 
    base::options(warn = -1)  
    if(!base::is.na(as.numeric(variety)) ){
      if(base::as.numeric(variety)%%1==0){
        variety.id <- base::as.integer(variety)
        }else{
          base::print("Variety Missing; Showing the First")
          variety.id <- 1
        }
      
    } else if(base::is.character(variety)){
      if(base::is.na(base::match(variety, file_variety_names))){
        base::print("Variety Missing; Showing the First")
        variety.id <- 1
      }else {variety.id <- base::match(variety, file_variety_names)}
      
    }
    base::options(warn = defaultW)  
    
    for (Vname in file_variety_names) {
      Vdf <- inputData.df[inputData.df[, "filename"] %in% Vname,]
      Vdf3 <- base::data.frame()
      
      for (Mname in unique(Vdf[, "Sowing Month"])) {
        for (Dname in unique(Vdf[, "Sowing Day"])) {
          Vdf2 <- Vdf[Vdf[, "Sowing Month"] %in% Mname & Vdf[, "Sowing Day"]  %in%  Dname,]
          
          if (base::is.data.frame(Vdf3) && base::nrow(Vdf3)==0){
            Vdf3 <- c(Dname, Mname, Vdf2[1, c("Start Year", "End Year")],
                      base::t(Vdf2[, "Flowering Mean"] + Vdf2[, "Maturity Mean"]))
            base::names(Vdf3) <- c("Sowing Day", "Sowing Month", 
                             "Start Year", "End Year",  
                             Vdf2[, "Name 2"])
            next
          }
          Vdf3 <- base::rbind(Vdf3, c(Dname, Mname, Vdf2[1, c("Start Year", "End Year")], 
                                base::t(Vdf2[, "Flowering Mean"] + Vdf2[, "Maturity Mean"])))
        }
      }
      base::row.names(Vdf3) <- c()
      Vdf4[[Vname]] <- Vdf3 
    }
    Vdf4
  } else {
    # Prepare data from single MSPP Computation
    Vdf3 <- base::data.frame()
    Vdf <- inputData.df
    
    for (Mname in unique(Vdf[, "Sowing Month"])) {
      for (Dname in unique(Vdf[, "Sowing Day"])) {
        Vdf2 <- Vdf[Vdf[, "Sowing Month"] %in% Mname & Vdf[, "Sowing Day"]  %in%  Dname,]
        if (base::is.data.frame(Vdf3) && base::nrow(Vdf3)==0){
          Vdf3 <- base::data.frame(c(Dname, Mname, Vdf2[1, c("Start Year", "End Year")],
                    base::t(Vdf2[, "Flowering Mean"] + Vdf2[, "Maturity Mean"])))
          base::names(Vdf3) <- c("Sowing Day", "Sowing Month", "Start Year", "End Year",
                           Vdf2[, "Name 2"])
          next
        }
        tmp <- data.frame(c(Dname, Mname, Vdf2[1, c("Start Year", "End Year")],
                            base::t(Vdf2[, "Flowering Mean"] + Vdf2[, "Maturity Mean"])))
        base::names(tmp) <- c("Sowing Day", "Sowing Month", "Start Year", "End Year", 
                                           Vdf2[, "Name 2"])
        Vdf3 <- rbind(Vdf3, tmp)
        }
    }
    Vdf4 <- base::data.frame(matrix(unlist(Vdf3), ncol = base::length(Vdf3), byrow=F ))
    base::names(Vdf4 ) <- c("Sowing Day", "Sowing Month", "Start Year", 
                      "End Year", Vdf2[, "Name 2"])
    
    }
  
  # Display data from a single MSPP computation
  if (class(Vdf4) == "data.frame"){
    Vdf5 <- Vdf4
    table.title <- table.title
  }
  # If data from agMERRAnc4ToCSV::mergeSummarySheets, show the selected one
  if (class(Vdf4) == "list"){
    Vdf5 <- Vdf4[[variety]]
    table.title <- base::paste0(table.title, ": ", file_variety_names[variety.id])
  }
  
DT::datatable(Vdf5, 
              caption = table.title,
              filter = 'top',
              extensions = 'Buttons',
              options = list(dom = 'lfrtipB',
                             buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                             lengthMenu = list(c(10,25,50,-1),
                                               c(10,25,50,"All"))))
  
}


