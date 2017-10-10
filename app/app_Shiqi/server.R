#if(!require("readr")) install.packages("readr")
if(!require("dplyr")) install.packages("dplyr")
#if(!require("DT")) install.packages("DT")
#if(!require("lubridate")) install.packages("lubridate")
#if(!require("sp")) install.packages("sp")
#if(!require("rgdal")) install.packages("rgdal")
if(!require("shiny")) install.packages("shiny")
if(!require("magrittr")) install.packages("magrittr")
if(!require("highcharter")) install.packages("highcharter")


#library(readr)
library(dplyr)
#library(DT)
#library(lubridate)
#library(sp)
#library(rgdal)
library(shiny)
library(magrittr)
library(highcharter)

#load data
setwd("/Users/duanshiqi/Documents/GitHub/Fall2017-project2-grp8/output")

cancelData=read.csv("./cancelData.csv",header=TRUE,as.is=TRUE)


shinyServer(function(input, output) {
  
  ## HighChart
  
  output$hcontainer<-renderHighchart({
    select_data=cancelData%>%
      filter(dest==input$destination1,orig==input$origin1,month==input$mon1)
    if(nrow(select_data)!=0){
      highchart() %>%
        hc_title(text="Flight Cancellation Information") %>%
        hc_add_series_scatter(select_data$total,select_data$num_cancel,select_data$rate/100,select_data$carrier,label=select_data$carrier)%>%
        hc_xAxis(title=list(text="number of flights"))%>%
        hc_yAxis(title=list(text="number of cancelled flights"))
    }
  })
  ## end HighChart
})
