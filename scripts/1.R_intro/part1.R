### Welcome!

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

### 1. Creating variables

# numbers
my_number <- 1
my_number

# strings of text
my_string <- "to be or not to be"
my_string

# vectors
my_first_vector <- c(1,2,3,4,5)
my_first_vector

# tip: you can get the same by writing
my_first_vector <- 1:5
my_first_vector

# vectors (of strings)
my_second_vector <- c("to", "be", "or", "not", "to", "be")
my_second_vector

# lists
my_list <- list(1:5, c("to", "be", "or", "not", "to", "be"))
my_list

# tip: you can get the same by writing
my_list <- list(my_first_vector, my_second_vector)
my_list

# dataframes
my_df <- data.frame(author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality = c("English", "Italian", "Spanish", "American"))
View(my_df)

### Your Turn (1) - start

# create a new list with the same content of the dataframe (authors and nationalities)
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (1) - end

### 2. Accessing variables

# vector subsets
my_first_vector[1]
my_second_vector[1]
my_second_vector[4]
my_second_vector[1:4]
my_second_vector[c(1,4)]

# list subsets
my_list[[1]]
my_list[[1]][4]
my_list[[2]][4]
my_list[[2]][1:3]

# dataframes
my_df$author 
my_df[,1] # the same!!
my_df$nationality
my_df[,2] # the same!!
my_df$author[1:3]
my_df[1:3,1] # the same!!
my_df[1,]
my_df[3,]

# accessing variables in a meaningful way
my_df$author == "Dante"
which(my_df$author == "Dante")
my_df$nationality[which(my_df$author == "Dante")]

### Your Turn (2) - start

# find the author who has "Spanish" nationality
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (2) - end

### 3. Manipulating variables
my_first_vector+1
my_first_vector[2]+1
my_second_vector+1 # this produces an error!!

# manipulating strings
paste(my_string, "?")
strsplit(my_string, " ")
strsplit(my_string, " ")[[1]]
unlist(strsplit(my_string, " ")) # the same! (in this specific case)

# saving to a new variable (for exploration)
my_third_vector <- unlist(strsplit(my_string, " "))
table(my_third_vector)
sort(table(my_third_vector))
sort(table(my_third_vector), decreasing = T)

### Your Turn (3) - start

# how do I use strsplit() to split a sting into its single characters? Tip (that is valid in any case!): look into the "help" panel on the right
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (3) - end
