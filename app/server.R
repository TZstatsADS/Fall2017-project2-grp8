library(shiny)

temp <-  read.csv("../output/temp.csv",header=T)
raw_data <-  read.csv("../output/flight_data.csv")

shinyServer(function(input, output) {
  
  
  output$map <- renderLeaflet({
    
    flight_path(temp,m=input$month,w=input$week,d=input$destination,o=input$origin)
  })
  
  output$delay_barplot <- renderPlotly({delay_barplot(temp,t=input$type,m=input$month,w=input$week,d=input$destination,o=input$origin)})
   
  filtered_data = reactive({filter_data(raw_data,origin=input$origin1,destination=input$destination1)})
  
  # Create Expected Delay Time by Airline Plot (Statistics section)
  output$plt_delay_time = renderPlotly(plot_delay_time(filtered_data=filtered_data(),
                                                       origin=input$origin1, 
                                                       destination = input$destination1))

  # Create Delayed Flight Distribution (Statistics section)
  output$plt_delay_flight_distr = renderPlotly(plot_delayed_flight_distribution(filtered_data=filtered_data(),
                                                                                origin=input$origin1, 
                                                                                destination = input$destination1))
  
  # Create Delay Time Stacked Barplot (Statistics section)
  output$plt_delay_time_distr = renderPlotly(plot_delay_time_distribution(filtered_data=filtered_data(),
                                                                          origin=input$origin1, 
                                                                          destination = input$destination1))
  
  # Create Delay Reason Stacked Barplot (Statistics section)
  filtered_data_delay_reason = reactive({filter_data(raw_data,
                                                     origin=input$origin2,
                                                     destination=input$destination2,
                                                     month=input$month2)})
  
  output$plt_delay_reason_distr = renderPlotly(plot_delay_reason_distribution(filtered_data=filtered_data_delay_reason(),
                                                                              origin=input$origin2,
                                                                              destination=input$destination2,
<<<<<<< HEAD
                                                                              month=input$month2))
  output$treemap<-renderPlot({
    #selcet a destination, an origin, a month and a satisfied time point
    tree_select=tree_final1%>%
      filter(dest==input$destination,orig==input$origin,month==input$mon,sat_time==input$satisfy_time)
    if(nrow(tree_select)!=0){
      tree_select$label<-paste(tree_select$carrier,", ",round(100*tree_select$prec,2),"%",sep="")
      treemap(tree_select,index='label',vSize="prec",vColor="label",type="categorical", palette=rainbow(7),aspRatio=30/30,drop.unused.levels = FALSE, position.legend="none")
    }
  })
=======
                                                                              month = input$month2))
           
>>>>>>> 1b3edd3f683b4a4e2d75991cd530f4f17a31475f
  
  # Create Tree Map (Delay Probability in Statistics section)
  tree_final1=read.csv("../output/treemap1.csv",header=TRUE,as.is=TRUE)
  
  output$treemap<-renderPlot({
    #selcet a destination, an origin, a month and a satisfied time point
    tree_select=tree_final1%>%
      filter(dest==input$destination3,orig==input$origin3,month==input$mon3,sat_time==input$satisfy_time3)
    if(nrow(tree_select)!=0){
      tree_select$label<-paste(tree_select$carrier,", ",round(100*tree_select$prec,2),"%",sep="")
      treemap(tree_select,index='label',vSize="prec",vColor="label",type="categorical", palette=rainbow(7),aspRatio=30/30,drop.unused.levels = FALSE, position.legend="none")
    }
  })
                                                                             
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
