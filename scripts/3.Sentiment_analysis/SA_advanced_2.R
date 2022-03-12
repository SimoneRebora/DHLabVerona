# SA_advanced_2

# use UDpipe with Italian texts

library(udpipe)
library(tidyverse)
library(syuzhet)

# read the Italian twitter file into the dataframe
my_df <- read.csv("corpora/tweets_vaccino.csv", row.names = 1, stringsAsFactors = F)

# select just Italian tweets
my_df <- my_df %>% filter(lang == "it")

# convert date of creation into date/time format
my_df$created_at[1]
class(my_df$created_at[1])

my_df$created_at <- strptime(my_df$created_at, "%Y-%m-%dT%H:%M:%S.000Z", tz = "CET")

my_df$created_at[1]
class(my_df$created_at[1])

# keep just what is relevant
my_df <- my_df[,c("text", "created_at")]

# to simplify things, reduce to a random selection of 1000 tweets
my_df <- my_df[sample(1:length(my_df$text), 1000),]
rownames(my_df) <- 1:length(my_df$text)

# ...dataset preparation complete!

# find models in the resources folder
list.files(path = "resources/udpipe", pattern = ".udpipe", full.names = T)

# if you like, you can download a udpipe model for another language, with the following command:
# udpipe_download_model(language = "my_language", model_dir = "resources/udpipe")
# just change "my_language" to the language of interest

# load the (italian) model
udmodel <- udpipe_load_model(file = "resources/udpipe/italian-isdt-ud-2.4-190531.udpipe")

# then process the text
text_annotated <- udpipe(object = udmodel, x = my_df$text, doc_id = rownames(my_df), trace = T)

# now everything is ready to perform (multi-language) SA!

# read OpeNER from resources folder
my_dictionary <- read.csv("resources/sentiment_dictionaries/OpeNER_ita.csv", stringsAsFactors = F)
View(my_dictionary)

# note: OpeNER (like most of the SA dictionaries) includes values per lemma in lowercase, so we need to lowercase the lemmas in our text and perform the analysis on them
text_annotated$lemma_lower <- tolower(text_annotated$lemma)
# important: if you are working with a language where capital letters are distinctive (e.g. German), then you won't have to lowercase

# to avoid annotating stopwords, limit the analysis to meaningful content words
POS_sel <- c("NOUN", "VERB", "ADV", "ADJ", "INTJ") # see more details here: https://universaldependencies.org/u/pos/
text_annotated$lemma_lower[which(!text_annotated$upos %in% POS_sel)] <- NA

# use left_join to add multiple annotations at once
text_annotated <- left_join(text_annotated, my_dictionary, by = c("lemma_lower" = "word")) 

# now that the sentiment annotation is done, let's keep just the useful info 
text_annotated <- text_annotated[c(1,19:length(text_annotated))]

# replace NAs with zeros
text_annotated <- mutate(text_annotated, across(everything(), ~replace_na(.x, 0)))

View(text_annotated)

# get overall values per review
sentences_annotated <- text_annotated %>%
  group_by(doc_id) %>%
  summarise_all(list(valence = mean))

# let's order the reviews by number
sentences_annotated <- sentences_annotated[order(as.numeric(sentences_annotated$doc_id)),]

# now we can join the annotations to the original dataframe 
my_df <- cbind(my_df, sentences_annotated[,2:length(sentences_annotated)])
View(my_df)

# then we can re-order the dataframe based on the tweets creation dates
my_df <- my_df[order(my_df$created_at),]

# then the same analyses of "SA_4.R" can be performed!!

# put them in a graph
plot(
  my_df$valence, 
  type="l", 
  main="Vaccine on Italian Twitter", 
  xlab = "Time", 
  ylab= "Emotional Valence"
)

# then, let's use the "rolling plot" function from syuzhet (taken from https://github.com/mjockers/syuzhet/blob/master/R/syuzhet.R)

rolling_plot <- function (raw_values, window = 0.1){
  wdw <- round(length(raw_values) * window)
  rolled <- rescale(zoo::rollmean(raw_values, k = wdw, fill = 0))
  half <- round(wdw/2)
  rolled[1:half] <- NA
  end <- length(rolled) - half
  rolled[end:length(rolled)] <- NA
  return(rolled)
}

my_df$valence <- rolling_plot(my_df$valence)

# line chart
my_df$created_at <- as.POSIXct(my_df$created_at)
p1 <- ggplot(my_df, aes(x=created_at, y=valence)) + 
  geom_line()

p1

ggsave(p1, filename = "figures/3.Sentiment_analysis/Twitter_plot_03.png", width = 16, height = 9, scale = 0.5)
