#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(leaflet)
library(geosphere)
library(sparklyr)



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Title
  titlePanel("NYCFlights13 Time Gained in Flight"),
  
  # Create sidebar 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId ="range",
                  label = "Time of data collection:",
                  min = min(flightData$FL_DATE),
                  max = max(flightData$FL_DATE),
                  value = min(flightData$FL_DATE),#The initial value
                  step = 24*3600,
                  animate = animationOptions(interval = 1))
    ),
    # Show a tabset that includes a plot, model, and table view
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Map", leafletOutput("map"))
      )
    )
  )
)
)
