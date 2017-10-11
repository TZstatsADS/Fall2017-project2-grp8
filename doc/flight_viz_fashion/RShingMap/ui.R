
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
shinyUI <- fluidPage(
  
  # Title
  titlePanel("NYCFlights13 Time Gained in Flight"),
  
  # Create sidebar 
  sidebarLayout(
    sidebarPanel(
      
      selectInput(
        inputId = "YEAR", 
        label = "Select 1990 OR 2010",
        choices = c("Year 1990", "Year 2010"),
        selected = "1990"),
      helpText("The following selectInput frop down choices are dynamically populated based on the year you choose"),
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
)



