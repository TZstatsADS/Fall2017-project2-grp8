# Project 2: Open Data App - an RShiny app development project

## Flight Delay Analysis
Term: Fall 2017

+ Team 8
+ **Flight Delay Analysis**
+ **Team members**:
	+ Shiqi Duan
	+ Christina Huang 
	+ Jingkai Li
	+ Peter Li
	+ Han Lin

The app is available here: https://rainofmaster.shinyapps.io/flightAnalysis/

Data Source: [data.gov](https://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time)

+ **Project summary**: Traveling is very stressful and no one wants their flight to be delayed. The purpose of this project is to help customers minimize their flight delay time. We do this by using the last 3 years of flight data to produce statistics and model outputs to aid in travel decision making. The app allows users to specify a certain flight (destination, origin) and flight time (month). Given these, the model can create plots and analysis on expected delay times, delay time distributions, delay reason distributions, and delay probabilities. The app also suggests the carrier based on whichever has the lowest delay probability. Furthermore, the app also allows users to specify a threshold of minutes they will allow the flight to be delayed to determine their satisfaction probability (i.e. probability the user will arrive within their threshold). Further analysis is also provided on cancellations.

+ **Contribution statement**: All team members contributed equally in all stages of this project. All members discussed the framework, collected and cleaned data from data.gov, and designed the app. Christina Huang and Jingkai Li mainly focus on the Dynamic map of Flights 1990vs2010. Han Lin mainly focus on Search Your Flight. Peter Li mainly focus on Delay Time Expectation, and Delay Reason. Shiqi Duan mainly focus on Satisfaction Probability of Carriers and Cancellation Analysis. All team members wrote codes for ui and server for their parts, helped combine them together and deploy the app. All team members approve our work presented in this GitHub repository including this contributions statement. 

+ **Project Demonstration**:

![screenshot](doc/screenshot1.png)

![screenshot](doc/screenshot8.jpg)

![screenshot](doc/screenshot3.png)

![screenshot](doc/screenshot4.png)

![screenshot](doc/screenshot5.png)

![screenshot](doc/screenshot6.png)

![screenshot](doc/screenshot7.png)


Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── app/
├── lib/
├── data/
├── doc/
└── output/
```

Please see each subfolder for a README file.

