library(tidyverse)
library(sf)
library(leaflet)
library(shiny)

shp = st_read("data/33MUE250GC_SIR.shp")

pal <- colorBin("Blues",domain = NULL,n=5) #cores do mapa
shp$CD_GEOCMU=as.numeric(shp$CD_GEOCMU)
state_popup <- paste0("<strong>Estado: </strong>", 
                      shp$NM_MUNICIP, 
                      "<br><strong>Pontos: </strong>", 
                      shp$CD_GEOCMU)

shinyApp(
   ui = fluidPage(titlePanel("Diamonds Explorer"),leafletOutput('myMap'), ),
   server = function(input, output) {
      
      
      
      map = leaflet(data = shp) %>%
         addProviderTiles("CartoDB.Positron") %>%
         addPolygons(fillColor = ~pal(shp$CD_GEOCMU), 
                     fillOpacity = 0.8, 
                     color = "#BDBDC3", 
                     weight = 1, 
                     popup = state_popup) %>%
         addLegend("bottomright", pal = pal, values = ~shp$CD_GEOCMU,
                   title = "Pontos Conquistados",
                   opacity = 1)
      output$myMap = renderLeaflet(map)
   }
)