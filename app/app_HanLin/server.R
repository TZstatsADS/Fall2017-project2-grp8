library(shiny)

#grp <- read.csv("../../../output/grp.csv",header = T)

temp <-  read.csv("../../../output/temp.csv",header=T)
raw_data <-  read.csv("../../../output/flight_data.csv")
tree_final1 <- read.csv("../../../output/treemap1.csv",header=TRUE,as.is=TRUE)
airport_location <- read.csv("../../../output/airportlocations.csv")



# temp <- left_join(grp,airport_location,by=c('ORIGIN'='IATA')) %>% 
#   rename(Latitude_orig = Latitude, Longitude_orig = Longitude) %>% 
#   left_join(airport_location,by=c('DEST'='IATA')) %>% 
#   rename(Latitude_dest = Latitude, Longitude_dest = Longitude) %>% 
#   na.omit()




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  output$map <- renderLeaflet({
    
    flight_path(temp,m=input$month,d=input$destination,o=input$origin)
  })
  
  output$delay_barplot <- renderPlotly({
    delay_barplot(temp,m=input$month,d=input$destination,o=input$origin)
  })
   
 
})
