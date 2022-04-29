# 05_Map_creation

# install.packages("leaflet")
# install.packages("sp")
# install.packages("rgdal")

library(leaflet)
library(sp)
library(rgdal)

# Load the shapefile and name it 
countries <- readOGR("resources/My_Countries/My_Countries.shp")

# Read the csv
data <- read.csv("corpora/harrypotter_geonames.csv")

# Prepare the map
map <- leaflet(countries) %>%
  
  # Loading the base map
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  # Add the markers on the locations indicated by the lat & Lng columns with the popups
  addMarkers(data = data,
             lng = ~lng, 
             lat = ~lat,
             popup = ~paste("<b>", text, "</b>" ,"<br>", "<br>",
                            "Mentioned ", "<b>", n, "</b>", " times",
                            sep = " ")) %>%
  
  # Add a polygon layer with label  
  addPolygons(data = countries, 
              color =	"#008000", 
              weight = 1, 
              smoothFactor = 0,
              group = "Countries",
              label = countries$COUNTRY) %>%
  
  # Add legend
  addLegend("topright", 
            colors = c("trasparent"),
            title="Harry Potter mentions map",
            labels=c("by Simone Rebora")) %>%
  
  # Add minimap (optional)
  addMiniMap("bottomleft") %>%
  
  # Add layers control popup
  addLayersControl(overlayGroups = c("Places", "Countries"))

# options on visualisation
options = layersControlOptions(collapsed = TRUE)

# close the map
map

# NOTE: in case visualization does not work properly, export the map as Web Page and open with a browser