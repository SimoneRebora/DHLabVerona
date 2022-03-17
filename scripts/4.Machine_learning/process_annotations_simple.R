# process_annotations_simple

# find all files
all_tables <- list.files(path = "corpora", pattern = "NOGROUP", full.names = T)

full_df <- data.frame()

# iterate on all files to build just one table
for(i in 1:length(all_tables)){
  
  full_df <- rbind(full_df, read.csv(all_tables[i], stringsAsFactors = F))

}

# re-establish annotation order
full_df <- full_df[order(full_df$X),]

# convert values (0,1-1) into polarities
full_df$polarity[which(full_df$polarity == "0")] <- "neutral"
full_df$polarity[which(full_df$polarity == "1")] <- "positive"
full_df$polarity[which(full_df$polarity == "-1")] <- "negative"
table(full_df$polarity)

# rename columns
full_df$X <- NULL

# prepare for train/test subdivision by randomly shuffling
all_ids <- sample(1:length(full_df$text))
# one/fifth for testing
test_ids <- all_ids[1:round(length(all_ids)/5)]
# four/fifth for training
train_ids <- all_ids[(round(length(all_ids)/5)+1):length(all_ids)]

# create train/test dataframes
train_df <- data.frame(text = full_df$text[train_ids], coarse_label = full_df$polarity[train_ids], stringsAsFactors = F)
test_df <- data.frame(text = full_df$text[test_ids], coarse_label = full_df$polarity[test_ids], stringsAsFactors = F)

# write them to tables
write.table(train_df, file = "corpora/train.tsv", sep = "\t", row.names = F, quote = F)
write.table(test_df, file = "corpora/test.tsv", sep = "\t", row.names = F, quote = F)
