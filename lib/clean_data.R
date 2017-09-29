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

