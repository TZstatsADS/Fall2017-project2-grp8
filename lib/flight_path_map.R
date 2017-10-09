

# flight_path <- function(data,m,o,d){
#   if(d=='all'){
#     df <- filter(data,month==m,orig==o)
#   }
#   else{
#     df <- filter(data,month==m,orig==o,dest==d)
#   }
#   
#   gcIntermediate(df[,c("Longitude_orig","Latitude_orig")],
#                  df[,c("Longitude_dest","Latitude_dest")],
#                  n=50, 
#                  addStartEnd=TRUE,
#                  sp=TRUE) %>% 
#     leaflet() %>% 
#     setView(lng = -95.7129, lat = 37.0902, zoom = 4) %>%
#     addTiles() %>% 
#     addProviderTiles(providers$Stamen.TonerLite) %>% 
#     addPolylines(weight=2,color = 'orange')
#                     
#     
#     #%>% 
#     #addMarkers(data=df[,c("Longitude_orig","Latitude_orig")],
#                #lng = ~Longitude_orig, lat = ~Latitude_orig)
#     
# }




flight_path <- function(data,m,w,o,d){
  if(d=='all'){
    if(w=='all'){
      df <- filter(data,month==m,orig==o)
    }else{
      df <- filter(data,month==m,weekday==w,orig==o)
    }
    
   
    
    leaflet() %>%
      setView(lng = -95.7129, lat = 37.0902, zoom = 4) %>%
      addTiles() %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%   # # Stamen.TonerLite
      addPolylines(data=gcIntermediate(df[,c("Longitude_orig","Latitude_orig")],
                                       df[,c("Longitude_dest","Latitude_dest")],
                                       n=50,
                                       addStartEnd=TRUE,
                                       sp=TRUE),
                   weight=1.5,color = 'white',
                   popup= as.character(mean(df$percent_delays))) %>%
      
      addMarkers(df[,"Longitude_orig"],df[,"Latitude_orig"],
                 icon=list(iconUrl='./icon/plane_2.png',iconSize=c(20,20)),
                 popup = df[,'orig']) %>% 
      addMarkers(df[,"Longitude_dest"],df[,"Latitude_dest"],
                 icon=list(iconUrl='./icon/plane_2.png',iconSize=c(20,20)),
                 popup = df[,'dest'])
     
      
   
  }
  else{
    if(w=='all'){
      df <- filter(data,month==m,orig==o)
      mark <- filter(data,month==m,orig==o,dest==d)
    }else{
      df <- filter(data,month==m,weekday==w,orig==o)
      mark <- filter(data,month==m,weekday==w,orig==o,dest==d)
    }
    
    
  


    leaflet() %>%
    setView(lng = -95.7129, lat = 37.0902, zoom = 4) %>%
    addTiles() %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%   # # Stamen.TonerLite
    addPolylines(data=gcIntermediate(df[,c("Longitude_orig","Latitude_orig")],
                                     df[,c("Longitude_dest","Latitude_dest")],
                                     n=50,
                                     addStartEnd=TRUE,
                                     sp=TRUE),
                 weight=1.5,color = 'white',
                 popup= as.character(mean(df$percent_delays))) %>%
      addPolylines(data=gcIntermediate(mark[,c("Longitude_orig","Latitude_orig")],
                                       mark[,c("Longitude_dest","Latitude_dest")],
                                       n=50,
                                       addStartEnd=TRUE,
                                       sp=TRUE),
                   weight=3,color = 'red',
                   popup= as.character(mean(df$percent_delays))) %>% 
                   
      addMarkers(df[,"Longitude_orig"],df[,"Latitude_orig"],
                 icon=list(iconUrl='./icon/plane_2.png',iconSize=c(20,20)),
                 popup = df[,'orig']) %>% 
      addMarkers(df[,"Longitude_dest"],df[,"Latitude_dest"],
                 icon=list(iconUrl='./icon/plane_2.png',iconSize=c(20,20)),
                 popup = df[,'dest'])
    
      
  #lng = ~Longitude_orig, lat = ~Latitude_orig)
}
    
}

#, popup = ~as.character(orig), label = ~as.character(orig)

#flight_path(temp,'Jul','JFK (New York, NY)','LAX (Los Angeles, CA)')

# 'LAX (Los Angeles, CA)'
# 
# x <- seq(0,1,0.1)
# plot(x,x,col=cc)
# 
# cc <- color.scale(x,cs1=c(0,1),cs2=c(0,1),cs3=c(0,1),alpha=1,
#             extremes=NA,na.color=NA,xrange=NULL,color.spec="rgb")
# cc
# 
# cc <- heat.colors(11, alpha = 1)
# 
# colfunc <- colorRampPalette(c("white","red"))
# colfunc(10)
# plot(rep(1,10),col=colorRampPalette(c("white","red"))(10),pch=19,cex=3)




