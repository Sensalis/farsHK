## Fatality Analysis
farsHK is an R Package that plots the locations of accidents in the USA. The functions provided in this package are using data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System, which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes.


## fars_map_state Function
The fars_map_state function plots the accident locations of the years 2013, 2014,and 2015 per state.
The state is called by its number
Note that the function receives data from make_filename and fars_read functions.
There are only 51 states in the USA. If a wrong state number is entered an error message will state "invalid STATE number: " with the wrong number printed.
If there is no data for a specific year, there is an error message saying "invalid year: " with the year printed.
If no accident occurred in the called state and year, the error message "no accidents to plot" appears.
Accidents for which the database has no data with regurds to LONGITUD and LATITUDE are placed outside of all potentital plots

E.g. the function fars_map_state(51, 2013) plots the accident locations for state 51 in year 2013.

## Data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System
The data is included in the package for the years 2013, 2014, and 2015, although not in a separat data file as it should be used normally, but on the top level


