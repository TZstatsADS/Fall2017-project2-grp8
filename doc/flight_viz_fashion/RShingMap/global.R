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


#flightData1990 <- read.table(file = "/Users/laohuang/Desktop/ADS/ADSforChristinaH/Fall2017-project2-grp8/data/FlightViz/1990.csv",
#                         as.is = T, header = T,sep = ",")
#flightData1990$FL_DATE <- substr(flightData1990$FL_DATE, 6, 10)
#flightData1990$FL_DATE <- parse_date_time(flightData1990$FL_DATE, "%m/%d")
#flightData1990 <- flightData1990[flightData1990$ORIGIN == c("JFK", "LAX", "SEA", "ATL"),]



#flightData2010 <- read.table(file = "/Users/laohuang/Desktop/ADS/ADSforChristinaH/Fall2017-project2-grp8/data/FlightViz/2010.csv",
#                         as.is = T, header = T,sep = ",")
#flightData2010$FL_DATE <- substr(flightData2010$FL_DATE, 6, 10)
#flightData2010$FL_DATE <- parse_date_time(flightData2010$FL_DATE, "%m-%d")
#flightData2010 <- flightData2010[flightData2010$ORIGIN == c("JFK", "LAX", "SEA", "ATL"),]

