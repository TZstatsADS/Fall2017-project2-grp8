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
  
  dataset <- reactive({
    switch(input$YEAR,
           "1990" = flightData1990,
           "2010" = flightData2010
           )
  })

  
  # Identify origin and destination
  allPairs <- reactive({
      year <- input$YEAR
      if(is.null(year) || is.na(year)){
        return()
      }else if(year == "1990"){
        Data <- flightData1990
      }else{
        Data <- flightData2010
      }
      colfunc <- colorRampPalette(c("blue", "white"))
      tmp <- subset(Data, FL_DATE == input$range)%>%
                select(ORIGIN_Lon, ORIGIN_Lat, DEST_Lon, DEST_Lat, meanDelay)
      tmp$group <- tmp$meanDelay %/% 15
      tmp$group[tmp$group >= 10] <- 10
      tmp$group <- colfunc(10)[tmp$group+1]
      print(input$range)
      tmp
  })
    
  
  # Output the route map  
  output$m_dynamic <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      setView(lng = -95.7129, lat = 37.0902, zoom = 4)
  })  
  
  # Output II -- Inorder to avoid the twinkle graph
  observe({
    leafletProxy("m_dynamic") %>%
      clearShapes()%>%
      addPolylines(group = "flights", 
                   data = gcIntermediate(allPairs()[,c("ORIGIN_Lon", "ORIGIN_Lat")], 
                                          allPairs()[,c("DEST_Lon", "DEST_Lat")], 
                                          n=10, addStartEnd=TRUE, sp = TRUE, breakAtDateLine = TRUE),
                   color = allPairs()[,"group"], weight=1)
  })
  
}

