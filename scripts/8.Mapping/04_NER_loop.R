# 04_NER_loop

options(geonamesUsername="your_username")

library(entity)
library(tidyverse)
library(geonames)

# load Harry Potter tweets
tweets <- read.csv("corpora/tweets_harrypotter.csv", stringsAsFactors = F)
colnames(tweets)

# reduce to English and simplify to just 1,000
tweets <- tweets %>% filter(lang == "en")
tweets <- tweets[1:1000,]

# extract the location entities
result <- location_entity(tweets$text)

# remove the "NULL" entities
result <- result[result != "NULL"]
result

# unlist
result <- unlist(result)
result

# prepare for loop
my_geonames <- data.frame()

# run loop
for(i in 1:length(result)){
  
  result_tmp <- GNsearch(name_equals = result[i])
  result_tmp <- result_tmp[1,]
  if(length(result_tmp > 0))
    result_tmp$text <- result[i]
  my_geonames <- rbind(my_geonames, result_tmp)
  Sys.sleep(0.5)
  print(i)
  
}

# visualize the result
View(my_geonames)

# count entries
my_geonames_count <- my_geonames %>%
  group_by(lat, lng, name, text) %>%
  count()

# save results to a csv
write.csv(my_geonames_count, file = "corpora/harrypotter_geonames.csv")

# eventually: manually clean/correct