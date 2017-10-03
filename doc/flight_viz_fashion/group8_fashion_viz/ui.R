#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Set display mode to bottom
  tags$script(' var setInitialCodePosition = function() 
              { setCodePosition(false, false); }; '),
  
  # Title
  titlePanel("NYCFlights13 Time Gained in Flight"),
  
  # Create sidebar 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId ="range",
                  label = "Time of data collection:",
                  min = min(July2016_rain$time),
                  max = max(July2016_rain$time),
                  value = min(July2016_rain$time),#The initial value
                  step = 7200)
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
