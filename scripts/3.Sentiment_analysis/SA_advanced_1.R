# SA_advanced_1

# Use UDpipe for multi-language NLP
# https://bnosac.github.io/udpipe/en/

install.packages("udpipe")
library(udpipe)

library(tidyverse)

load("corpora/GoodreadsSA.RData")

# find models in the resources folder
list.files(path = "resources/udpipe", pattern = ".udpipe", full.names = T)

# if you like, you can download a udpipe model for another language, with the following command:
# udpipe_download_model(language = "my_language", model_dir = "resources/udpipe")
# just change "my_language" to the language of interest

# load the (english) model
udmodel <- udpipe_load_model(file = "resources/udpipe/english-ewt-ud-2.4-190531.udpipe")

# then process the text
text_annotated <- udpipe(object = udmodel, x = my_df$review, doc_id = rownames(my_df), trace = T)
View(text_annotated)

# now everything is ready to perform (multi-language) SA!

# Example: multi-dimensional SA with SentiArt
# info: https://github.com/matinho13/SentiArt

# read SentiArt from resources folder
my_dictionary <- read.csv("resources/sentiment_dictionaries/SentiArt_eng.csv", stringsAsFactors = F)
View(my_dictionary)

# note: Sentiart includes values per word (not lemma) in lowercase, so we need to lowercase the tokens in our text and perform the analysis on them
text_annotated$token_lower <- tolower(text_annotated$token)

# to avoid annotating stopwords, limit the analysis to meaningful content words
POS_sel <- c("NOUN", "VERB", "ADV", "ADJ", "INTJ") # see more details here: https://universaldependencies.org/u/pos/
text_annotated$token_lower[which(!text_annotated$upos %in% POS_sel)] <- NA

# use left_join to add multiple annotations at once
text_annotated <- left_join(text_annotated, my_dictionary, by = c("token_lower" = "word")) 

# now that the sentiment annotation is done, let's keep just the useful info 
text_annotated <- text_annotated[c(1,19:length(text_annotated))]

# replace NAs with zeros
text_annotated <- mutate(text_annotated, across(everything(), ~replace_na(.x, 0)))

View(text_annotated)

# get overall values per review
sentences_annotated <- text_annotated %>%
  group_by(doc_id) %>%
  summarise_all(list(mean = mean))

# let's order the reviews by number
sentences_annotated <- sentences_annotated[order(as.numeric(sentences_annotated$doc_id)),]

# now we can join the annotations to the original dataframe 
my_df <- cbind(my_df, sentences_annotated[,2:length(sentences_annotated)])
View(my_df)

# then the same analyses of "SA_1.R" can be performed!!

### Your Turn

# continue the analysis as in the "SA_1.R" file
