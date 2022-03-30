# network_1

# install.packages("tidyverse")
# install.packages("stylo")
# install.packages("cld2")

library(tidyverse)
library(stylo)
library(cld2)

# let's work on the AO3 texts

load("corpora/AO3_corpus.RData")

# assign unique IDs to texts
my_df$ID <- as.numeric(rownames(my_df))

# remove texts that are too short (below 2'000 words)

my_df <- my_df %>% filter(length > 2000)

# remove texts that are not in English

my_df$lang <- detect_language(my_df$incipit)
my_df <- my_df %>% filter(lang == "en")


# check if there are authors with multiple texts

head(sort(table(my_df$author), decreasing = T), 15)

# reduce analysis just to texts of these authors

my_authors <- names(head(sort(table(my_df$author), decreasing = T), 15))
my_df <- my_df %>% filter(author %in% my_authors)

all_texts <- all_texts[my_df$ID]

# run a loop on all the texts to tokenize them
my_texts <- lapply(all_texts, function(x) txt.to.words.ext(x, corpus.lang = "English"))

# then assign names based on metadata
names(my_texts) <- paste(my_df$author, gsub(" |,", "", my_df$title), sep = "_")

# sort texts by author name
my_texts <- my_texts[sort(names(my_texts))]

# then run the stylo network analysis
stylo.network(parsed.corpus = my_texts)

# cleanup working files
unlink("*.txt")

# move tables to corpora folder
my_files <- list.files(pattern = ".csv")
file.copy(my_files, "corpora/", recursive = T)
unlink(my_files)

