temp<-read.csv("temp.csv")
temp$carrier=as.character(temp$carrier)
  temp$carrier[temp$carrier=="AA"]="American"
  temp$carrier[temp$carrier=="AS"]="Alaska"
  temp$carrier[temp$carrier=="B6"]="jetBlue"
  temp$carrier[temp$carrier=="DL"]="Delta"
  temp$carrier[temp$carrier=="EV"]="EVA"
  temp$carrier[temp$carrier=="F9"]="Frontier"
  temp$carrier[temp$carrier=="HA"]="Hawaiian"
  temp$carrier[temp$carrier=="NK"]="Spirit"
  temp$carrier[temp$carrier=="OO"]="SkyWest"
  temp$carrier[temp$carrier=="UA"]="United"
  temp$carrier[temp$carrier=="VX"]="Virgin America"
  temp$carrier[temp$carrier=="WN"]="Southwest"
table(temp$carrier)
temp$carrier=as.factor(temp$carrier)
write.csv(temp,file="temp.csv")
