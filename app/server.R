

shinyServer(function(input, output) {
  raw_data = read.csv("../output/flight_data.csv")
  
  filtered_data = reactive({filter_data(raw_data,origin=input$origin,destination=input$destination)})
  
  output$plt_delay_time = renderPlotly(plot_delay_time(filtered_data=filtered_data(),
                                                     origin=input$origin, 
                                                     destination = input$destination))
  output$plt_delay_flight_distr = renderPlotly(plot_delayed_flight_distribution(filtered_data=filtered_data(),
                                                                              origin=input$origin, 
                                                                              destination = input$destination))
  output$plt_delay_time_distr = renderPlotly(plot_delay_time_distribution(filtered_data=filtered_data(),
                                                                        origin=input$origin, 
                                                                        destination = input$destination))

  filtered_data_delay_reason = reactive({filter_data(raw_data,
                                                     origin=input$origin2,
                                                     destination=input$destination2,
                                                     month=input$month)})
  
  output$plt_delay_reason_distr = renderPlotly(plot_delay_reason_distribution(filtered_data=filtered_data_delay_reason(),
                                                                            origin=input$origin2,
                                                                            destination=input$destination2,
                                                                            month=input$month))

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

})