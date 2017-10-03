if(!require("readr")) install.packages("readr")
if(!require("dplyr")) install.packages("dplyr")
if(!require("DT")) install.packages("DT")
if(!require("lubridate")) install.packages("lubridate")
if(!require("sp")) install.packages("sp")
if(!require("rgdal")) install.packages("rgdal")
if(!require("shiny")) install.packages("shiny")
library(readr)
library(dplyr)
library(DT)
library(lubridate)
library(sp)
library(rgdal)
library(shiny)

#load data
setwd("/Users/duanshiqi/Documents/GitHub/Fall2017-project2-grp8/output")

tree_final1=read.csv("./treemap1.csv",header=TRUE,as.is=TRUE)


shinyServer(function(input, output) {
  ## Tree Map
  output$treemap<-renderPlot({
    #selcet a destination, an origin, a month and a satisfied time point
    tree_select=tree_final1%>%
      filter(dest==input$destination,orig==input$origin,month==input$mon,sat_time==input$satisfy_time)
    
    tree_select$label<-paste(tree_select$carrier,", ",round(100*tree_select$prec,2),"%",sep="")
    treemap(tree_select,index='label',vSize="prec",vColor="label",type="categorical", palette="RdYlBu",aspRatio=30/30,drop.unused.levels = FALSE, position.legend="none")
    
  })
  ## end Tree Map
})