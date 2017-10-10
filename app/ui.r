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


source("../lib/plot_functions.R")
source("../lib/filter_data_functions.R")
source("../lib/flight_path_map.R")
source("../lib/delay_percent_barplot.R")


raw_data = read.csv("../output/flight_data.csv")
dest_airport=c('All',as.character(sort(unique(raw_data$dest))))
orig_airport=c('All',as.character(sort(unique(raw_data$orig))))

temp <-  read.csv("../output/temp.csv",header=T)
origins <- as.character(sort(unique(temp$orig)))
destinations <- as.character(sort(unique(temp$dest)))

#Define UI for application that draws a histogram
shinyUI(navbarPage(theme = "bootstrap.min-copy.css",'Flight Delay',
        tabPanel("Introduction",
                 tabName="Introduction",
                 icon=icon("book"),
                 #menuItem("Overview",tabName="Overview",icon=icon("book")),
                 
                 mainPanel(
                   img(src="world_flight.jpg",height='300',width='600'),
                   h2('Introduction')
                   )
                 # titlePanel(h2("Introduction")),
                 # mainPanel(tabPanel("Introduction"))
        ),
        tabPanel('Search you flight',
                 tabName='Search your flight',
                 icon=icon('plane'),
                 sidebarLayout(
                   sidebarPanel(
                
                     selectInput(inputId = "origin",
                                 label  = "Select the origin",
                                 choices = origins,
                                             selected ='JFK (New York, NY)'),
                     selectInput(inputId = "destination",
                                 label  = "Select the destination",
                                 choices = c('all',destinations),
                                 selected ='all'),
                     selectInput(inputId = "month",
                                 label  = "Select the month",
                                 choices = c('Jan','Feb','Mar','Apr','May','Jun','Jul',
                                             'Aug','Sep','Oct','Nov','Dec'),
                                 selected ='Jul'),
                     radioButtons(inputId = "week", 
                                  label = "Select day of the week",
                                  choices = c('all','Monday','Tuesday','Wednesday','Thursday',
                                              'Friday','Saturday','Sunday'), 
                                  selected = 'all'),
                     
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
        # 
        # tabPanel('Delay Time Expectation',
        #          sidebarLayout(
        #            sidebarPanel(
        #              
        #              selectInput(inputId = "destination1",
        #                          label  = "Select the Destination",
        #                          choices = dest_airport,
        #                          selected ='All'),
        #              selectInput(inputId = "origin1",
        #                          label  = "Select the Origin",
        #                          choices = orig_airport,
        #                          selected ='All'),
        #              width = 3
        #            ),
        #            
        #            mainPanel(
        #              box(plotlyOutput("plt_delay_time"),width=300),
        #              box(plotlyOutput("plt_delay_flight_distr"),width=300),
        #              box(plotlyOutput("plt_delay_time_distr"),width=300)
        #              )
        #         )
        # ),
        # 
        # tabPanel('Delay Reason Expectation',
        #          sidebarLayout(
        #            sidebarPanel(
        #              
        #              selectInput(inputId = "destination2",
        #                          label  = "Select the Destination",
        #                          choices = dest_airport,
        #                          selected ='All'),
        #              selectInput(inputId = "origin2",
        #                          label  = "Select the Origin",
        #                          choices = orig_airport,
        #                          selected ='All'),
        #              selectInput(inputId = "month2",
        #                          label  = "Select the Month",
        #                          choices = c('Jan','Feb','Mar','Apr','May','Jun','Jul',
        #                                      'Aug','Sep','Oct','Nov','Dec'),
        #                          selected ='Jan'),
        #              width = 3
        #            ),
        #            
        #            mainPanel(
        #              box(plotlyOutput("plt_delay_reason_distr"),width=300)
        #              )
        #            )
        #          ),
        
        tabPanel('Statistics',
                 tabName='App',
                 icon=icon('bar-chart'),
                 tabsetPanel(type="pill",
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
                             tabPanel('Delay Reason',
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
                                      
                             )
                             
                 )
                 ),
        tabPanel("Carrier Choosing",
                 titlePanel("Satisfication Probability of Carriers"),
                 sidebarLayout(
                   sidebarPanel(
                     selectInput(inputId = "destination",
                                 label  = "Select the destination",
                                 choices = dest_airport,
                                 selected ='ATL (Atlanta, GA)'),
                     selectInput(inputId = "origin",
                                 label  = "Select the origin",
                                 choices = orig_airport,
                                 selected ='AUS (Austin, TX)'),
                     sliderInput(inputId = "mon",
                                 label = "Select the month",
                                 value = 1, min =1, max =12),
                     sliderInput(inputId = "satisfy_time",
                                 label = "Select the limit of delay time (hr)",
                                 value = 1,min = 0,max = 5),
                     
                     width = 3
                   ),
                   
                   mainPanel(
                     plotOutput("treemap",width = "100%", height = 600),
                     absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                   draggable = TRUE, 
                                   top = 600, left = 20, right = "auto", bottom = "auto",
                                   width = 350, height = "auto",
                                   plotOutput("ggplot",width="100%",height="250px")
                     )
                   )
                 )
        ),
        tabPanel('About Us',
                 tabName='About Us',
                 icon=icon('address-card-o'),
                 includeMarkdown('contact.md'))
        )
        )




