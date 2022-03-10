# SA_1

# install and load package for sentiment analysis
install.packages("syuzhet")
library(syuzhet)

install.packages("reshape2")
library(reshape2)

library(tidyverse)
# Basic emotions in reviews 

# load corpus
load("corpora/GoodreadsSA.RData")

# let's find emotional values for one review
get_nrc_sentiment(my_df$review[1])

# let's add these values to all reviews
emotion_values <- data.frame()

# iterate on all reviews
for(i in 1:length(my_df$review)){
  
  emotion_values <- rbind(emotion_values, get_nrc_sentiment(my_df$review[i]))
  
}

# normalize per review length
my_df$length <- lengths(strsplit(my_df$review, "\\W"))

# iterate on all reviews
for(i in 1:length(my_df$review)){
  
  emotion_values[i,] <- emotion_values[i,]/my_df$length[i]
  
}

# then we can unite the dataframes
my_df <- cbind(my_df, emotion_values)

# let's pick up two titles to compare
unique(my_df$book)

my_books <- unique(my_df$book)[c(1,5)]
my_books

# create a subset of the dataframe with just the two books
my_df_red <- my_df %>% filter(book %in% my_books)
my_df_red$review <- NULL
my_df_red$length <- NULL

# visualization 1: barplot
# calculate means
my_df_red_mean <- my_df_red %>%
  group_by(book) %>%
  summarise_all(list(mean = mean))

# melt dataframe
my_df_red_mean <- melt(my_df_red_mean)

# visualize plot
p1 <- ggplot(my_df_red_mean, aes(x=variable, y=value, fill=book))+
  geom_bar(stat="identity", position = "dodge")
p1

# save plot
ggsave(p1, filename = "figures/3.Sentiment_analysis/Goodreads_plot_01.png", height = 9, width = 16)

# better plot
p2 <- ggplot(my_df_red_mean, aes(x=variable, y=value, fill=book))+
  geom_bar(stat="identity", position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
p2

# save plot
ggsave(p2, filename = "figures/3.Sentiment_analysis/Goodreads_plot_02.png", height = 9, width = 16, scale = 0.5)

# visualization 2: boxplot
# melt dataframe
my_df_red_mean <- melt(my_df_red)

# make plot
p3 <- ggplot(my_df_red_mean, aes(x=variable, y=value, fill=book))+
  geom_boxplot(position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
p3

# save plot
ggsave(p3, filename = "figures/3.Sentiment_analysis/Goodreads_plot_03.png", height = 9, width = 16, scale = 0.5)


### Your Turn

# repeat the same, but for a different pair of books... 


