packages.used <- 
  c(
    "shiny",
    "dplyr",
    "highcharter",
    "magrittr"
  )

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

#load the packages

library("dplyr")
library("shiny")
library("highcharter")
library("magrittr")

#load data
setwd("/Users/duanshiqi/Documents/GitHub/Fall2017-project2-grp8/output")

dest_airport=read.csv("./dest_airport.csv",header=TRUE,as.is=TRUE)[,-1]
orig_airport=read.csv("./orig_airport.csv",header=TRUE,as.is=TRUE)[,-1]

#cancelData=read.csv("./cancelData.csv",header=TRUE,as.is=TRUE)[,-1]

# ui.R


ui<-navbarPage(
  tabPanel('Cancellation Analysis',
           titlePanel("Cancellation Information"),
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId = "destination1",
                           label  = "Select the destination",
                           choices = dest_airport,
                           selected ='ATL (Atlanta, GA)'),
               selectInput(inputId = "origin1",
                           label  = "Select the origin",
                           choices = orig_airport,
                           selected ='AUS (Austin, TX)'),
               sliderInput(inputId = "mon1",
                           label = "Select the month",
                           value = 1, min =1, max =12),
               width=3
             ),
             mainPanel(
               highchartOutput("hcontainer",width="600",height="500")
             )
           )
  )
)