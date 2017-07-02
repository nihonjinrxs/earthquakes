# Generate data for package
earthquakes <- eq_clean_data(eq_data())
devtools::use_data(earthquakes)
