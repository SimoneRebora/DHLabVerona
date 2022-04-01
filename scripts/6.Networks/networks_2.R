# networks_2

library(tidyverse)

# read tweets on "vaccino" 
my_df <- read.csv("corpora/tweets_vaccino.csv", stringsAsFactors = F)

# how many tweets were retweets?
length(which(!is.na(my_df$referenced_tweets.retweeted.id)))

# how many tweets were retweets (of tweets present in our selection)?
length(which(my_df$referenced_tweets.retweeted.id %in% my_df$id))

# reduce just to tweets that are retweets/retweeted inside of my dataset
my_df <- my_df %>% filter(referenced_tweets.retweeted.id %in% id |
                            id %in% referenced_tweets.retweeted.id)

# let's get how many times tweets were retweeted
retweets <- my_df %>% group_by(referenced_tweets.retweeted.id) %>% count()

# let's see how many tweets were retweeted more than 500 times
length(which(retweets$n > 500))

# let's reduce just to these tweets
my_tweets <- retweets$referenced_tweets.retweeted.id[which(retweets$n > 500)]

my_df <- my_df %>% filter(referenced_tweets.retweeted.id %in% my_tweets | 
                            id %in% my_tweets)

# build nodes table
tweets_df <- data.frame(Id = my_df$id, Label = "", group = "Tweets")
users_df <- data.frame(Id = unique(my_df$author_id), Label = unique(my_df$author.username), group = "Users")

nodes_df <- rbind(tweets_df, users_df)

# build edges table
authoring_df <- data.frame(Source = my_df$author_id, Target = my_df$id, Weight = 1, Type = "directed")
retweeting_df <- data.frame(Source = my_df$id, Target = my_df$referenced_tweets.retweeted, Weight = 1, Type = "directed")

# remove NAs (i.e. the two tweets that are not retweets)
which(is.na(retweeting_df$Target))

retweeting_df <- retweeting_df[-which(is.na(retweeting_df$Target)),]

edges_df <- rbind(authoring_df, retweeting_df)

# write all
write.csv(nodes_df, file = "corpora/GephiTweetNodes.csv", row.names = F)
write.csv(edges_df, file = "corpora/GephiTweetEdges.csv", row.names = F)
