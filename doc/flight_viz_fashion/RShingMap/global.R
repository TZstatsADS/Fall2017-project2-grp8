library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(leaflet)
library(geosphere)
library(sparklyr)

<<<<<<< Updated upstream
flightData <- read.table(file = "../../../data/FlightViz/test.csv",
=======
flightData <- read.table(file = "../data/FlightViz/test.csv",
>>>>>>> Stashed changes
                         as.is = T, header = T,sep = ",")
flightData <- flightData[,-5]
flightData$FL_DATE <- strptime(flightData$FL_DATE, "%Y/%m/%d")

airportLocation <- read.table(file = "../../../data/FlightViz/test-address.csv",
                              as.is = T, header = T,sep = ",")
#rownames(airportLocation) <- airportLocation[,1]
airportLocation <- airportLocation[,-3]
colnames(airportLocation) <- c("LON", "LAT")
