# Project: US Flight Data
### Code lib Folder

The lib directory contains various files with function definitions:
* [clean_data.R](https://github.com/TZstatsADS/Fall2017-project2-grp8/blob/master/lib/clean_data.R): Contains functions for generating cleaned data from raw data

    *   clean_data(data_path, output_file_name): Cleans data given...
        * data_path: path to raw data
        * output_file_name: file name for output (aggregated) data in output directory

    * generate_tree_data(data_path): Generates tree data for tree map given...
        * data_path: path to output (defaults to ../output/)

* [delay_percent_barplot.R](https://github.com/TZstatsADS/Fall2017-project2-grp8/blob/master/lib/delay_percent_barplot.R): 

* [filter_data_functions.R](https://github.com/TZstatsADS/Fall2017-project2-grp8/blob/master/lib/filter_data_functions.R): Contains functions for filtering data for interactive plots

    * filter_data(raw_data, origin, destination, month_filter): Filters data given...
        * raw_data: raw/aggregated data (saved in output directory)
        * origin: origin of flight (can be All)
        * destination: destination of flight (can be All)
        * month_filter: month to filter for (defaults to NA and if not provided it does not filter the month)

* [flight_path_map.R](https://github.com/TZstatsADS/Fall2017-project2-grp8/blob/master/lib/flight_path_map.R): 

* [plot_functions.R](https://github.com/TZstatsADS/Fall2017-project2-grp8/blob/master/lib/plot_functions.R): Contains functions to create statistic plots

    * plot_delay_time(filtered_data, origin, destination): Plots delay time in minutes by month for various carriers as lines given...
        * filtered_data: filtered data from filter_data function
        * origin: origin of flight (can be All)
        * destination: destination of flight (can be All)

    * plot_delayed_flight_distribution(filtered_data, origin, destination): Plots number of delayed flights in each month by carrier (stacked bar plot) given...
        * filtered_data: filtered data from filter_data function
        * origin: origin of flight (can be All)
        * destination: destination of flight (can be All)

    * plot_delay_time_distribution(filtered_data, origin, destination): Plots distribution of delay time buckets for each airline (stacked bar plot) given...
        * filtered_data: filtered data from filter_data function
        * origin: origin of flight (can be All)
        * destination: destination of flight (can be All)

    * plot_delay_reason_distribution(filtered_data, origin, destination, month): Plots distribution of delay reasons for each airline (stacked bar plot) given...
        * filtered_data: filtered data from filter_data function
        * origin: origin of flight (can be All)
        * destination: destination of flight (can be All)
        * month: month of flight (can be All)


