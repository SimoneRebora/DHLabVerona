# process_annotations

# install.packages("irr")

library(irr)

# find all files
all_tables <- list.files(path = "corpora", pattern = "Group", full.names = T)

# divide them into the two groups
tablesA <- all_tables[which(grepl("A", all_tables))]
tablesB <- all_tables[which(grepl("B", all_tables))]

# iterate on all files to build just two tables
df_A <- data.frame()
df_B <- data.frame()
for(i in 1:length(tablesA)){
  
  df_A <- rbind(df_A, read.csv(tablesA[i], stringsAsFactors = F))
  df_B <- rbind(df_B, read.csv(tablesB[i], stringsAsFactors = F))
  
}

# re-establish annotation order
df_A <- df_A[order(df_A$X),]
df_B <- df_B[order(df_B$X),]

# convert values (0,1-1) into polarities
df_A$polarity[which(df_A$polarity == "0")] <- "neutral"
df_A$polarity[which(df_A$polarity == "1")] <- "positive"
df_A$polarity[which(df_A$polarity == "-1")] <- "negative"
table(df_A$polarity)

df_B$polarity[which(df_B$polarity == "0")] <- "neutral"
df_B$polarity[which(df_B$polarity == "1")] <- "positive"
df_B$polarity[which(df_B$polarity == "-1")] <- "negative"
table(df_B$polarity)

# join everything in a single dataframe
full_df <- cbind(df_A, df_B$polarity)

# rename columns
full_df$X <- NULL
colnames(full_df) <- c("text", "annotator_1", "annotator_2")

# find cases of disagreement
full_df$agreed <- full_df$annotator_1 == full_df$annotator_2

# calculate how many
length(which(!full_df$agreed))

# calculate inter-annotator agreement
kappa2(full_df[,2:3])

# inspect (and eventually curate) the data
View(full_df)

# reduce just to full agreement
full_df <- full_df[which(full_df$agreed),]

# prepare for train/test subdivision by randomly shuffling
all_ids <- sample(1:length(full_df$text))
# one/fifth for testing
test_ids <- all_ids[1:round(length(all_ids)/5)]
# four/fifth for training
train_ids <- all_ids[(round(length(all_ids)/5)+1):length(all_ids)]

# create train/test dataframes
train_df <- data.frame(text = full_df$text[train_ids], coarse_label = full_df$annotator_1[train_ids], stringsAsFactors = F)
test_df <- data.frame(text = full_df$text[test_ids], coarse_label = full_df$annotator_1[test_ids], stringsAsFactors = F)

# write them to tables
write.table(train_df, file = "corpora/train.tsv", sep = "\t", row.names = F, quote = F)
write.table(test_df, file = "corpora/test.tsv", sep = "\t", row.names = F, quote = F)
