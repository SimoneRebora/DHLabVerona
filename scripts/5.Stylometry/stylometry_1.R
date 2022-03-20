# stylometry_1

# install.packages("stylo")

library(tidyverse)
library(stylo)

# let's work on the AO3 texts

load("corpora/AO3_corpus.RData")

# assign unique IDs to texts
my_df$ID <- as.numeric(rownames(my_df))

# remove texts that are too short (below 5'000 words)

exclude <- which(my_df$length < 5000) 
my_df <- my_df[-exclude,]

# check if there are authors with multiple texts

head(sort(table(my_df$author), decreasing = T))

# reduce analysis just to texts of these 6 authors

my_authors <- names(head(sort(table(my_df$author), decreasing = T)))
my_df <- my_df %>% filter(author %in% my_authors)

all_texts <- all_texts[my_df$ID]

# run a loop on all the texts to tokenize them
my_texts <- lapply(all_texts, function(x) txt.to.words.ext(x, corpus.lang = "English"))

# then assign names based on metadata
names(my_texts) <- paste(my_df$author, gsub(" ", "", my_df$title), sep = "_")

# sort texts by author name
my_texts <- my_texts[sort(names(my_texts))]

# now you can explore the list: each element contains one tokenized text
names(my_texts)
head(my_texts[[1]])
head(my_texts[[2]])

# Now everything is ready to run stylo on the texts that we have saved in the R list
results_stylo <- stylo(parsed.corpus = my_texts)
# Note: the results of the analysis have been saved in a variable called "stylo_results"

# cleanup working files
unlink(c("*.txt", "*.csv"))

# move plot to figures folder
my_files <- list.files(pattern = ".png")
file.copy(my_files, "figures/5.Stylometry/", recursive = T)
unlink(my_files)

# Part 2. Explore

results_stylo$distance.table
# Note: the "$" simbol is used to see the sub-section in a structured variable

# see the name of the texts in the distance table
rownames(results_stylo$distance.table)

# see a portion of the distance table
# for example the one of the first text in our selection
results_stylo$distance.table[1,]

# which one is the "closest" text?
sort(results_stylo$distance.table[1,])

# see a table with the frequency of all words
results_stylo$frequencies.0.culling
# rows are the texts, columns the words

# produce a list of the most frequent words
colnames(results_stylo$frequencies.0.culling)

# which is the position in the table of the word "lights"
word_position <- which(colnames(results_stylo$frequencies.0.culling) == "nonsense")

# which author uses that word most frequently?
sort(results_stylo$frequencies.0.culling[,word_position], decreasing = T)
