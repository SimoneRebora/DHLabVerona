# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

#### 1. Reading/writing text files

# printing working directory
getwd()
setwd("samples") # notice that this can also be done via the RStudio GUI
getwd()
setwd("..") # then go back to the previous (mother) directory
getwd()

# read text line by line
my_text <- readLines("samples/Cbronte_Jane_1847.txt")
head(my_text)

# collapse all text in a single line (separated by the "newline" character)
my_text <- paste(my_text, collapse = "\n")

# write file
cat("The cat is on the table")
cat("The cat is on the table", file = "Cat.txt")

### Your Turn (1) - start

# read the other .txt file in the "samples" folder (Doyle) and split it into single words 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (1) - end

#### 2. Reading/writing tables

# create a dataframe
my_df <- data.frame(author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality = c("English", "Italian", "Spanish", "American"))
# write it to file
write.csv(my_df, file = "samples/Authors.csv")

# read the file back to another dataframe
my_authors <- read.csv("samples/Authors.csv")
# there is a column too much! Improve it:
my_authors <- read.csv("samples/Authors.csv", row.names = 1)

### Your Turn (2) - start

# read the other .csv file in the "samples" folder and find the Italian author(s) 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (2) - end


#### 3. Making loops

# basic loop
for(i in 1:10){
  print(i)
}

# if conditions
for(i in 1:10){
  if(i == 1){
    print(i)
  }
}

# if/else conditions
for(i in 1:10){
  if(i == 1){
    print(i)
  }else{
    print("more than one")
  }
}

# while loops
n <- 1
while(n <= 10){
  print(n)
  n <- n+1
}
# be careful with while loops, because you might create never-ending loops!

# the sapply/lapply functions
# (with a simple example: increase the values in one vector)
my_vector <- 1:10
my_vector
for(i in 1:10){
  
  my_vector[i] <- my_vector[i]+1
  
}
my_vector

# it is the same of this sapply function:
my_vector <- 1:10
my_vector <- sapply(my_vector, function(x) x+1)
my_vector

# if you are working with lists, then you can use lapply
my_list <- list(1:10, 2:20)
my_list <- lapply(my_list, function(x) x+1)
my_list

# why use sapply/lapply? Because they are faster than a loop

# advanced loop: read files in a folder
# first, find all file names
my_files <- list.files(path = "samples", full.names = T, pattern = ".txt") # note that pattern is used to list just .txt files (so not the .csv ones in the folder)
my_files

# second, create an empty variable where to store the results
my_texts <- character()

# third, run loop on the files
for(i in 1:length(my_files)){
  
  cat("reading", my_files[i], "...\n")
  
  my_text_tmp <- readLines(my_files[i])
  my_text_tmp <- paste(my_text_tmp, collapse = "\n")
  
  my_texts[i] <- my_text_tmp
  names(my_texts)[i] <- gsub(pattern = "samples/|.txt", replacement = "", my_files[i])

}

# not ideal! ...but just for the visualization
my_df <- as.data.frame(my_texts)
View(my_df)

### Your Turn (3) - start

# read the two .csv files in the "samples" folder using a loop like the one above 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (3) - end

#### 4. Functions

# basic (stupid) example
my_function <- function(){
  cat("Ciao")
}

my_function()

# a practical case
read_corpus <- function(x){
  
  my_files <- list.files(path = x, full.names = T, pattern = ".txt")
  my_texts <- character()
  
  for(i in 1:length(my_files)){
    
    cat("reading", my_files[i], "...\n")
    
    my_text_tmp <- readLines(my_files[i])
    my_text_tmp <- paste(my_text_tmp, collapse = "\n")
    
    my_texts[i] <- my_text_tmp
    names(my_texts)[i] <- gsub(pattern = paste(x, "/|.txt", sep = ""), replacement = "", my_files[i])
    
  }
  
  return(my_texts)

}

my_texts_2 <- read_corpus("samples")

### Your Turn (4) - start

# write a function that reads the .csv files in the "samples" folder and prints how many Italians there are in each table 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (4) - end

#### 5. Packages

# install (this should be done just once)
install.packages("tidyverse")

# load (this should be done every time you start R!)
library(tidyverse)
# more efficient ways to manage dataframes

# for example: find the Italian author in our dataframe of authors
# with base R, you should do like that
my_authors[which(my_authors$nationality == "Italian"),]

# with tidyverse, you do like
my_authors %>% filter(nationality == "Italian")

### Appendix
# note: the "<-" sign can be substitited by "="
my_variable <- "Shakespeare"
my_variable = "Shakespeare"
# still, it is advised to distinguish between the two, as the "<-" sign has a "stronger" function. See for example in the creation of a dataframe
my_df <- data.frame(author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality = c("English", "Italian", "Spanish", "American"))
author # it does not exist!!

my_df_2 <- data.frame(author <- c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality <- c("English", "Italian", "Spanish", "American"))
author # now it exists!!

# for more details (and discussion): https://stackoverflow.com/questions/1741820/what-are-the-differences-between-and-assignment-operators-in-r 
