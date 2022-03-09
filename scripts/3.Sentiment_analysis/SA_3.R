# SA_3

# Sentiment analysis with syuzhet: how does it work?

# download the sentiment dictionaries included in Syuzhet
download.file("https://github.com/mjockers/syuzhet/raw/master/R/sysdata.rda", destfile = "corpora/syuzhet_dict.RData")
load("corpora/syuzhet_dict.RData")

# let's explore the NRC dictionary!
View(nrc)

# find all words tagged as "anger" in English
nrc %>% filter(lang == "english" & sentiment == "anger")

# test a sentence
get_nrc_sentiment("I was abandoned")

# find all words tagged as "fear" in English
nrc %>% filter(lang == "english" & sentiment == "fear")

# let's explore other dictionaries!
View(afinn)
View(syuzhet_dict)
# etc.

# let's test syuzhet on tought sentences
my_sentence <- "Well, he was like a potato!"
get_sentiment(my_sentence, method="syuzhet")
get_sentiment(my_sentence, method="afinn")

### Your Turn

# try other sentences
my_sentence <- "..."
get_sentiment(my_sentence, method="syuzhet")
