# 02_Geoloc_loop

# first time, you need to install geonames via devtools
# install.packages("devtools")
# devtools::install_github("ropensci/geonames")

# then set the options to your username in geonames
options(geonamesUsername="your_username")

# load the library
library(geonames)

# read a list of places in the "samples" folder
my_places <- readLines("samples/places.txt")
my_places

# initialize empty dataframe to store results
my_geonames <- data.frame()

# loop on all places, save just the first result
for(i in 1:length(my_places)){
  
  # search the places one by one
  result_tmp <- GNsearch(name_equals = my_places[i])
  # select just first result
  result_tmp <- result_tmp[1,]
  # check if I have a result (I might also get an empty dataframe)
  if(length(result_tmp > 0))
    result_tmp$text <- my_places[i]
  # bind result to dataframe gradually
  my_geonames <- rbind(my_geonames, result_tmp)
  # let the API breath (add pause)
  Sys.sleep(0.5)
  print(i)
  
}

# visualize the result
View(my_geonames)

# save results to a csv
write.csv(my_geonames, file = "samples/my_geonames.csv")
