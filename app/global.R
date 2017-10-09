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


flightData <- read.table(file = "../data/FlightViz/1990Fout/199001Fout.csv",
                         as.is = T, header = T,sep = ",")
flightData$FL_DATE <- parse_date_time(flightData$FL_DATE, "%Y-%m-%d")
flightData <- flightData[flightData$ORIGIN == c("JFK", "LAX", "SEA"),]



