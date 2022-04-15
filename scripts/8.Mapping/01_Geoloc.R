# 01_Geoloc

# first time, you need to install geonames via devtools
# install.packages("devtools")
# devtools::install_github("ropensci/geonames")

# then set the options to your username in geonames
options(geonamesUsername="your_username")

# load the library
library(geonames)

# search for one place and save result in variable
Verona <- GNsearch(name_equals = "Verona")

# visualize the variable
View(Verona)