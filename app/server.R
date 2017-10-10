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
  
 
})
