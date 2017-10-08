
library(plotly)
library(ggplot2)
delay_barplot <- function(data,m,o,d){
  if(d=='all'){
     df <- filter(data,month==m,orig==o) %>% 
       select(carrier,percent_delays) %>% 
       group_by(carrier) %>% 
       summarise(percent_delays=mean(percent_delays))
  }else{
    df <- filter(data,month==m,orig==o,dest==d) %>% 
      select(carrier,percent_delays)
  }
  
  # mm <- data %>% 
  #   filter(month==m,dest==d,orig==o) %>% 
  #   select(carrier,percent_delays)
  ggplot(df,aes(x=reorder(carrier,percent_delays),y=percent_delays))+
    #geom_text(aes(label=round(percent_delays,2)),  vjust=0.6,size=3.5)+
    geom_bar(stat = 'identity',fill='steelblue3') + 
    xlab('carrier')+
    ylab('delay probability') + 
    #scale_y_continuous(limits = c(0, 1.2*max(df$percent_delays)))+
    #ylim(0,1.2*max(df$percent_delays))+
    #coord_flip()+
    #scale_y_reverse()+
    #scale_x_discrete(position = "top") +
    theme_classic()+
    ggtitle(paste('We recommend taking',df$carrier[which.min(df$percent_delays)],'!'))
  #ggplotly(g)
  
}

#delay_barplot(temp,'Jul','JFK (New York, NY)','all')
#'AUS (Austin, TX)'
