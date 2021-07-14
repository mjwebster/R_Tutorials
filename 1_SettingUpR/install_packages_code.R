
# run this code to install all the packages needed for this series of tutorials
#it will only install if it can't find these packages already on your machine



packages <- c("usethis", "tidyverse", "janitor", "readxl", "scales", "lubridate", "ggthemes", "formattable", "tidycensus", "rmarkdown", "knitr", "leaflet",
  "sf", "mapview", "purrr", "htmltools", "kableExtra", "DT", "RCurl", "stats")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())), repos = "http://cran.us.r-project.org")  
}

