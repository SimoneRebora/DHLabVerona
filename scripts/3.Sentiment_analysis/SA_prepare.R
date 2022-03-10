# SA_prepare_corpora

# install and load package for language recognition
install.packages("cld2")
library(cld2)

install.packages("tidyverse")
library(tidyverse)

# 1. Goodreads

# find all files' addresses
all_goodreads_files <- list.files(path = "corpora", pattern = "Goodreads_", full.names = T)

# read the first file to prepare the dataframe
my_df <- read.csv(all_goodreads_files[1], row.names = 1, stringsAsFactors = F)

# get just text and book
my_df <- my_df[,c("book", "review")]

# iterate on the other files (if there are...)
if(length(all_goodreads_files) > 1){
  
  for(i in 2:length(all_goodreads_files)){
    
    # read datasets one by one
    my_tmp_df <- read.csv(all_goodreads_files[i], row.names = 1, stringsAsFactors = F)
    my_tmp_df <- my_tmp_df[,c("book", "review")]
    
    # concatenate
    my_df <- rbind(my_df, my_tmp_df)
    
  }
  
}

# exclude the "NA" reviews (probably due to errors in the scraping)
my_df <- my_df[!is.na(my_df$review),]

# add language (because - at the moment - we need to focus just on English)
my_df$language <- sapply(my_df$review, function(x) detect_language(text = x))

# some stats
my_df %>% count(language)

# reduce to just eng
my_df <- my_df %>% filter(language == "en")

# remove the info on language (now useless)
my_df$language <- NULL

# save all
save(my_df, file = "corpora/GoodreadsSA.RData")


# 2. Twitter

# find all files' addresses
all_twitter_files <- list.files(path = "corpora", pattern = "tweets_", full.names = T)

# read the first file to prepare the dataframe
my_df <- read.csv(all_twitter_files[1], row.names = 1, stringsAsFactors = F)

# get just text and lang
my_df <- my_df[,c("text", "lang")]
my_df$search <- gsub(pattern = "corpora/tweets_", replacement = "", all_twitter_files[1])

# iterate on the other files (if there are)
if(length(all_twitter_files) > 1){
  
  for(i in 2:length(all_twitter_files)){
    
    # read datasets one by one
    my_tmp_df <- read.csv(all_twitter_files[i], row.names = 1, stringsAsFactors = F)
    my_tmp_df <- my_tmp_df[,c("text", "lang")]
    my_tmp_df$search <- gsub(pattern = "corpora/tweets_", replacement = "", all_twitter_files[i])
    
    # concatenate
    my_df <- rbind(my_df, my_tmp_df)
    
  }
  
}

# exclude the "NA" tweets (probably due to errors in the scraping)
my_df <- my_df[!is.na(my_df$text),]

# some stats
my_df %>% count(lang)

# reduce to just eng
my_df <- my_df %>% filter(lang == "en")

# remove the info on language (now useless)
my_df$lang <- NULL

# save all
save(my_df, file = "corpora/TwitterSA.RData")
