# TabShapeR
# Defines functions that takes in ESRI Shapefiles and
# writes a .csv that can be imported into Tableau easily

# Loads required libraries
library(sp)
library(maptools)
library(rgeos)
library(rgdal)

#Initial function to import Shapefile into R and reproject
ImportToR <- function(Path,ImportName){
  setwd(Path)
  ShapeFile <- readOGR(dsn = Path, layer = ImportName)
  if(!is.na(is.projected(ShapeFile)) && is.projected(ShapeFile)){
    standard <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0")
    ShapeFile<- spTransform(ShapeFile, standard)
  }
  return(ShapeFile)
}


#Imports line type data
TabShapeRLines <- function(Path,ImportName,ExportName){
  
  setwd(Path)
  ShapeFile <- ImportToR(Path,ImportName)
  
  #Extracts the Data
  Data <- as(ShapeFile, "data.frame")
  
  Data$LineID <- as.numeric(rownames(Data))
  
  #extracts the coodinates and Line IDs
  Lines <- slot(ShapeFile,"lines")
  coordinates <- list(Latitude = numeric(0),
                      Longitude = numeric(0),
                      LineID = numeric(0),
                      PlotOrder = numeric(0))
  PlotOrderStart <- 0
  for(i in 1:length(Lines)){
    Line <- Lines[[i]]
    ID <- slot(Line, "ID")
    SubID <- 0
    for(j in 1:length(slot(Line,"Lines"))){
      SubID <- SubID + 1
      coords <- data.frame(slot(slot(Line,"Lines")[[j]],"coords"))
      coords$PlotOrder <- c(PlotOrderStart:(PlotOrderStart + nrow(coords)-1))
      PlotOrderStart <- (PlotOrderStart + nrow(coords))
      coordinates$Longitude <- c(coordinates$Longitude, coords[,1])
      coordinates$Latitude <- c(coordinates$Latitude, coords[,2])
      coordinates$LineID <- c(coordinates$LineID, rep(ID,nrow(coords)))
      coordinates$PlotOrder <- c(coordinates$PlotOrder, coords[,3])
      coordinates$LineSubID <- c(coordinates$LineSubID, rep(SubID,nrow(coords)))
    }
  }
  
  CombinedData <- merge(Data,coordinates)
  
  filename <- paste(ExportName,".csv", sep = "")
  write.csv(CombinedData, filename, row.names = FALSE)
}


#Imports Point type data
TabShapeRPoints <- function(Path,ImportName,ExportName){
  
  setwd(Path)
  ShapeFile <- ImportToR(Path,ImportName)
  
  Data <- as(ShapeFile, "data.frame")
  Data$PointID <- as.numeric(rownames(Data))
  names(Data)[names(Data)== "coords.x1"] <- "Longitude"
  names(Data)[names(Data)== "coords.x2"] <- "Latitude"
  
  filename <- paste(ExportName,".csv", sep = "")
  write.csv(Data, filename, row.names = FALSE)
}

# Extracts Polygon Type Data
TabShapeRPolygons <- function(Path,ImportName,ExportName){
  
  setwd(Path)
  ShapeFile <- ImportToR(Path,ImportName)
  
  Data <- as(ShapeFile, "data.frame")
  Data$ObjectID <- as.numeric(rownames(Data))
  
  #extracts the coodinates and polygon IDs
  ObjectList <- slot(ShapeFile,"polygons")
  coordinates <- list(Latitude = numeric(0),
                      Longitude = numeric(0),
                      PolygonID = numeric(0),
                      ObjectID = numeric(0),
                      PlotOrder = numeric(0))
  
  #Loops over Objects to extract coordinates
  PolygonID <- 0
  for(i in 1:length(ObjectList)){
    Object <- ObjectList[[i]]
    ObjectID <- slot(Object, "ID")
    #Loops over Polygons in Object to extract coordinates
    for(j in 1:length(slot(Object,"Polygons"))){
      Polygon <- slot(Object,"Polygons")[[j]]
      #excludes holes. This could be made an option.
      if(!slot(Polygon,"hole")){
        coords <- data.frame(slot(Polygon,"coords"))
        coords$PlotOrder <- c(1:nrow(coords))
        coordinates$PlotOrder <- c(coordinates$PlotOrder, c(1:nrow(coords)))
        coordinates$Longitude <- c(coordinates$Longitude, coords[,1])
        coordinates$Latitude <- c(coordinates$Latitude, coords[,2])
        coordinates$ObjectID <- c(coordinates$ObjectID, rep(ObjectID,nrow(coords)))
        coordinates$PolygonID <-c(coordinates$PolygonID, rep(PolygonID,nrow(coords)))
        PolygonID <- PolygonID + 1
      }
    }
  }
  
  CombinedData <- merge(Data,coordinates)
  
  filename <- paste(ExportName,".csv", sep = "")
  write.csv(CombinedData, filename, row.names = FALSE)
}
