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
shinyServer <- function(input, output) {
  
  # Identify origin and destination
  flightLines <- reactive({
    
    allPairs <- subset(flightData, FL_DATE == input$range)%>%
      select(ORIGIN_Lon, ORIGIN_Lat, DEST_Lon, DEST_Lat)
    
    
    inters <- character(0)
    
    gcIntermediate(allPairs[,c("ORIGIN_Lon", "ORIGIN_Lat")], 
                   allPairs[,c("DEST_Lon", "DEST_Lat")], 
                    n=10, addStartEnd=TRUE, sp = TRUE, breakAtDateLine = TRUE)

    #for(i in 1:nrow(allPairs)){
    #  inter <- gcIntermediate(airportLocation[allPairs[i,1],], 
    #                          airportLocation[allPairs[i,2],],
    #                          n=10, addStartEnd=TRUE, sp = TRUE, breakAtDateLine = TRUE)
    #  inters <- c(inters, inter)
    #}
    #ll0 <- lapply( inters , function(x) `@`(x , "lines") )
    #ll1 <- lapply( unlist( ll0 ) , function(y) `@`(y,"Lines") )
    #SpatialLines( list( Lines( unlist( ll1 ) , ID = 1) ) )
  })
  

  
  # Output the route map  
  output$m_dynamic <- renderLeaflet({
    leaflet() %>% 
      #clearShapes()%>%
      addTiles() %>% 
      #addPolylines(flightLines(), color = 'blue', weight=0.1) %>%
      setView(lng = -95.7129, lat = 37.0902, zoom = 4)
  })  
  
  observe({
    leafletProxy("m_dynamic") %>%
      clearShapes()%>%
      addPolylines(group = "flights", data = flightLines(),
                   color = factor(flightData$meanDelay), weight=1)
  })
  
}

