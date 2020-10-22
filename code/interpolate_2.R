library(devtools)
# Load "agMERRAnc4ToCSV" package
path2package <- "Rpackage/agMERRAnc4ToCSV"
devtools::load_all(path2package)




Arusha_Varieties.dir <- "MSPP110_tests/Arusha/Arusha_Varieties"
Mbeya_Varieties.dir <- "MSPP110_tests/Mbeya/Mbeya_Varieties"

# Merge Summary Sheets of MSPP output
Arusha_Varieties.df <- agMERRAnc4ToCSV::mergeSummarySheets(Arusha_Varieties.dir)
Mbeya_Varieties.df <- agMERRAnc4ToCSV::mergeSummarySheets(Mbeya_Varieties.dir)


dir.create("./output/csv", showWarnings = FALSE, recursive = TRUE)

write.csv(Arusha_Varieties.df, "./output/csv/Arusha_Varieties.csv")
write.csv(Mbeya_Varieties.df, "./output/csv/Mbeya_Varieties.csv")

# MAP DATA --------------------------------------------------------------------
# a map for one variety (v2) based on 01 Jan sowing date  
# for  sowing to maturity 
# and just for TZ and the crop area? 

# Create Sowing to Maturity raster
V2_Briere_3.df <- read.csv("data/V2_Briere_3_1980_2009_010203040506070809101112_011020.csv")
V2_Briere_3_Jan1st.df <- 
  V2_Briere_3.df[V2_Briere_3.df$Sowing.Month == 1 & V2_Briere_3.df$Sowing.Day == 1,]
V2_Briere_3_Jan1st.raster <- 
    agMERRAnc4ToCSV::interpolateMeanDays(Lon = V2_Briere_3_Jan1st.df$Lon, 
                                         Lat = V2_Briere_3_Jan1st.df$Lat,
                                         meandays = (V2_Briere_3_Jan1st.df$Flowering.Mean + 
                                           V2_Briere_3_Jan1st.df$Maturity.Mean))
  
# Mask to Maize Areas  
SSA.Maize.production <- raster::raster("data/mapSPAM/spam2017V1r1_SSA_gr_P_MAIZ_A.tif")
SSA.Maize.production.crop <- raster::crop(SSA.Maize.production, 
                                           raster::extent(V2_Briere_3_Jan1st.raster))

raster::values(SSA.Maize.production.crop)[raster::values(SSA.Maize.production.crop) %in% 0] <- NA

# Align the rasters before masking
SSA.Maize.production.adj <- raster::projectRaster(SSA.Maize.production.crop, 
                        V2_Briere_3_Jan1st.raster,
                        method="ngb")

SSA.Maize.production.adj <- raster::projectRaster(SSA.Maize.production.crop, 
                                                    V2_Briere_3_Jan1st.raster,
                                                    method="bilinear")

#Mask
V2_Briere_3_Jan1st.raster.mask <- raster::mask(V2_Briere_3_Jan1st.raster, SSA.Maize.production.adj)
V2_Briere_3_Jan1st.raster.mask
# raster::plot(V2_Briere_3_Jan1st.raster.mask )



# MAPS --------------------------------------------------------------------
#  map with the district  boundaries, 
#  maps, one for Arusha and one for Mbeya
#   

# Get Shapefiles
dir.create("./data/shp", showWarnings = FALSE, recursive = TRUE)
tza <- list()
tza[["shp0"]] <- raster::getData("GADM", country = "TZA", level = 0, path = "data/shp")
tza[["shp1"]] <- raster::getData("GADM", country = "TZA", level = 1, path = "data/shp")
tza[["shp2"]] <- raster::getData("GADM", country = "TZA", level = 2, path = "data/shp")
tza[["shp3"]] <- raster::getData("GADM", country = "TZA", level = 3, path = "data/shp")

tza[["sf0"]] <- base::merge(sf::st_as_sf(tza[["shp0"]]), tza[["shp0"]]@data, base::names(tza[["shp0"]]))
tza[["sf1"]] <- base::merge(sf::st_as_sf(tza[["shp1"]]), tza[["shp1"]]@data, base::names(tza[["shp1"]]))
tza[["sf2"]] <- base::merge(sf::st_as_sf(tza[["shp2"]]), tza[["shp2"]]@data, base::names(tza[["shp2"]]))
tza[["sf3"]] <- base::merge(sf::st_as_sf(tza[["shp3"]]), tza[["shp3"]]@data, base::names(tza[["shp3"]]))


# Prepare raster data
V2_Briere_3_Jan1st.raster.mask.df <- raster::as.data.frame(V2_Briere_3_Jan1st.raster.mask, 
                                                      xy = TRUE)

# Create Plot base
main.plot <- ggplot2::ggplot() +
  ggplot2::geom_raster(ggplot2::aes(x = x, y = y, 
                                    fill = var1.pred), 
                       V2_Briere_3_Jan1st.raster.mask.df ) +
  ggplot2::geom_sf(data = tza[["sf3"]],  colour="grey80", fill=NA, size=0.4) +
  ggplot2::geom_sf(data = tza[["sf2"]],  colour="grey50", fill=NA, size=0.6) +
  ggplot2::geom_sf(data = tza[["sf1"]],  colour="grey20", fill=NA, size=0.8) +
  ggplot2::geom_sf(data = tza[["sf0"]],  colour="black", fill=NA, size=1) + 
  ggplot2::scale_fill_gradientn(name = "Mean Days To Maturity", colours = grDevices::rainbow(10)) +
  ggplot2::labs( x="Longitude", y="Latitude") 


# Create plots
tza.plots <- list()

# Create list of required plots
required.plots <- list(c("Arusha Urban", "Arusha" ),     # Arusha
                       c("Mbeya Rural", "Mbeya Urban" ), # Mbeya
                       tza[["sf2"]]$NAME_2)              # All Districts


for (area.lim.count in 1:length(required.plots)) {
  area.lim <-  required.plots[[area.lim.count]]
  
  area.lim1 <- sf::st_bbox (tza[["sf2"]][tza[["sf2"]]$NAME_2 %in% area.lim,] )
  min.x1 <- area.lim1["xmin"]
  max.x1 <- area.lim1["xmax"]
  min.y1 <- area.lim1["ymin"]
  max.y1 <- area.lim1["ymax"]
  
  inset.plot <- ggplot2::ggplotGrob( 
    ggplot2::ggplot() + 
      ggplot2::geom_sf(data = sf::st_as_sfc(sf::st_bbox (tza[["sf2"]])), 
                       fill = "white", color = NA) +
      ggplot2::geom_sf(data = tza[["sf1"]],  colour="grey20", fill=NA, size=0.1) +
      ggplot2::geom_sf(data = tza[["sf0"]],  colour="black", fill=NA, size=0.2) + 
      ggplot2::geom_sf(data = sf::st_as_sfc(area.lim1), fill = NA, color = "red", size = 0.5) +
      ggplot2::theme_void()
  )
  
  if (all(tza[["sf2"]]$NAME_2 %in% area.lim)){
    main.plot.zoom <- main.plot +
      ggplot2::geom_sf_text(data = tza[["sf1"]][!tza[["sf1"]]$NAME_1 %in% c("Pemba North", 
                                                                           "Pemba South", 
                                                                           "Zanzibar North",
                                                                           "Zanzibar South and Central",
                                                                           "Zanzibar West"  ),], 
                            ggplot2::aes(label = NAME_1))
  } else{
    main.plot.zoom <- main.plot +
      ggplot2::geom_sf(data = tza[["sf2"]][tza[["sf2"]]$NAME_2 %in% area.lim,],  
                       colour="black", fill=NA, size=0.6, linetype = "dashed") +
      ggplot2::geom_sf_text(data = tza[["sf2"]], ggplot2::aes(label = NAME_2)) 
    }
  
  main.plot.zoom <- main.plot.zoom + 
    # ggplot2::geom_sf_text(data = tza[["sf2"]], ggplot2::aes(label = NAME_2)) +
    ggplot2::ggtitle("Flowering to Maturity Mean Days") +
    ggplot2::theme(panel.border = ggplot2::element_rect(fill = NA, size = 0.5, 
                                      linetype = 'solid',
                                      colour = "black")) +
    ggsn::scalebar(x.min = min.x1, x.max = max.x1, 
                   y.min = min.y1, y.max = max.y1, 
                   dist = ceiling((max.y1-min.y1 )*111/100)*10, dist_unit = "km", 
                   transform = TRUE, location = "bottomleft", st.size = 3) +
    ggsn::north(x.min = min.x1, x.max = max.x1, 
                y.min = min.y1, y.max = max.y1, 
                scale = .08, symbol = 9) +
    ggplot2::coord_sf(xlim=c(min.x1, max.x1), ylim=c(min.y1, max.y1)) +
    ggplot2::theme(plot.title = ggplot2::element_text(size = 20, face = "bold"),
          legend.position = "right",
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          panel.border = ggplot2::element_rect(fill = NA, size = 0.5, 
                                      linetype = 'solid',
                                      colour = "black"),
          panel.background = ggplot2::element_rect(fill = "lightblue",
                                          colour = "lightblue",
                                          size = 0.5, linetype = "solid")) 

    dir.create("./output/plots", showWarnings = FALSE)
    
    
  if (all(tza[["sf2"]]$NAME_2 %in% area.lim)){
    ggplot2::ggsave("./output/plots/TZ.pdf", 
                    main.plot.zoom, height = 21  ,  width = 29.7, 
                    units = "cm", limitsize = FALSE)
  } else{
    main.plot.zoom <- main.plot.zoom  +
      ggplot2::annotation_custom(grob =  inset.plot, 
                                 xmin = min.x1, 
                                 xmax = (min.x1 + base::signif((max.x1 - min.x1)*.2, digits = 3)),
                                 ymin = (max.y1 - base::signif((max.y1 - min.y1)*.2, digits = 3)),
                                 ymax = max.y1 )
    ggplot2::ggsave(paste0("./output/plots/TZ", 
                           substr(paste(substr(area.lim, 1, 3), 
                                        collapse = ''), 1, 12), ".pdf"), 
                    main.plot.zoom, 
                    height = 21,  
                    width = 29.7, 
                    units = "cm", 
                    limitsize = FALSE)
    
  }
  
  
}



