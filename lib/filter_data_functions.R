# Function that filters raw data based on origin and destination (both of which can be All)
# It takes as inputs: origin and destination
filter_data = function(raw_data, origin, destination) {

	filtered_data = raw_data

	filtered_data$month = factor(filtered_data$month,
								 levels = month.abb,
								 ordered = T)

	if (origin != 'All') {

		filtered_data = filtered_data %>%
			filter(orig == origin)

	}

	if (destination != 'All') {

		filtered_data = filtered_data %>%
			filter(dest == destination)

	}

	filtered_data = filtered_data %>%
		group_by(month, carrier, delay_bucket) %>%
		summarise(expected_delay = weighted.mean(expected_delay,num_flights),
				  num_delays = sum(num_delays),
				  num_carrier_delay = sum(num_carrier_delay),
				  num_weather_delay = sum(num_weather_delay),
				  num_nas_delay = sum(num_nas_delay),
				  num_security_delay = sum(num_security_delay),
				  num_late_aircraft_delay = sum(num_late_aircraft_delay),
				  num_other_delays = sum(num_other_delays),
				  num_flights = sum(num_flights))

	return(filtered_data)

}