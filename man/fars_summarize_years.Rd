% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_summarize_years}
\alias{fars_summarize_years}
\title{fars_summarize_years
counts the accidents in each months of the given year and therefore summarizes fars_read_years function
in grouping the data by month}
\usage{
fars_summarize_years(years)
}
\arguments{
\item{years}{The argument of the funtion is a vector of years}
}
\value{
A tibble: 12 x 2 (data.frame), with number of accidents, sorted by month (numerically)
}
\description{
fars_summarize_years
counts the accidents in each months of the given year and therefore summarizes fars_read_years function
in grouping the data by month
}
\examples{
\donttest{
 library(farsHK)
 fars_summarize_years(2013)
 }
# A tibble: 12 x 2
#   MONTH `2013`
#   <dbl>  <int>
# 1     1   2230
# 2     2   1952
# 3     3   2356
# 4     4   2300
# 5     5   2532
# 6     6   2692
# 7     7   2660
# 8     8   2899
# 9     9   2741
# 10   10   2768
# 11   11   2615
# 12   12   2457
}
