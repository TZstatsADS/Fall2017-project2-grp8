

shinyServer(function(input, output) {
  raw_data = read.csv("../output/flight_data.csv")
  
  filtered_data = reactive({filter_data(raw_data,origin=input$origin,destination=input$destination)})
  
  output$plt_delay_time = renderPlot(plot_delay_time(filtered_data=filtered_data(),origin=input$origin, destination = input$destination))
  output$plt_delay_flight_distr = renderPlot(plot_delayed_flight_distribution(filtered_data=filtered_data(),origin=input$origin, destination = input$destination))
  output$plt_delay_time_distr = renderPlot(plot_delay_time_distribution(filtered_data=filtered_data(),origin=input$origin, destination = input$destination))

})