# stylometry_2

# install.packages("stylo")

library(stylo)

# let's work on the AO3 texts

load("corpora/AO3_corpus.RData")

# let's work on a few, random texts
my_df <- my_df[1:50,]

# assign unique IDs to texts
my_df$ID <- as.numeric(rownames(my_df))

# remove texts that are too short (below 2'000 words)

exclude <- which(my_df$length < 2000) 
my_df <- my_df[-exclude,]
all_texts <- all_texts[my_df$ID]

# run a loop on all the texts to tokenize them
my_texts <- lapply(all_texts, function(x) txt.to.words.ext(x, corpus.lang = "English"))

# then assign names based on metadata
names(my_texts) <- paste(my_df$author, gsub(" ", "", my_df$title), sep = "_")

# sort texts by author name
my_texts <- my_texts[sort(names(my_texts))]

# Now everything is ready to run stylo on the texts that we have saved in the R list
stylo(parsed.corpus = my_texts)
# Note: the results of the analysis have been saved in a variable called "stylo_results"

# now let's repeat the analysis with different approaches!
# try Consensus Tree...

# then we can try the network visualization
stylo.network(parsed.corpus = my_texts)

# After having done all analyses: cleanup working files
unlink(c("*.txt", "*.csv", "*.pdf", "*.svg", "*.jpg", "*.png"))

