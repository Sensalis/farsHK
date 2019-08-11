#' fars_read
#' The fars_read function is importing data from a csv file
#' Note that in the given data set only years 2013, 2014, and 2015 exist.
#'
#' @param filename The argument/input for the function is a string with the filename
#' @return a tible of all accidents occured in the specific year and the 50 attributes per accident
#' @note If the user does not enter a valid file name, an error message appears saying "file filename does not exist"
#' @examples \dontrun{fars_read("accident_2013.csv.bz2")}
#' # A tibble: 30,202 x 50
#' # The tibble starts with...
#' # STATE ST_CASE VE_TOTAL VE_FORMS PVH_INVL
#' #   <dbl>   <dbl>    <dbl>    <dbl>    <dbl>
#' # 1    1   10001        1        1        0
#'
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#'
#'
#' make_filename
#' creates the file name for the called year
#' @param year The argument of the funtion is a string or an integer with the year
#' @return The function Prints sprintf("accident_%d.csv.bz2", year), hence returns a string
#' @note the argument gets converted into an integer number and will then be used in the name which will be printed.
#' @examples \dontrun{make_filename(2013)} returns "accident_2013.csv.bz2"
#'
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}
#'
#'
#' fars_read_years
#' lists the month and the year for each accident of the year called
#' @param years The argument of the funtion is a vector of years
#' @return returns a tibble (data.frame) of the length (number of accidents) x 2, whereas the columns return the month and the year in which the accident occured.
#' @note Receives name of the file from the make_filename function, and selects months. If there is no data for a specific year, there is an error message saying "invalid year: " with the year printed.
#' @examples
#' \dontrun{fars_read_years(2014)}
#' # [[1]]
#' # A tibble: 30,056 x 2
#' # MONTH  year
#' # <dbl> <dbl>
#' # 1     1  2014
#' # 2     1  2014
#' # 3     1  2014
#' # 4     1  2014
#' # 5     1  2014
#' # 6     1  2014
#' # 7     1  2014
#' # 8     1  2014
#' # 9     1  2014
#' # 10     1  2014
#' # ... with 30,046 more rows
#'
#'
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#'
#'
#' fars_summarize_years
#' counts the accidents in each months of the given year and therefore summarizes fars_read_years function
#' in grouping the data by month
#' @param years The argument of the funtion is a vector of years
#' @return A tibble: 12 x 2 (data.frame), with number of accidents, sorted by month (numerically)
#' @examples \dontrun{fars_summarize_years(2013)}
#'# A tibble: 12 x 2
#'#   MONTH `2013`
#'#   <dbl>  <int>
#'# 1     1   2230
#'# 2     2   1952
#'# 3     3   2356
#'# 4     4   2300
#'# 5     5   2532
#'# 6     6   2692
#'# 7     7   2660
#'# 8     8   2899
#'# 9     9   2741
#'# 10   10   2768
#'# 11   11   2615
#'# 12   12   2457
#'
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
        }

#'
#'
#' fars_map_state
#' The fars_map_state plots the accident locations of the years 2013, 2014,and 2015 per state.
#' The state is called by its number
#' @param year year as a string or an integer
#' @param state.num state number as an integer, number must be between 1 and 51
#' @return returns a plot of accident locations in the state called for the year called.
#' @note Receives data from make_filename and fars_read functions. There are only 51 states in the USA. If a wrong state number is entered an error message will state "invalid STATE number: " with the wrong number printed.
#' If there is no data for a specific year, there is an error message saying "invalid year: " with the year printed.
#' If no accident occurred in the called state and year, the error message "no accidents to plot" appears.
#' Accidents for which the database has no data with regurds to LONGITUD and LATITUDE are placed outside of all potentital plots
#' @examples \dontrun{fars_map_state(51, 2013)} plots the accident locations for state 51 in year 2013.
#' @export

fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
