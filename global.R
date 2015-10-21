library(shiny)

library(shinydashboard)

library(dplyr)

library(rvest)

library(readr)

# not sure need all these
library(rgdal)    # for readOGR and others
library(sp)       # for spatial objects
library(leaflet)  # for interactive maps (NOT leafletR here)
library(dplyr)    # for working with data frames
library(ggplot2)  # for plotting

library(tigris)
library(acs)
library(stringr) # to pad fips codes

## 
data(fips_codes)
stateChoice <- sort(unique(fips_codes$state_name))


