# Load Packages
library(ggplot2)
library(zoo)
library(lubridate)
library(dplyr)

# Clean Raw Data
source("clean_data.R")
clean_data(data_path="../data/flight_data/",output_file_name="flight_data")

# Filter Raw Data -- I am using "All" as default example here
source("filter_data_functions.R")

raw_data = read.csv("../output/flight_data.csv")
filtered_data = filter_data(raw_data,"All","All")

# Plot functions
source("plot_functions.R")

plot_delay_time(filtered_data = filtered_data,
				origin = "All",
				destination = "All")

plot_delayed_flight_distribution(filtered_data = filtered_data,
								 origin = "All",
								 destination = "All")

plot_delay_time_distribution(filtered_data = filtered_data,
							 origin = "All",
							 destination = "All")