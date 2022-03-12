# SA_advanced_3

# how to deal with negation

my_sentence <- "Non era felice! Non era una persona felice!"

udmodel <- udpipe_load_model(file = "resources/udpipe/italian-isdt-ud-2.4-190531.udpipe")

# then process the text
text_annotated <- udpipe(object = udmodel, x = my_sentence)

# now everything is ready to perform (multi-language) SA!

# read OpeNER from resources folder
my_dictionary <- read.csv("resources/sentiment_dictionaries/OpeNER_ita.csv", stringsAsFactors = F)

# note: OpeNER (like most of the SA dictionaries) includes values per lemma in lowercase, so we need to lowercase the lemmas in our text and perform the analysis on them
text_annotated$lemma_lower <- tolower(text_annotated$lemma)
# important: if you are working with a language where capital letters are distinctive (e.g. German), then you won't have to lowercase

# to avoid annotating stopwords, limit the analysis to meaningful content words
POS_sel <- c("NOUN", "VERB", "ADV", "ADJ", "INTJ") # see more details here: https://universaldependencies.org/u/pos/
text_annotated$lemma_lower[which(!text_annotated$upos %in% POS_sel)] <- NA

# use left_join to add multiple annotations at once
text_annotated <- left_join(text_annotated, my_dictionary, by = c("lemma_lower" = "word")) 
View(text_annotated)

# define a list of negations
my_negations <- c("non", "mai", "manco")

# 1. simplest method
text_annotated$valence_method1 <- text_annotated$valence

# define a range
my_range <- 3

# negations will reverse emotion values in that range
for(i in 1:length(text_annotated$doc_id)){
  
  if(text_annotated$lemma[i] %in% my_negations)
    text_annotated$valence_method1[i:(i+my_range)] <- -text_annotated$valence[i:(i+my_range)]
  
}

View(text_annotated)

# 2. more complex method
text_annotated$valence_method2 <- text_annotated$valence

for(i in 1:length(text_annotated$doc_id)){
  
  if(text_annotated$lemma[i] %in% my_negations){
    
    same_head <- which(text_annotated$doc_id == text_annotated$doc_id[i] & text_annotated$paragraph_id == text_annotated$paragraph_id[i] & text_annotated$sentence_id == text_annotated$sentence_id[i] & text_annotated$head_token_id == text_annotated$head_token_id[i])
    
    text_annotated$valence_method2[same_head] <- -text_annotated$valence[same_head]
    
    head_of <- which(text_annotated$doc_id == text_annotated$doc_id[i] & text_annotated$paragraph_id == text_annotated$paragraph_id[i] & text_annotated$sentence_id == text_annotated$sentence_id[i] & text_annotated$token_id == text_annotated$head_token_id[i])
    
    text_annotated$valence_method2[head_of] <- -text_annotated$valence[head_of]
    
  }
    
}

# Tip: existing packages

# A very nice package that does valence shifters in R: https://github.com/trinker/sentimentr
# ...but it works just for English: https://github.com/trinker/sentimentr/issues/74

# Vader (part of NLTK in python) considers also valence shifters: https://github.com/cjhutto/vaderSentiment

# Important note: valence shifters do not simply reverse sentiment. They can also increase it, decrease it slightly or strongly
# you need to build a dictionary of polarity shifters
# e.g. https://github.com/uds-lsv/lexicon-of-english-verbal-polarity-shifters
