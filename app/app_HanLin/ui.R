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
    "plotly"
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



#source("../../../lib/plot_functions.R")
#source("../../../lib/filter_data_functions.R")
source("../../../lib/flight_path_map.R")
source("../../../lib/delay_percent_barplot.R")


temp <-  read.csv("../../../output/temp.csv",header=T)
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
                 # absolutePanel(
                 #   fixed=TRUE,draggable=FALSE,
                 #   top=20,left=10,right='auto',bottom='auto',
                 #   width=330,height="auto",
                
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
                     
                     
                       
                     # absolutePanel(fixed=TRUE,draggable=FALSE,
                     #               top='50',left="auto",right=20,bottom="auto",
                     #               width='330',height="600",
                     #               h4("Different Carriers"),
                     #               h4('bb:liajsldi'),
                     #               h4('bb:liajsldi'),
                     #               h4("Different Carriers"),
                     #               h4("Different Carriers"),
                     #               class = "panel panel-default",
                     #               style="opacity:0.8"
                     #               )
                                   
                     
                   )
                 ),
        
        
        tabPanel('Statistics'),
        tabPanel('About Us',
                 includeMarkdown('contact.md'))
)
)





# 
# ui <- dashboardPage(
#   ########## Header ##########
#   dashboardHeader(title ='Flight Delay'),
#   ########### Sidebar ###########
#   dashboardSidebar(
#     sidebarMenu(
#       menuItem("Introduction", tabName = "Introduction"),
#       menuItem("Content", tabName = "Content"),
#       menuItem("Statistics", tabName = "Statistics"),
#       menuItem("About us", tabName = "About us")
#     )
#   ),
# 
#   ########## Body ##########
#   dashboardBody(
#     tabItems(
#       tabItem(tabName = "Introduction",
#               h2("This is introduction")
#               ),
# 
#       tabItem(tabName = "Content",
#               h2("This is content"),
#               box(
                # selectInput(inputId = "destination",
                #             label  = "Select the Destination",
                #             choices = as.character(sort(unique(grp$dest))),
                #             selected ='LAX (Los Angeles, CA)'),
                # selectInput(inputId = "origin",
                #             label  = "Select the Origin",
                #             choices = as.character(sort(unique(grp$orig))),
                #             selected ='JFK (New York, NY)'),
                # selectInput(inputId = "month",
                #             label  = "Select the Month",
                #             choices = c('Jan','Feb','Mar','Apr','May','Jun','Jul',
                #                         'Aug','Sep','Oct','Nov','Dec'),
                #             selected ='Jul'),
#                 width=4),
#               box(leafletOutput("map"),width=8)
#               
#               ),
#       
#       
#       
#       tabItem(tabName = "Statistics",
#               h2("This is statistics")
#               ),
# 
#       tabItem(tabName = "About us",
#               h2("This is about us")
#               )
#       )
# 
# 
#   )
# 
# 
# 
# )
# 

