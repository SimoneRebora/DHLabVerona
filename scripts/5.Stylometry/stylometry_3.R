# stylometry_3

# 1. Stylo's oppose function

library(stylo)
library(tidyverse)

load("corpora/TwitterSA.RData")
View(my_df)

# remove the "\\n" as it creates issues with tokenization
my_df$text <- gsub(pattern = "\\n", replacement = " ", x = my_df$text, fixed = T)

# collapse the texts based on the two Twitter searches
two_texts <- my_df %>%
  group_by(search) %>%
  summarize(text = paste(text, collapse = " "))

# tokenize using stylo's function
my_texts <- lapply(two_texts$text, function(x) txt.to.words.ext(x, corpus.lang = "English"))
names(my_texts) <- two_texts$search

# create primary/secondary corpus
primary_corpus <- my_texts[1]
secondary_corpus <- my_texts[2]

# split corpora into two parts
# that's annoying, but it's necessary for stylo's function to run with no errors
chunk2 <- function(x,n) split(x[[1]], cut(seq_along(x[[1]]), n, labels = FALSE)) 

primary_corpus <- chunk2(primary_corpus, 2)
secondary_corpus <- chunk2(secondary_corpus, 2)

# then run the "oppose" function
my_results <- oppose(primary.corpus = primary_corpus, secondary.corpus = secondary_corpus)

# if the visualization does not work well, you can explore the results here
my_results$words.preferred[1:10]
my_results$words.avoided[1:10]

my_results$words.preferred.scores[1:10]
my_results$words.avoided.scores[1:10]

# After having done all analyses: cleanup working files
unlink(c("*.txt", "*.csv", "*.pdf", "*.svg", "*.jpg", "*.png"))

# 2. Quanteda

# install.packages("quanteda")
# install.packages("quanteda.textstats")
# install.packages("quanteda.textplots")

library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)

# First, data has to be prepared (by repeating the procedure above)

# In this case, we do not need to tokenize the text
# so the "my_texts" variable can be a vector, not a list 
quanteda_texts <- two_texts$text
names(quanteda_texts) <- two_texts$search

# to accelerate the process, we reduce a bit the length of texts
nchar(quanteda_texts)
quanteda_texts <- sapply(quanteda_texts, function(x) substr(x, 1, 100000))

### Here quanteda gets in action
# first, it tokenizes the text 
quanteda_texts <- tokens(quanteda_texts, remove_punct = T)

# second, it transforms the corpus into a document-feature matrix 
document_feature_matrix <- dfm(quanteda_texts)
# note that the "grouping" is based on the names of the corpus

# third, it calculates the keyness for each word
# choosing as a target the documents with the "harrypotter.csv" name
# and using as a measure the "log-likelihood ratio" method ("lr")
keyness_results <- textstat_keyness(document_feature_matrix, target = "harrypotter.csv", measure = "lr")

# Finally, we plot the results
textplot_keyness(keyness_results, n = 20)

# ...and save them as png, for a comparison with the "Zeta analysis"
png(filename = "figures/5.Stylometry/LogLikelihood.png", height = 2000, width = 3000, res = 300)
textplot_keyness(keyness_results, n = 20)
dev.off()
