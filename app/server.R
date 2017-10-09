library(shiny)

temp <-  read.csv("../output/temp.csv",header=T)
raw_data <-  read.csv("../output/flight_data.csv")
tree_final1 <- read.csv("../output/treemap1.csv",header=TRUE,as.is=TRUE)
#airport_location <- read.csv("../output/airportlocations.csv")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  output$map <- renderLeaflet({
    
    flight_path(temp,m=input$month,w=input$week,d=input$destination,o=input$origin)
  })
  
  # if(input$type=='Percent of delay flights'){
  #   output$delay_barplot <- renderPlotly({
  #     delay_percent_barplot(temp,m=input$month,w=input$week,d=input$destination,o=input$origin)
  #   })
  # }else{
  #   output$delay_barplot <- renderPlotly({
  #     delay_time_barplot(temp,m=input$month,w=input$week,d=input$destination,o=input$origin)
  #   })
  # }
  
  #if(nrow(temp %>% filter(m=input$month,w=input$week,d=input$destination,o=input$origin)))
  output$delay_barplot <- renderPlotly({delay_barplot(temp,t=input$type,m=input$month,w=input$week,d=input$destination,o=input$origin)})
   
  filtered_data = reactive({filter_data(raw_data,origin=input$origin1,destination=input$destination1)})
  
  output$plt_delay_time = renderPlotly(plot_delay_time(filtered_data=filtered_data(),
                                                       origin=input$origin1, 
                                                       destination = input$destination1))
  output$plt_delay_flight_distr = renderPlotly(plot_delayed_flight_distribution(filtered_data=filtered_data(),
                                                                                origin=input$origin1, 
                                                                                destination = input$destination1))
  output$plt_delay_time_distr = renderPlotly(plot_delay_time_distribution(filtered_data=filtered_data(),
                                                                          origin=input$origin1, 
                                                                          destination = input$destination1))
  
  filtered_data_delay_reason = reactive({filter_data(raw_data,
                                                     origin=input$origin2,
                                                     destination=input$destination2,
                                                     month=input$month2)})
  
  output$plt_delay_reason_distr = renderPlotly(plot_delay_reason_distribution(filtered_data=filtered_data_delay_reason(),
                                                                              origin=input$origin2,
                                                                              destination=input$destination2,
                                                                              month = input$month2))
           
                                                                              
  #========== DINAMIC MAP PART ==========                                                                                                                                               month=input$month2))
  # Identify origin and destination
  allPairs <- reactive({
    subset(flightData, FL_DATE == input$range)%>%
      select(ORIGIN_Lon, ORIGIN_Lat, DEST_Lon, DEST_Lat, meanDelay)
  })
  
  flightLines <- reactive({
    gcIntermediate(allPairs()[,c("ORIGIN_Lon", "ORIGIN_Lat")], 
                   allPairs()[,c("DEST_Lon", "DEST_Lat")], 
                   n=10, addStartEnd=TRUE, sp = TRUE, breakAtDateLine = TRUE)
    
    #inters <- character(0)
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
      addTiles() %>% 
      setView(lng = -95.7129, lat = 37.0902, zoom = 4)
  })  
  
  observe({
    leafletProxy("m_dynamic") %>%
      clearShapes()%>%
      addPolylines(group = "flights", data = flightLines(),
                   color = "blue", weight=1)
  })
 
})
