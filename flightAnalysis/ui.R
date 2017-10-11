
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
library(ROCR)
library(DT)
library(sparklyr)


source("plot_functions.R")
source("filter_data_functions.R")
source("flight_path_map.R")
source("delay_percent_barplot.R")

flightData1990 <- read.table(file = "1990.csv", as.is = T, header = T,sep = ",")
flightData1990$FL_DATE <- substr(flightData1990$FL_DATE, 6, 10)
flightData1990$FL_DATE <- parse_date_time(flightData1990$FL_DATE, "%m-%d")
flightData1990 <- flightData1990[flightData1990$ORIGIN == c("JFK", "LAX", "SEA", "ATL", "ORD"),]


raw_data = read.csv("flight_data.csv")
dest_airport=c('All',as.character(sort(unique(raw_data$dest))))
orig_airport=c('All',as.character(sort(unique(raw_data$orig))))

temp <-  read.csv("temp.csv",header=T)
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
                              h2('Introduction'),
                              includeMarkdown('intro.md')
                            )
                            # titlePanel(h2("Introduction")),
                            # mainPanel(tabPanel("Introduction"))
                   ),
                   tabPanel("Dynamic Map of Flights 1990 VS 2010",
                            tabName="Dynamic Map",
                            icon=icon("map-o"),
                            
                            sidebarLayout(
                              sidebarPanel(
                                
                                selectInput(
                                  inputId = "YEAR", 
                                  label = "Select 1990 OR 2010",
                                  choices = c("Year 1990", "Year 2010"),
                                  selected = "1990"),
                                helpText("The following timeline are dynamically generated
                                         based on the year you choose."),
                                br(),
                                helpText("Here we select airports from five cities as *ORIGIN AIRPORT* for visualization:"),
                                helpText("New York City - JFK"),
                                helpText("Los Angeles - LAX"),
                                helpText("Seattle - SEA"),
                                helpText("Atlanta - ATL"),
                                helpText("Chicago - ORD"),
                                br(),
                                
                                helpText("The wider/goldener one line is, the larger delay time it has."),
                                helpText("Please click the button below for Dynamic Map view"),
                                sliderInput(inputId ="range",
                                            label = "Time of data collection:",
                                            min = min(flightData1990$FL_DATE),
                                            max = max(flightData1990$FL_DATE),
                                            value = min(flightData1990$FL_DATE),#The initial value
                                            step = days(),
                                            animate = animationOptions(interval = 800))
                                ),
                              
                              # Show a tabset that includes a plot, model, and table view
                              mainPanel(
                                tabPanel("Map", leafletOutput("m_dynamic"))
                              )
                            )
                   ),
                   tabPanel('Search Your Flight',
                            tabName='Search Your Flight',
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
                                box(leafletOutput("map23"),
                                    width=600),
                                box(plotlyOutput("delay_barplot",height='200px'),width=300)
                              )
                              
                            )
                   ),
                   
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
                                                 
                                        ),
                                        tabPanel('Satisfication Probability of Carriers',
                                                 sidebarLayout(
                                                   sidebarPanel(
                                                     
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
                                                                 value = 1,min = 0,max = 5),
                                                     width = 3
                                                   ),
                                                   
                                                   mainPanel(
                                                     box(plotOutput("treemap",width = "100%", height = 600))
                                                   )
                                                 )
                                                 
                                        ),
                                        tabPanel('Cancellation Analysis',
                                                 sidebarLayout(
                                                   sidebarPanel(
                                                     
                                                     selectInput(inputId = "destination4",
                                                                 label  = "Select the destination",
                                                                 choices = dest_airport,
                                                                 selected ='ATL (Atlanta, GA)'),
                                                     selectInput(inputId = "origin4",
                                                                 label  = "Select the origin",
                                                                 choices = orig_airport,
                                                                 selected ='AUS (Austin, TX)'),
                                                     sliderInput(inputId = "mon4",
                                                                 label = "Select the month",
                                                                 value = 1, min =1, max =12),
                                                     width = 3
                                                   ),
                                                   
                                                   mainPanel(
                                                     box(plotlyOutput("hcontainer"),width=600)
                                                   )
                                                 )
                                                 
                                        )
                                        
                            )
                   ),
                   
                   tabPanel('About Us',
                            tabName='About Us',
                            icon=icon('address-card-o'),
                            
                            box(includeMarkdown('contact.md')),
                            box(img(src="thank_you.png",height='300',width='400')))
)
)




