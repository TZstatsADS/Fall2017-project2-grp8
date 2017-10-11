
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
        choices = c("1990", "2010"),
        selected = "1990"),
      
      uiOutput("ui"),
      
      tags$p("Dynamic input value:"),
      verbatimTextOutput("dynamic_value")

    ),

  # Show a tabset that includes a plot, model, and table view
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Map", leafletOutput("m_dynamic"))
      )
    )
  )
)



