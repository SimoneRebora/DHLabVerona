# SA_2

library(syuzhet)
library(tidyverse)
library(reshape2)

# Basic emotions in tweets

# load corpus
load("corpora/TwitterSA.RData")

# let's find emotional values for one text
get_nrc_sentiment(my_df$text[1])

# let's add these values to all texts
emotion_values <- data.frame()

# iterate on all texts
for(i in 1:length(my_df$text)){
  
  emotion_values <- rbind(emotion_values, get_nrc_sentiment(my_df$text[i]))
  if(i %% 100 == 0)
    print(i/length(my_df$text))
  
}

# normalize per text length
my_df$length <- lengths(strsplit(my_df$text, "\\W"))

# iterate on all reviews
for(i in 1:length(my_df$text)){
  
  emotion_values[i,] <- emotion_values[i,]/my_df$length[i]
  
}

# then we can unite the dataframes
my_df <- cbind(my_df, emotion_values)

# let's pick up two searches to compare?
# searches are already just two!!

my_df$text <- NULL
my_df$length <- NULL

# visualization 1: barplot
# calculate means
my_df_mean <- my_df %>%
  group_by(search) %>%
  summarise_all(list(mean = mean))

# melt dataframe
my_df_mean <- melt(my_df_mean)

# visualize plot
p1 <- ggplot(my_df_mean, aes(x=variable, y=value, fill=search))+
  geom_bar(stat="identity", position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
p1

# save plot
ggsave(p1, filename = "figures/3.Sentiment_analysis/Twitter_plot_01.png", height = 9, width = 16, scale = 0.5)

# visualization 2: boxplot
# melt dataframe
my_df <- melt(my_df)

# make plot
p2 <- ggplot(my_df, aes(x=variable, y=value, fill=search))+
  geom_boxplot(position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
p2

# save plot
ggsave(p2, filename = "figures/3.Sentiment_analysis/Twitter_plot_02.png", height = 9, width = 16, scale = 0.5)

# ...using means seems better than boxplots...
