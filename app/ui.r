packages.used <- 
  c("ggplot2",
    "plyr",
    "reshape2",
    "reshape",
    "shiny",
    "dplyr",
    "lubridate",
    "zoo",
    "treemap",
    "plotly",
    "leaflet",
    "geosphere"
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
library(plotly)
library(reshape2)
library(leaflet)
library(geosphere)


source("../../lib/plot_functions.R")
source("../../lib/filter_data_functions.R")
source("../../lib/flight_path_map.R")
source("../../lib/delay_percent_barplot.R")


raw_data = read.csv("../../output/flight_data.csv")
dest_airport=c('All',as.character(sort(unique(raw_data$dest))))
orig_airport=c('All',as.character(sort(unique(raw_data$orig))))

temp <-  read.csv("../../output/temp.csv",header=T)
origins <- as.character(sort(unique(temp$orig)))
destinations <- as.character(sort(unique(temp$dest)))

#Define UI for application that draws a histogram
shinyUI(navbarPage(theme = "bootstrap.min-copy.css",'Flight Delay',
        tabPanel("Introduction",
                 mainPanel(
                   img(src="world_flight.jpg",height='300',width='600'),
                   h2('Introduction')
                   )
                 # titlePanel(h2("Introduction")),
                 # mainPanel(tabPanel("Introduction"))
        ),
        tabPanel('APP',
                 sidebarLayout(
                   sidebarPanel(
                
                     selectInput(inputId = "origin",
                                 label  = "Select the Origin",
                                 choices = origins,
                                             selected ='JFK (New York, NY)'),
                     selectInput(inputId = "destination",
                                 label  = "Select the Destination",
                                 choices = c('all',destinations),
                                 selected ='all'),
                     selectInput(inputId = "month",
                                 label  = "Select the Month",
                                 choices = c('Jan','Feb','Mar','Apr','May','Jun','Jul',
                                             'Aug','Sep','Oct','Nov','Dec'),
                                 selected ='Jul'),
                     radioButtons(inputId = "type",
                                  label = 'Calculated by:',
                                  choices = c('Percent of delay flights',
                                              'Average delay time'),
                                  selected = 'Percent of delay flights'),
                     width = 3
                 ),
                   
                   mainPanel(
                     #plotOutput("delay_barplot",height='200px')
                          
                     box(leafletOutput("map"),
                         width=600),
                     
                     box(plotlyOutput("delay_barplot",height='200px'),width=300)
                     )
                                   
                   )
                 ),
        
        tabPanel('Delay Time Expectation',
                 sidebarLayout(
                   sidebarPanel(
                     
                     selectInput(inputId = "destination1",
                                 label  = "Select the Destination",
                                 choices = dest_airport,
                                 selected ='All'),
                     selectInput(inputId = "origin1",
                                 label  = "Select the Origin",
                                 choices = orig_airport,
                                 selected ='All'),
                     width = 3
                   ),
                   
                   mainPanel(
                     box(plotlyOutput("plt_delay_time"),width=300),
                     box(plotlyOutput("plt_delay_flight_distr"),width=300),
                     box(plotlyOutput("plt_delay_time_distr"),width=300)
                     )
                )
        ),
        
        tabPanel('Delay Reason Expectation',
                 sidebarLayout(
                   sidebarPanel(
                     
                     selectInput(inputId = "destination2",
                                 label  = "Select the Destination",
                                 choices = dest_airport,
                                 selected ='All'),
                     selectInput(inputId = "origin2",
                                 label  = "Select the Origin",
                                 choices = orig_airport,
                                 selected ='All'),
                     selectInput(inputId = "month2",
                                 label  = "Select the Month",
                                 choices = c('Jan','Feb','Mar','Apr','May','Jun','Jul',
                                             'Aug','Sep','Oct','Nov','Dec'),
                                 selected ='Jan'),
                     width = 3
                   ),
                   
                   mainPanel(
                     box(plotlyOutput("plt_delay_reason_distr"),width=300)
                     )
                   )
                 ),
        
        tabPanel('Statistics'),
        tabPanel('About Us',
                 includeMarkdown('contact.md'))
        )
        )




