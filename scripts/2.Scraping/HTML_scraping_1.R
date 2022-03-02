# HTML_scraping_1

# install rvest
install.packages("rvest") # remember, this should be done just once!!!

# call rvest library
library(rvest)

# define the link (here we take "War and Peace" in Goodreads)
my_link <- "https://www.goodreads.com/book/show/656.War_and_Peace"

# read the html to an R variable
doc <- read_html(my_link)

# then find the element in the HTML that identifies the reviews
doc %>% html_nodes(xpath = "//div[@class='friendReviews elementListBrown']")
# tip: you can use F12 in your browser to see the structure of the page
# you need to use Xpath expressions to find the relevant nodes
# info: https://www.w3schools.com/xml/xpath_syntax.asp

# once verified that it works, you can save it to a variable
full_reviews <- doc %>% html_nodes(xpath = "//div[@class='friendReviews elementListBrown']")

# ...and iterate on it to extract (for example) just the text of the reviews
my_reviews <- character()

for(i in 1:length(full_reviews)){
  
  my_reviews[i] <- full_reviews[[i]] %>% html_node(css = "[class='reviewText stacked']") %>% html_text()
  # note: to iterate inside of HTML nodes, we need to use a different syntax, CSS selector
  # info: https://www.w3schools.com/cssref/css_selectors.asp
  
}

# then we can explore the result!
my_reviews[1] # first review
my_reviews[7] # seventh review
# etc...


### Your Turn (1) - start

# repeat the same procedure of above, but extract a different info from the reviews, i.e. the author names 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (1) - end