library(tidyverse)

# read the csv into a dataframe
my_df <- read.csv("corpora/harrypotter_tweets.csv", stringsAsFactors = F)

# explore the dataframe
View(my_df)

# see all available metadata
colnames(my_df)

# count tweets per language
my_df %>% count(lang)

# filter by language
ita_df <- my_df %>% filter(lang == "it")

# count tweets per username
my_df %>% count(author.username, sort = T)

# filter by username
user_df <- my_df %>% filter(author.username == "HarryPotterEnth")

# etc. etc.