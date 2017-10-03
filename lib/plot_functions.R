# Function that plots delay time in minutes by month for various carriers as lines.
# It takes inputs: filtered data, origin of flights (can be All), and destination of flights (can be All)
plot_delay_time = function(filtered_data,origin,destination) {

	title = "Expected Flight Delay Time in Minutes by Carrier and Month for \n"
	if (origin == 'All' & destination == 'All') {

		title = paste0(title, "All Flights within the US")

	} else if (origin == 'All') {

		title = paste0(title, "All Flights to ",destination)

	} else if (destination == 'All') {

		title = paste0(title, "All Flights from ", origin)

	} else {

		title = paste0(title,"Flights from ", destination, " to ",origin)

	}

	plot_data = filtered_data %>%
		group_by(month, carrier) %>%
		summarise(expected_delay = weighted.mean(expected_delay,num_flights))

	p = ggplot(data = plot_data, aes(x = month, y = expected_delay, group = carrier,
									 colour = carrier)) +
		geom_line() +
		geom_point() +
		labs(title = title,
			 x = 'Month',
			 y = 'Expected Delay (min)',
			 colour = 'Carrier') +
		theme(plot.title = element_text(hjust = 0.5))

	return(ggplotly(p))

}

# Function that plots number of delayed flights in each month by carrier (stacked bar plot)
# It takes inputs: filtered data, origin of flights (can be All), and destination of flights (can be All)
plot_delayed_flight_distribution = function(filtered_data,origin,destination) {

	title = "Number of Delayed Flights by Carrier and Month for \n"
	if (origin == 'All' & destination == 'All') {

		title = paste0(title, "All Flights within the US")

	} else if (origin == 'All') {

		title = paste0(title, "All Flights to ",destination)

	} else if (destination == 'All') {

		title = paste0(title, "All Flights from ", origin)

	} else {

		title = paste0(title,"Flights from ", destination, " to ",origin)

	}

	plot_data = filtered_data %>%
		group_by(month, carrier) %>%
		summarise(num_delays = sum(num_delays))

	p = ggplot(data = plot_data, aes(x = month)) +
		geom_bar(stat='identity',aes(fill = carrier, y=num_delays)) +
		labs(title = title,
			 x = 'Month',
			 y = 'Number of Delayed Flights',
			 fill = 'Carrier') +
		theme(plot.title = element_text(hjust = 0.5)) +
		scale_y_continuous(labels = scales::comma_format())

	return(ggplotly(p))

}

# Function that plots distribution delay time buckets for each airline (stacked bar plot)
# It takes inputs: filtered data, origin of flights (can be All), and destination of flights (can be All)
plot_delay_time_distribution = function(filtered_data,origin,destination) {

	title = "Delay Time Distribution in Minutes by Carrier for \n"
	if (origin == 'All' & destination == 'All') {

		title = paste0(title, "All Flights within the US")

	} else if (origin == 'All') {

		title = paste0(title, "All Flights to ",destination)

	} else if (destination == 'All') {

		title = paste0(title, "All Flights from ", origin)

	} else {

		title = paste0(title,"Flights from ", destination, " to ",origin)

	}

	plot_data = filtered_data %>%
		filter(!is.na(delay_bucket)) %>%
		group_by(carrier,delay_bucket) %>%
		summarise(num = sum(num_flights)) %>%
		group_by(carrier) %>%
		mutate(num = num/sum(num))

	plot_data$delay_bucket = factor(plot_data$delay_bucket,
									levels = c('(120,999] min late',
											   '(60,120] min late',
											   '(30,60] min late',
											   '(15,30] min late',
											   '[1,15] min late',
											   'On time',
											   '[1,15) min early',
											   '[15,30) min early',
											   '[30,999) min early'),
									ordered = T)

	p = ggplot(plot_data,aes(carrier)) +
		geom_bar(stat='identity',aes(fill=delay_bucket,y=num)) +
		labs(title = title,
			 x = 'Carrier',
			 y = 'Distribution of Flights',
			 fill = 'Delay Bucket') +
		 scale_y_continuous(labels = scales::percent) +
		theme(plot.title = element_text(hjust = 0.5))

	return(ggplotly(p))

}

plot_delay_reason_distribution = function(filtered_data, origin, destination, month) {
  
	title = "Delay Reason Distribution by Carrier for \n"
	if (origin == 'All' & destination == 'All') {

		title = paste0(title, "All Flights within the US")

	} else if (origin == 'All') {

		title = paste0(title, "All Flights to ",destination)

	} else if (destination == 'All') {

		title = paste0(title, "All Flights from ", origin)

	} else {

		title = paste0(title,"Flights from ", destination, "\n to ",origin)

	}
	
	title = paste0(title," in ",month)
  
	plot_data = filtered_data %>%
	  group_by(carrier) %>%
	  summarise("Carrier Delay" = sum(num_carrier_delay) / sum(num_flights),
	            "Weather Delay" = sum(num_weather_delay) / sum(num_flights),
	            "NAS Delay" = sum(num_nas_delay) / sum(num_flights),
	            "Security Delay" = sum(num_security_delay) / sum(num_flights),
	            "Late Aircraft Delay" = sum(num_late_aircraft_delay) / sum(num_flights),
	            "Other Delay" = sum(num_other_delays) / sum(num_flights))
	
	plot_data = melt(data.frame(plot_data),id.vars = 'carrier')
	plot_data$variable = gsub("\\."," ",plot_data$variable)
	
	p = ggplot(plot_data, aes(x = carrier, y = value, fill = variable)) + 
	  geom_bar(stat = "identity")+
	  labs(title = title,
	       x = 'Carrier',
	       y = 'Delay Probability',
	       fill = 'Delay Reason') +
		scale_y_continuous(labels = scales::percent) +
		theme(plot.title = element_text(hjust = 0.5))

	 return(ggplotly(p))
	
}