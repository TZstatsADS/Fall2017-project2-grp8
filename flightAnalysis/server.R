library(shiny)
options(shiny.sanitize.errors = FALSE)

temp <-  read.csv("temp.csv",header=T)
raw_data <-  read.csv("flight_data.csv")
cancelData=read.csv("cancelData.csv",header=TRUE,as.is=TRUE)

flightData1990 <- read.table(file = "1990.csv", as.is = T, header = T,sep = ",")
flightData1990$FL_DATE <- substr(flightData1990$FL_DATE, 6, 10)
flightData1990$FL_DATE <- parse_date_time(flightData1990$FL_DATE, "%m-%d")
flightData1990 <- flightData1990[flightData1990$ORIGIN == c("JFK", "LAX", "SEA", "ATL", "ORD"),]

flightData2010 <- read.table(file = "2010.csv", as.is = T, header = T,sep = ",")
flightData2010$FL_DATE <- substr(flightData2010$FL_DATE, 6, 10)
flightData2010$FL_DATE <- parse_date_time(flightData2010$FL_DATE, "%m-%d")
flightData2010 <- flightData2010[flightData2010$ORIGIN == c("JFK", "LAX", "SEA", "ATL", "ORD"),]


shinyServer(function(input, output) {
  
  
  output$map23 <- renderLeaflet({
    
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
                                                                              month = input$month2))
  
  # Create Tree Map (Delay Probability in Statistics section)
  tree_final1=read.csv("treemap1.csv",header=TRUE,as.is=TRUE)
  
  output$treemap<-renderPlot({
    #selcet a destination, an origin, a month and a satisfied time point
    tree_select=tree_final1%>%
      filter(dest==input$destination3,orig==input$origin3,month==input$mon3,sat_time==input$satisfy_time3)
    if(nrow(tree_select)!=0){
      tree_select$label<-paste(tree_select$carrier,", ",round(100*tree_select$prec,2),"%",sep="")
      treemap(tree_select,index='label',vSize="prec",vColor="label",type="categorical", palette=rainbow(7),aspRatio=30/30,drop.unused.levels = FALSE, position.legend="none")
    }
  })
  
  output$hcontainer<-renderPlotly({
    select_data=cancelData%>%
      filter(dest==input$destination4,orig==input$origin4,month==input$mon4)
    if(nrow(select_data)!=0){
      ggplotly(ggplot(select_data, aes(x = total, y = num_cancel, label = carrier)) +
                 geom_point(aes(size = rate/100, colour = carrier, alpha=.02)) + 
                 geom_text(hjust = 1, size = 2) +
                 scale_size(range = c(1,5)) +
                 theme_bw())
      
    }})
  
  #========== DINAMIC MAP PART ==========                                                                                                                                               month=input$month2))
  # Identify origin and destination
  allPairs <- reactive({
    year <- input$YEAR
    if(is.null(year) || is.na(year)){
      return()
    }else if(year == "Year 1990"){
      Data <- flightData1990
    }else{
      Data <- flightData2010
    }
    colfunc <- colorRampPalette(c("white", "gold"))
    tmp <- subset(Data, FL_DATE == input$range)%>%
      select(ORIGIN_Lon, ORIGIN_Lat, DEST_Lon, DEST_Lat, meanDelay)
    tmp$group <- tmp$meanDelay %/% 15
    tmp$group[tmp$group >= 10] <- 10
    tmp$wid <- 0.3 * (tmp$meanDelay %/% 15) + 0.5
    tmp$group <- colfunc(10)[tmp$group+1]
    
    tmp
  })
  
  
  # Output the route map  
  output$m_dynamic <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addProviderTiles("CartoDB.DarkMatter") %>%
      setView(lng = -116.7129, lat = 46.0902, zoom = 3)
  })  
  
  # Output II -- Inorder to avoid the twinkle graph
  observe({
    leafletProxy("m_dynamic") %>%
      clearShapes()%>%
      addPolylines(group = "flights", 
                   data = gcIntermediate(allPairs()[,c("ORIGIN_Lon", "ORIGIN_Lat")], 
                                         allPairs()[,c("DEST_Lon", "DEST_Lat")], 
                                         n=10, addStartEnd=TRUE, sp = TRUE, breakAtDateLine = TRUE),
                   color = allPairs()[,"group"], weight=allPairs()[,"wid"])
  })
  
})
