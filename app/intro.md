The purpose of this app is to aid customers in choosing a flight based on various crtieria, mostly relating to delay time expecations. We offer the following services given flight information (destination, origin, flight time, carrier):
* Dynamic Map of Flights 1990 vs 2010
* Search your flight: flight carrier suggestion based on desired flight (destination, origin, flight time)
	* Dynamic Map of potential flights given inputs
	* Carrier recommendation based on delay probability
* Statistics:
	* Delay Time Expectation:
		* Expected Flight Delay Time in Minutes: shows expected number of minutes you can expect a given flight to be delayed for a given carrier in a given month
		* Number of Delayed Flights: shows the number of delayed flights a given carrier had in each month (sense of scale)
		* Delay Time Distribution: shows distribution of delay time for a given flight by carrier
	* Delay Reason:
		* Delay Reason Distribution: shows distribution of delay reasons for a given flight and month by carrier
	* Satisfaction Probability of Carriers:
		* Tree map showing satisfaction probability for a given flight, month, and delay threshold by carrier (i.e. probability a given flight/month/carrier will arrive within your delay threshold)
	* Cancellation:
		* The scatter plot displays cancellation information on the airlines between the selected origin and destination in the selected month, where X-axis represents total number of flights in the past 3 years (201408-201707) for each carrier, Y-axis represents the total number of cancelled flights for each carrier(we use 0.001 to replace 0), and the size of the scatter points represents the non-cancellation rate for each carrier. So in this plot, when the size of the point is small, the flights of that carrier are more likely to have cancellations. Customers should prefer the carrier whose scatter point has larger x-value, lower y-value, and larger size.
