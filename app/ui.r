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
library(shiny)
library(shinydashboard)

#source
source("../lib/plot_functions.R")
source("../lib/filter_data_functions.R")

#load data
raw_data = read.csv("../output/flight_data.csv")

dest_airport=c('All',as.character(sort(unique(raw_data$dest))))
orig_airport=c('All',as.character(sort(unique(raw_data$orig))))

#
# ui.R
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Flight Delay Time Expectations", tabName = "first_app"),
      menuItem("Flight Delay Reasons", tabName = "second_app")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "first_app",
              h2("Flight Delay Time Expectations"),
              fluidPage(
                box(
                  selectInput(inputId = "destination",
                              label  = "Select the Destination",
                              choices = dest_airport,
                              selected ='All')),
                box(
                  selectInput(inputId = "origin",
                              label  = "Select the Origin",
                              choices = orig_airport,
                              selected ='All')
                  ),
              box(plotOutput("plt_delay_time")),
              box(plotOutput("plt_delay_flight_distr")),
              box(plotOutput("plt_delay_time_distr"))
      )),
      tabItem(tabName = "second_app",
              h2("Flight Delay Reasons"))
    )
  )
)
