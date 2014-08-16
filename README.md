TabShapeR
=========

A tool to import ESRI Shapefiles into Tableau using R

##Installing Programs and Packages

1. Download and install R (http://cran.r-project.org/bin/windows/base/)
2. Open RStudio
3. Click the packages button
4. Click on Install Packages
6.	Type “rgdal, maptools, sp, rgeos” into the Packages line
7.	Click Install

##Running Code

1.	In RStudio, select File > Open File…
2.	Navigate to TabShapeR.R and select Open
3.	Highlight all code in TabShapeR and click Run
 
4.	Select File > Open File…
5.	Open TabShapeRTemplate.R
6.	Add the full path of the directory where Shapefile is stored after directory =
  1.	If using Windows, ensure that all “\” characters are replaced with “/” characters or you will receive a “ ‘\U’ used without hex digits” error message

7.	Add name of ESRI shapefile after name =
a.	Do not include any extensions in the name.
8.	Add name of the file where the data should write to after endName =
9.	Delete the # in front of the appropriate TabShapeR command based on the type of data being imported (lines, points, or polygons) 
10.	Highlight all code and select Run (this may run for a while)

## Connecting to data in Tableau Desktop
###Lines
1.	Connect to .csv file using Connect to Data > Text File
2.	Import All.
3.	Select Line in the plot type drop down on the Marks card.
4.	Deselect Analysis > Aggregate Measures.
5.	Drag LineID to the Details shelf and PlotOrder to the Path shelf of the Marks card.
6.	Double click on Latitude, and then double click on longitude.

###Polygons
1.	Connect to .csv file using Connect to Data > Text File
2.	Import All.
3.	Select Polygon in the plot type drop down on the Marks card.
4.	Deselect Analysis > Aggregate Measures.
5.	Drag PolygonID to the Details shelf and PlotOrder to the Path shelf of the Marks card.
6.	Double click on Latitude, and then double click on longitude.

###Points
1.	Connect to .csv file using Connect to Data > Text File
2.	Import All.
3.	Drag PointID to the Details shelf of the Marks card.
4.	Double click on Latitude, and then double click on longitude.
