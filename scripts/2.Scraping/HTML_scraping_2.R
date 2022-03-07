# HTML_scraping_2

# call rvest library
library(rvest)

# define the link (here we take "War and Peace" in Goodreads)
my_link <- "https://www.goodreads.com/book/show/656.War_and_Peace"

doc <- read_html(my_link)

full_reviews <- doc %>% html_nodes(xpath = "//div[@class='friendReviews elementListBrown']")

# extended iteration (getting both text, author, and date)
my_reviews <- character()
my_authors <- character()
my_dates <- character()

for(i in 1:length(full_reviews)){
  
  my_reviews[i] <- full_reviews[[i]] %>% html_node(css = "[style='display:none']") %>% html_text() # improved: we get the hidden text
  my_authors[i] <- full_reviews[[i]] %>% html_node(css = "[class='user']") %>% html_text()
  my_dates[i] <- full_reviews[[i]] %>% html_node(css = "[class='reviewDate createdAt right']") %>% html_text()
  
}

my_text <- gsub(pattern = "https://www.goodreads.com/book/show/", replacement = "", my_link, fixed = T)

# save all
my_df <- data.frame(book = my_text, author = my_authors, date = my_dates, review = my_reviews)

write.csv(my_df, file = paste("corpora/Goodreads_", my_text, ".csv", sep = ""))


### Your Turn (1) - start

# try to scrape another title by also adding more info to the dataframe, e.g. the shelves 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (1) - end