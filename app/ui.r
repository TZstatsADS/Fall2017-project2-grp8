packages.used <- 
  c("ggplot2",
    "plyr",
    "reshape2",
    "reshape",
    "shiny",
    "dplyr",
    "lubridate",
    "zoo"
  )

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

#load the packages
library(ggplot2)
library(zoo)
library(lubridate)
library(dplyr)

#source
source("../lib/plot_functions.R")
source("../lib/filter_data_functions.R")

#load data
raw_data = read.csv("../output/flight_data.csv")

dest_airport=c('All',as.character(sort(unique(raw_data$dest))))
orig_airport=c('All',as.character(sort(unique(raw_data$orig))))

#
# ui.R

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Satisfication Probability of Carriers"),
  
  # Sidebar with a selector input for neighborhood
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "destination",
                           label  = "Select the Destination",
                           choices = dest_airport,
                           selected ='All'),
               selectInput(inputId = "origin",
                           label  = "Select the Origin",
                           choices = orig_airport,
                           selected ='All'),
               
               width = 3
    ),
    # Show two panels
    mainPanel(
      h3(code(textOutput("text1"))),
      tabsetPanel(
        tabPanel(h3("Flight Delay Analysis"),
                 plotOutput("plt_delay_time"),
                 plotOutput("plt_delay_flight_distr"),
                 plotOutput("plt_delay_time_distr"),
                 value=0)
        )
    )
 )
))