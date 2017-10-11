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
  
  
  output$ui  <- renderUI({
    if(is.null(input$YEAR) || is.na(input$YEAR)){
      print("warning ohahahahaha")
      return()
    }
    if(input$YEAR =="1990"){print("yes")
      tmp <- sliderInput(inputId ="range",
                                label = "Time of data collection:",
                                min = min(flightData1990$FL_DATE),
                                max = max(flightData1990$FL_DATE),
                                value = min(flightData1990$FL_DATE),#The initial value
                                step = days(),
                                animate = animationOptions(interval = 200))
    }else {
      tmp <- sliderInput(inputId ="range",
                                 label = "Time of data collection:",
                                 min = min(flightData2010$FL_DATE),
                                 max = max(flightData2010$FL_DATE),
                                 value = min(flightData2010$FL_DATE),#The initial value
                                 step = days(),
                                 animate = animationOptions(interval = 200))
    }
    print(tmp)
    tmp
    

  })
  output$dynamic_value <- renderPrint({
    str(input$range)
  })
  
  
  # Identify origin and destination
  allPairs <- reactive({
      year <- input$YEAR
      if(is.null(year) || is.na(year)){
        print("warning lalala")
        return()
      }else if(year == "1990"){
        flightData <- flightData1990
      }else{
          flightData <- flightData2010
      }
      print("lalallala")
      print(input$range)
      colfunc <- colorRampPalette(c("blue", "white"))
      tmp <- subset(flightData, FL_DATE == input$range)%>%
                select(ORIGIN_Lon, ORIGIN_Lat, DEST_Lon, DEST_Lat, meanDelay)
      print(tmp)
      tmp$group <- tmp$meanDelay %/% 15
      tmp$group[tmp$group >= 10] <- 10
      tmp$group <- colfunc(10)[tmp$group+1]
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

