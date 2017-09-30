packages.used <- 
  c("leaflet",   # Leaflet for R provides functions to control and integrate Leaflet, a JavaScript library for interactive maps, within R.
    "rgeos",      # Provides functions for handling operations on topologies.
    "raster",     # For raster image
    "DT",         # For creating interactive tables
    "ggplot2",
    "rglwidget",
    "rgl",
    "plyr",
    "reshape2",
    "maptools",
    "shiny",
    "dplyr",
    "plotly",
    "RColorBrewer",
    "treemap",
    "gplots"
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
library("gplots")
library("plyr")
library("dplyr")
library("reshape2")
library("leaflet")
library("rgeos")
library("raster")
library("DT")
library("ggplot2")
#library("rglwidget")
#library("rgl")
#library("maptools")
library("shiny")
library("plotly")
#library("grid")
#library("gtable")
library("treemap")
library("RColorBrewer")
#library(shiny)

#load data
setwd("/Users/duanshiqi/Documents/GitHub/Fall2017-project2-grp8/output")

tree_final1=read.csv("./treemap1.csv",header=TRUE,as.is=TRUE)
airport_names=unique(tree_final1$dest)

# ui.R


ui<-navbarPage(
#shinyUI(fluidPage(
  tabPanel("Carrier Choosing",
           titlePanel("Satisfication Probability of Carriers"),
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId = "destination",
                           label  = "Select the destination",
                           choices = airport_names,
                           selected ='ATL (Atlanta, GA)'),
               selectInput(inputId = "origin",
                           label  = "Select the origin",
                           choices = airport_names,
                           selected ='AUS (Austin, TX)'),
               sliderInput(inputId = "mon",
                           label = "Select the month",
                           value = 1, min =1, max =12),
               sliderInput(inputId = "satisfy_time",
                           label = "Select the limit of delay time (hr)",
                           value = 1,min = 0,max = 5),
               
               width = 3
             ),
             
             mainPanel(
               plotOutput("treemap",width = "100%", height = 600),
               absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, 
                             top = 600, left = 20, right = "auto", bottom = "auto",
                             width = 350, height = "auto",
                             plotOutput("ggplot",width="100%",height="250px")
               )
             )
           )
  )
)