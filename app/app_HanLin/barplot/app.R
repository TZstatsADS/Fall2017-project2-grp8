#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(dplyr)
library(ggplot2)
library(reshape2)
library(plotly)
#################

setwd("~/GitHub/Fall2017-project2-grp8/output")


##########################
# combined <- read.csv("0816_0717.csv")

# 
# grp <- combined %>% 
#   group_by(month, carrier, dest, orig) %>%
#   summarise(num_flights = length(month),
#             num_delays = sum(ARR_DELAY > 0),
#             percent_delays = num_delays/num_flights,
#             total_delays = sum(ARR_DELAY),
#             percent_carrier_delay = sum(CARRIER_DELAY)/total_delays*percent_delays,
#             percent_weather_delay = sum(WEATHER_DELAY)/total_delays*percent_delays,
#             percent_NAS_delay = sum(NAS_DELAY)/total_delays*percent_delays,
#             percent_late_aircraft_delay = sum(LATE_AIRCRAFT_DELAY)/total_delays*percent_delays,
#             percent_security_delay = (1-percent_carrier_delay-percent_weather_delay-
#                                         percent_NAS_delay-percent_late_aircraft_delay)*percent_delays
#   ) %>% 
#   as.data.frame()
# 
# write.csv(grp,'grp.csv',row.names = F)

grp <- read.csv('grp.csv',header = T)
dest_names <- unique(grp$dest)
orig_names <- unique(grp$orig)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Delay Percent & Cause Reason"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput('month',
                     label = 'Please select month',
                     choices = month.abb,
                     selected = 'Jul'
                     ),
         selectInput('destination',
                     label='Destination',
                     choices = dest_names,
                     selected = 'LAX (Los Angeles, CA)'
                     ),
         selectInput('origin',
                     label='Origin',
                     choices = orig_names,
                     selected = 'JFK (New York, NY)'
                     )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotlyOutput("stack_barplot")
      )
   )
)


#########################

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$stack_barplot <- renderPlotly({
     
     mm <- grp %>% 
       filter(month==input$month,dest==input$destination,orig==input$origin) %>% 
       select(carrier,percent_carrier_delay,percent_weather_delay,percent_NAS_delay,percent_security_delay,percent_late_aircraft_delay) %>% 
       #rename(c('carrier','Carrier','Weather','NAS','Security','Late_aircraft')) %>% 
       melt(id='carrier')
     #rename(variable = delay_reason)
     
     colnames(mm) <- c('carrier','delay_reason','value')
     
     ggplot(mm, aes(x = carrier, y = value, fill = delay_reason)) + 
       geom_bar(stat = "identity")+
       ylab('delay probability')
     
     
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

