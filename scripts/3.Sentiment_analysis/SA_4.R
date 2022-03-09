# SA_4

# Emotional arcs (with stories from AO3)

library(syuzhet)
library(reshape2)

load("corpora/AO3_corpus.RData")

# just select one text (e.g. the fifth in my selection)
View(my_df)
text <- all_texts[5]

# here Syuzhet comes into action: it splits the text into sentences
sentences_vector <- get_sentences(text)

# ...and calulates the sentiment for each sentence
syuzhet_vector <- get_sentiment(sentences_vector, method="syuzhet")

# let's visualize the results
syuzhet_vector

# put them in a graph
plot(
  syuzhet_vector, 
  type="l", 
  main="Sentiment Arc", 
  xlab = "Narrative Time", 
  ylab= "Emotional Valence"
)

# ...it is still too noisy: we'll need to use some filters
simple_plot(syuzhet_vector, title = "Sentiment arc")

# we can save the plot as a png file
png("figures/3.Sentiment_analysis/AO3_plot_01.png", height = 900, width = 1600, res = 100)
simple_plot(syuzhet_vector, title = "Sentiment arc")
dev.off()

# we can also look at the basic emotions (Plutchik)
syuzhet_emotions <- get_nrc_sentiment(sentences_vector)

View(syuzhet_emotions)

# let's prepare a nice plot!

# first, just focus on the eight basic emotions
syuzhet_emotions <- syuzhet_emotions[,1:8]

# then, let's use the "rollingp plot" function from syuzhet (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)

rolling_plot <- function (raw_values, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  return(rolled)
}

# first, create smoothed plots for each emotion
for(i in 1:dim(syuzhet_emotions)[2]){
  syuzhet_emotions[,i] <- (rolling_plot(syuzhet_emotions[,i])+1)/2
}

# then normalize between zero and one
for(i in 1:dim(syuzhet_emotions)[1]){
  syuzhet_emotions[i,] <- syuzhet_emotions[i,]/sum(syuzhet_emotions[i,])
}

# then melt the dataframe
syuzhet_emotions$paragraph <- 1:dim(syuzhet_emotions)[1]
emotional_results_melt <- melt(syuzhet_emotions, id.vars = "paragraph")

colnames(emotional_results_melt) <- c("paragraph", "emotion", "value")

# stacked area chart
p3 <- ggplot(emotional_results_melt, aes(x=paragraph, y=value, fill=emotion)) + 
  geom_area()

p3

ggsave(p3, filename = "figures/3.Sentiment_analysis/AO3_plot_02.png", width = 16, height = 9, scale = 0.5)
