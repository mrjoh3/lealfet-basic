
library(readr)
library(tidyverse)
library(dplyr)
library(leaflet)

nsw <- read_csv('data/nsw-public-schools-master-dataset-07032017.csv') %>% select(School_Name = school_name, latitude, longitude)
vic <- read_csv('data/dv244-allschoolslist2017.csv') %>% select(School_Name, latitude = Y, longitude = X)

n <- 150

schools <- plyr::ldply(list(nsw, vic)) %>%
  sample_n(size = n) 

schools$PM25 <- c(sample(1:25, 120, replace = TRUE), 
                  sample(25:37, 20, replace = TRUE),
                  sample(37:50, 10, replace = TRUE))



pal <- colorBin('YlGnBu', 1:50, c(0,8,16,25,37,51))

leaflet(schools) %>%
  addProviderTiles("CartoDB.Positron", group = 'Default') %>%
  addProviderTiles("Esri.WorldImagery", group = 'Aerial') %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = 'Street') %>%
  addScaleBar('bottomleft') %>%
  addCircleMarkers(radius = ~(PM25 / 4) + 5,
                   fillOpacity = 0.6,
                   popup = ~paste('<b>', School_Name, '</b><br><hr>',
                                  '<b>PM2.5</b>:', PM25),
                   fillColor = ~pal(PM25),
                   stroke = F) %>%
  addLayersControl(
    baseGroups = c("Default", "Aerial", "Street"),
    overlayGroups = 'Schools',
    options = layersControlOptions(collapsed = TRUE)
  ) %>%
  addLegend('bottomright', pal, values= 0:50)

