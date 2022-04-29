# modify_shapefile

# install.packages("sf")

library(sf)

# read shapefile into dataframe
my_shape <- st_read("resources/World_Countries/World_Countries.shp", stringsAsFactors=FALSE)
# see countries included
my_shape$COUNTRY

# select a few countries (e.g. Italy and France)
my_countries <- c("Italy", "France")

# check which is my country
which(my_shape$COUNTRY %in% my_countries)

# reduce to selection
my_shape2 <- my_shape[which(my_shape$COUNTRY %in% my_countries),]
View(my_shape2)

# create new folder where to save
dir.create("resources/My_Countries")

# save there
st_write(my_shape2, "resources/My_Countries/My_Countries.shp")
