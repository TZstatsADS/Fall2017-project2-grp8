packages.used <- 
  c("ggplot2",
    "shiny",
    "dplyr",
    "leaflet",
    "geosphere",
    "sparklyr",
    "DT",
    "lubridate"
  )

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(leaflet)
library(geosphere)
library(sparklyr)
library(lubridate)



###======== code ========
##========= data cleaning part =========

#flightData <- read.table(file = "../../../data/FlightViz/test.csv",
#                         as.is = T, header = T,sep = ",")
#flightData <- flightData[,-5]
#flightData$FL_DATE <- strptime(flightData$FL_DATE, "%Y/%m/%d")

#airportLocation <- read.table(file = "../../../data/FlightViz/test-address.csv",
#                              as.is = T, header = T,sep = ",")
#airportLocation <- airportLocation[,-3]
#colnames(airportLocation) <- c("LON", "LAT")





#flightData <- read.table(file = "../../../data/FlightViz/199001.csv",
#                        as.is = T, header = T,sep = ",")
#flightData <- flightData[, c(1, 2, 3, 4)]
#flightData <- flightData%>%
#  group_by(FL_DATE, ORIGIN, DEST) %>%
#  summarise(meanDelay=(mean(DEP_DELAY_NEW)))
#flightData <- na.omit(flightData)
#write.table(flightData, file = "../../../data/FlightViz/199001.csv",
#            col.names = T, sep = ",")
flightData <- read.table(file = "../../../data/FlightViz/199001.csv",
                         as.is = T, header = T,sep = ",")
flightData$FL_DATE <- parse_date_time(flightData$FL_DATE, "%Y-%m-%d")



airportLocation <- read.table(file = "../../../data/FlightViz/airport_location.csv",
                              as.is = T, header = T,sep = ",")
airportLocation <- airportLocation[!duplicated(airportLocation$IATA),]
rownames(airportLocation) <- airportLocation$IATA
airportLocation <- airportLocation[,-1]
colnames(airportLocation) <- c("LON", "LAT")
airportLocation <- na.omit(airportLocation)
