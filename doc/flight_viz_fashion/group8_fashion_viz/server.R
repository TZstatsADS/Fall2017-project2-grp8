#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Identify origin lat and log
  origin <- reactive({
    
  })
  
  # Identify destination lat and log
  dest <- reactive({
    
  })
  
  # Output the route map  
  output$map <- renderLeaflet({
    gcIntermediate(
      select(origin(), lon, lat),
      select(dest(), lon, lat),
      n=100, addStartEnd=TRUE, sp=TRUE
    ) %>%
      leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolylines()
  })  
})
