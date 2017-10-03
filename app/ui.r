packages.used <- 
  c("ggplot2",
    "plyr",
    "reshape2",
    "reshape",
    "shiny",
    "dplyr",
    "lubridate",
    "zoo",
    "treemap"
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
library(treemap)

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
      menuItem("Flight Delay Reasons", tabName = "second_app"),
      menuItem("Flight Delay Probability", tabName = "third_app")
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
              h2("Flight Delay Reasons"),
              
                box(
                  selectInput(inputId = "destination2",
                              label  = "Select the Destination",
                              choices = dest_airport,
                              selected ='All'),
                  selectInput(inputId = "origin2",
                              label  = "Select the Origin",
                              choices = orig_airport,
                              selected ='All'),
                  selectInput(inputId = "month",
                                label  = "Select the Month",
                                choices = c('Jan','Feb','Mar','Apr','May','Jun','Jul',
                                            'Aug','Sep','Oct','Nov','Dec'),
                                selected ='Jan')),
                box(plotOutput("plt_delay_reason_distr"))
              
            ),
           
      tabItem(tabName = "third_app",
              h2("Flight Delay Probability"),
              
                box(
                  selectInput(inputId = "destination3",
                           label  = "Select the destination",
                           choices = dest_airport,
                           selected ='ATL (Atlanta, GA)'),
                 selectInput(inputId = "origin3",
                             label  = "Select the origin",
                             choices = orig_airport,
                             selected ='AUS (Austin, TX)'),
                 sliderInput(inputId = "mon3",
                             label = "Select the month",
                             value = 1, min =1, max =12),
                 sliderInput(inputId = "satisfy_time3",
                             label = "Select the limit of delay time (hr)",
                             value = 1,min = 0,max = 5)),
                box(plotOutput("treemap",width = "100%", height = 600),
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, 
                               top = 600, left = 20, right = "auto", bottom = "auto",
                               width = 350, height = "auto",
                               plotOutput("ggplot",width="100%",height="250px")
               ))
              
            )
    )
  )
)
