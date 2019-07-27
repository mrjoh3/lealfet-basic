
library(readr)
library(tidyverse)
library(dplyr)
library(leaflet)
library(sf)


df <- st_read('lightning.geojson') %>%
  mutate(strength = sample(1:80, size = nrow(.), replace = TRUE),
         time = as.POSIXct("2019-07-28 9:45:00") + sort(sample(1:1000, nrow(.))),
         strength = ifelse(X_leaflet_id == 505, 89, strength))


pal <- colorBin('RdPu', 1:100, bins = 4)

leaflet(df) %>%
  setView(145.283, -37.612, 13) %>%
  addProviderTiles("CartoDB.Positron", group = 'Default') %>%
  addProviderTiles("Esri.WorldImagery", group = 'Aerial') %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = 'Street') %>%
  addScaleBar('bottomleft') %>%
  mapview::addMouseCoordinates() %>%
  addCircleMarkers(radius = ~(strength / 10),
                   fillOpacity = 0.6,
                   popup = ~paste('<b>Time</b>: ', time, '<br><hr>',
                                  '<b>Strength</b>: ', strength, '<br>',
                                  '<b>ID</b>: ', X_leaflet_id),
                   fillColor = ~pal(strength),
                   stroke = F) %>%
  addLayersControl(
    baseGroups = c("Default", "Aerial", "Street"),
    overlayGroups = 'Lightning',
    options = layersControlOptions(collapsed = TRUE)
  ) %>%
  addLegend('bottomright', pal, values= 0:100, title = 'Lightning<br>Severity')

