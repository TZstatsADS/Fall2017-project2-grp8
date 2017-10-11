# dynamic map with color on delayed time
library(leaflet)
test<-read.csv("2010.csv")
library(tidyr)
test<- test %>% drop_na()
# define color between "blue" and "white"
colfunc <- colorRampPalette(c("blue", "white"))
colfunc(10)
binnedSamples <- cut( test$meanDelay, breaks = c(-1,60,120,240,300,360,420,480,540,600,10^6) )
for (i in 1:nrow(test[1:500,])){
  if(binnedSamples[i]=="(-1,60]"){
    test$group[i]=colfunc(10)[1]
  } else if(binnedSamples[i]=="(60,120]"){
    test$group[i]=colfunc(10)[2]
  } else if(binnedSamples[i]=="(120,240]"){
    test$group[i]=colfunc(10)[3]
  } else if(binnedSamples[i]=="(240,300]"){
    test$group[i]=colfunc(10)[4]
  } else if(binnedSamples[i]=="(300,360]"){
    test$group[i]=colfunc(10)[5]
  } else if(binnedSamples[i]=="(360,420]"){
    test$group[i]=colfunc(10)[6]
  } else if(binnedSamples[i]=="(420,480]"){
    test$group[i]=colfunc(10)[7]
  } else if(binnedSamples[i]=="(480,540]"){
    test$group[i]=colfunc(10)[8]
  } else if(binnedSamples[i]=="(540,600]"){
    test$group[i]=colfunc(10)[9]
  } else{
    test$group[i]=colfunc(10)[10]
  }
}
# draw dynamic map
leaflet() %>%
  setView(lng = -95.7129, lat = 37.0902, zoom = 4) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.DarkMatter) %>% # # Stamen.TonerLite
  addPolylines(data=gcIntermediate(test[1:220,c("ORIGIN_Lon","ORIGIN_Lat")],
                                   test[10:220,c("DEST_Lon","DEST_Lat")],
                                   n=50,
                                   addStartEnd=TRUE,
                                   sp=TRUE),
               weight=1.5,color = test$group[1:220],
  )
