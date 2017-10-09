
library(plotly)
library(ggplot2)
# data: dataset
# m: month
# w: weekday
# o: origin
# d: destination
delay_percent_barplot <- function(data,m,w,o,d){
  if(d=='all'){
    if(w=='all'){
      df <- filter(data,month==m,orig==o) %>% 
        select(carrier,percent_delays) %>% 
        group_by(carrier) %>% 
        summarise(percent_delays=mean(percent_delays))
    }else{
      df <- filter(data,month==m,orig==o,weekday==w) %>% 
        select(carrier,percent_delays) %>% 
        group_by(carrier) %>% 
        summarise(percent_delays=mean(percent_delays))
    }
     
  }else{
    if(w=='all'){
      df <- filter(data,month==m,orig==o,dest==d) %>% 
        group_by(carrier) %>% 
        summarise(percent_delays = mean(percent_delays)) %>% 
        select(carrier,percent_delays)
    }else{
      df <- filter(data,month==m,orig==o,dest==d,weekday==w) %>% 
        select(carrier,percent_delays)
    }
    
  }
  
  airline_name <- df$carrier[df$percent_delays==min(df$percent_delays)]
  
  # mm <- data %>% 
  #   filter(month==m,dest==d,orig==o) %>% 
  #   select(carrier,percent_delays)
  ggplot(df,aes(x=reorder(carrier,percent_delays),y=percent_delays))+
    #geom_text(aes(label=round(percent_delays,2)),  vjust=0.6,size=3.5)+
    geom_bar(stat = 'identity',fill='steelblue3') + 
    xlab('Airline')+
    ylab('Delay probability') + 
    #scale_y_continuous(limits = c(0, 1.2*max(df$percent_delays)))+
    #ylim(0,1.2*max(df$percent_delays))+
    #coord_flip()+
    #scale_y_reverse()+
    #scale_x_discrete(position = "top") +
    ggtitle(paste('We recommend taking',paste(airline_name,collapse = ' and '),'!'))+
    #df$carrier[which.min(df$percent_delays)]
    theme_classic()+
    theme(plot.title = element_text(size = 20, face = "bold"))
    
  #ggplotly(g)
  
}

delay_time_barplot <- function(data,m,w,o,d){
  if(d=='all'){
    if(w=='all'){
      df <- filter(data,month==m,orig==o) %>% 
        select(carrier,delay_time_ave) %>% 
        group_by(carrier) %>% 
        summarise(delay_time_ave=mean(delay_time_ave))
    }else{
      df <- filter(data,month==m,orig==o,weekday==w) %>% 
        select(carrier,delay_time_ave) %>% 
        group_by(carrier) %>% 
        summarise(delay_time_ave=mean(delay_time_ave))
    }
    
  }else{
    if(w=='all'){
      df <- filter(data,month==m,orig==o,dest==d) %>% 
        group_by(carrier) %>% 
        summarise(delay_time_ave = mean(delay_time_ave)) %>% 
        select(carrier,delay_time_ave)
    }else{
      df <- filter(data,month==m,orig==o,dest==d,weekday==w) %>% 
        select(carrier,delay_time_ave)
    }
    
  }
  
  airline_name <- df$carrier[df$delay_time_ave==min(df$delay_time_ave)]
  
  # mm <- data %>% 
  #   filter(month==m,dest==d,orig==o) %>% 
  #   select(carrier,percent_delays)
  ggplot(df,aes(x=reorder(carrier,delay_time_ave),y=delay_time_ave))+
    #geom_text(aes(label=round(delay_time_ave,2)),  vjust=0.6,size=3.5)+
    geom_bar(stat = 'identity',fill='steelblue3') + 
    xlab('Airline')+
    ylab('Average delay time') + 
    #scale_y_continuous(limits = c(0, 1.2*max(df$delay_time_ave)))+
    #ylim(0,1.2*max(df$delay_time_ave))+
    #coord_flip()+
    #scale_y_reverse()+
    #scale_x_discrete(position = "top") +
    ggtitle(paste('We recommend taking',paste(airline_name,collapse = ' and '),'!'))+
    #df$carrier[which.min(df$delay_time_ave)]
    theme_classic()+
    theme(plot.title = element_text(size = 20, face = "bold"))
  
  #ggplotly(g)
  
}

delay_barplot <- function(data,t,m,w,o,d){
  if(t=='Percent of delay flights'){
    return(delay_percent_barplot(data,m,w,o,d))
  }else{
    return(delay_time_barplot(data,m,w,o,d))
  }
}
  
#delay_time_barplot(data=temp,m='Jul',o='BNA (Nashville, TN)',d='CLT (Charlotte, NC)',w='Friday')
#'AUS (Austin, TX)'
