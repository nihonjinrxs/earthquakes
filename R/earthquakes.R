library(readr)
library(dplyr)

# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

# eq_data
#
# This function reads the NOAA Significant Earthquake Database into
# memory as a data.frame and returns it.
# https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1
# National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database. National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K
eq_data <- function() {
  raw_df <- readr::read_tsv('data-raw/signif.txt')
  return(raw_df)
}

# eq_clean_data
#
# This is a function which cleans a raw earthquake data frame
# by assembling the date and converting the geolocation fields
# to numeric type.
eq_clean_data <- function(raw_df) {
  clean_df <- raw_df %>%
    dplyr::mutate(DATE = as.Date(paste0(YEAR,'-',MONTH,'-',DAY), format="%Y-%m-%d")) %>%
    dplyr::mutate(LATITUDE = as.numeric(LATITUDE), LONGITUDE = as.numeric(LONGITUDE)) %>%
    dplyr::mutate(FLAG_TSUNAMI = as.factor(FLAG_TSUNAMI)) %>%
    eq_clean_location()
  return(clean_df)
}

# eq_clean_location
# TODO: Iterate to get single pattern for each country to clean location_name
eq_clean_location <- function(d) {
  clean_df <- d
  for(i in 1:nrow(clean_df)) {
    row <- clean_df[i,]
    clean_df[i,]$LOCATION_NAME <- gsub("(\\w)(\\w*)", "\\U\\1\\L\\2",
                                       sub(paste0("(",row$COUNTRY,":\\s+)(.*)"),"\\2", row$LOCATION_NAME, perl=TRUE),
                                       perl=TRUE)
  }
  clean_df$LOCATION_NAME <- gsub("(^Nw\\W|^Ne\\W|^Sw\\W|^Se\\W|\\WNw\\W|\\WNe\\W|\\WSw\\W|\\WSe\\W|\\WNw$|\\WNe$|\\WSw$|\\WSe$)",
                                 "\\U\\1", clean_df$LOCATION_NAME, perl=TRUE)
  clean_df$COUNTRY <- as.factor(clean_df$COUNTRY)
  clean_df$STATE <- as.factor(clean_df$STATE)
  return(clean_df)
}
