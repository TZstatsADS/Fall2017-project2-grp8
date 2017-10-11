# Function that cleans data and aggregates it into one csv file
# It takes inputs: path to data (data_path) and desired output filename (output_file_name)
clean_data = function(data_path, output_file_name) {

	files = list.files(path = data_path)

	combined_data = data.frame()

	for(i in 1:length(files)) {
		# read in each month of data
		tmp = read.csv(paste0(data_path,"/",files[i]))

		# create filters (origin, destination, month, carrier, and delay bucket)
		tmp$month = month(tmp$FL_DATE, label = T)
		tmp$ARR_DELAY[which(is.na(tmp$ARR_DELAY))] = 0
		tmp$delay_bucket = cut(x = tmp$ARR_DELAY,
							   breaks = c(-999,-30,-15,-0.001,0,15,30,60,120,999),
							   labels = c('[30,999) min early',
							   			  '[15,30) min early',
							   			  '[1,15) min early',
							   			  'On time',
							   			  '[1,15] min late',
							   			  '(15,30] min late',
							   			  '(30,60] min late',
							   			  '(60,120] min late',
							   			  '(120,999] min late'))
		tmp$dest = paste0(tmp$DEST, " (", tmp$DEST_CITY_NAME,")")
		tmp$orig = paste0(tmp$ORIGIN, " (", tmp$ORIGIN_CITY_NAME,")")
		tmp$carrier = tmp$UNIQUE_CARRIER

		# aggregate month's data
		tmp = tmp %>%
			group_by(month, carrier, dest, orig, delay_bucket) %>%
			summarise(num_flights = length(month),
					  expected_delay = mean(ARR_DELAY),
					  num_delays = sum(ARR_DELAY > 0),
					  num_carrier_delay = sum(CARRIER_DELAY/ARR_DELAY, na.rm=T),
					  num_weather_delay = sum(WEATHER_DELAY/ARR_DELAY, na.rm=T),
					  num_nas_delay = sum(NAS_DELAY/ARR_DELAY, na.rm=T),
					  num_security_delay = sum(SECURITY_DELAY/ARR_DELAY, na.rm=T),
					  num_late_aircraft_delay = sum(LATE_AIRCRAFT_DELAY/ARR_DELAY, na.rm=T)) %>%
			transform(num_other_delays = num_delays - num_carrier_delay 
						- num_weather_delay - num_nas_delay - num_security_delay 
						- num_late_aircraft_delay)

		# rbind monthly data into one data frame
		combined_data = rbind(combined_data,tmp)

	}

	combined_data = combined_data %>% 
				  group_by(month, carrier, dest, orig, delay_bucket) %>%
				  summarise(expected_delay = weighted.mean(expected_delay,num_flights),
							  num_delays = sum(num_delays),
							  num_carrier_delay = sum(num_carrier_delay),
							  num_weather_delay = sum(num_weather_delay),
							  num_nas_delay = sum(num_nas_delay),
							  num_security_delay = sum(num_security_delay),
							  num_late_aircraft_delay = sum(num_late_aircraft_delay),
							  num_other_delays = sum(num_other_delays),
							  num_flights = sum(num_flights))

	# save aggregated data as csv
	write.csv(combined_data,paste0("../output/",output_file_name,".csv"))

}

generate_tree_data = function(data_path = "../output/") {
  
  tree_data<-read.csv(paste0(data_path,"flight_data.csv"),header=TRUE,as.is=TRUE)
  
  tree0=
    tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    filter(expected_delay<=0)%>%
    summarise(num_ontime=sum(num_flights))
  
  tree0$sat_time<-rep(0,nrow(tree0))
  
  tree1=tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    filter(expected_delay<=60)%>%
    summarise(num_ontime=sum(num_flights))
  
  tree1$sat_time<-rep(1,nrow(tree1))
  
  tree2=tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    filter(expected_delay<=120)%>%
    summarise(num_ontime=sum(num_flights))
  
  tree2$sat_time<-rep(2,nrow(tree2))
  
  tree3=tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    filter(expected_delay<=180)%>%
    summarise(num_ontime=sum(num_flights))
  
  tree3$sat_time<-rep(3,nrow(tree3))
  
  tree4=tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    filter(expected_delay<=240)%>%
    summarise(num_ontime=sum(num_flights))
  
  tree4$sat_time<-rep(4,nrow(tree4))
  
  
  tree5=tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    filter(expected_delay<=300)%>%
    summarise(num_ontime=sum(num_flights))
  
  tree5$sat_time<-rep(5,nrow(tree5)) 
  
  tree_ontime<-rbind(tree0,tree1,tree2,tree3,tree4,tree5)
  
  tree_flights=tree_data%>%
    group_by(dest,orig,month,carrier)%>%
    summarise(total_num=sum(num_flights))
  
  tree_final=merge(tree_ontime,tree_flights,by.x=c("dest","orig","month","carrier"),by.y=c("dest","orig","month","carrier"))
  tree_final$prec=tree_final$num_ontime/tree_final$total_num
  
  tree_final1=tree_final[,c(1,2,3,4,6,8)]
  mo2Num <- function(x) match(tolower(x), tolower(month.abb))
  tree_final1$month=mo2Num(tree_final1$month)
  
  write.csv(tree_final1,paste0(data_path,"treemap1.csv"))
  
}

