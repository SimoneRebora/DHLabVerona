# HTML_scraping_3
# Archive of Our Own (https://archiveofourown.org)

library(rvest)

# define fandom page
fandom_page <- "https://archiveofourown.org/tags/Sherlock%20Holmes%20*a*%20Related%20Fandoms/works"

# define pages for links retrieval (generally there are 20 works per page)
save_steps <- 10

# create list of pages
all_pages <- paste(fandom_page, "?page=", sep = "")
all_pages <- paste(all_pages, 1:save_steps, sep = "")

# initialize variables to save results
title <- character()
author <- character()
link <- character()

# Main iteration starts
for(i in 1:save_steps){
  
  print(i)
  my_tmp_link <- all_pages[i]
  
  # encode links for special characters
  my_tmp_link <- URLencode(my_tmp_link)
  my_tmp_link <- gsub(pattern = "+", replacement = "%20", my_tmp_link, fixed = T)
  
  # read page  
  my_page <- read_html(my_tmp_link)
  
  # get works
  works <- my_page %>% html_nodes(xpath = "//ol[@class = 'work index group']/li")
  
  # extract results from each work (generally 20 works)
  for(work_n in 1:length(works)){
    
    # heading (i.e. title and author)
    headings_tmp <- works[[work_n]] %>% html_nodes("h4") %>% html_nodes("a") %>% html_text()
    title <- c(title, headings_tmp[1])
    author <- c(author, headings_tmp[2])
    
    # link to work
    link_tmp <- works[[work_n]] %>% html_nodes("h4") %>% html_nodes("a") %>% html_attrs()
    link <- c(link, link_tmp[[1]])
  
  }
  
  # wait a bit (very important!!! When you do iterative scraping always add pauses)
  Sys.sleep(5)
  
}

my_df <- data.frame(author, title, link, stringsAsFactors = F)

# once collected the links, let's scrape the texts

all_work_links <- paste("https://archiveofourown.org", my_df$link, "?view_adult=true&view_full_work=true", sep = "")

all_texts <- character()

for(i in 1:length(all_work_links)){
  
  print(i)
  
  my_tag_page <- read_html(all_work_links[i])
  
  my_text <- my_tag_page %>% html_nodes(xpath = "//div[@id = 'chapters']//div/p")
  my_text <- my_text %>% html_text()
  
  all_texts[i] <- paste(my_text, collapse = "\n")
  
  Sys.sleep(5)
  
}

# add length (in words)
my_df$length <- lengths(strsplit(all_texts, "\\W"))

# add incipit
my_df$incipit <- substr(all_texts, 1, 100)

# save all
save(my_df, all_texts, file = "corpora/AO3_corpus.RData")



### Your Turn (1) - start

# try to scrape another fandom by also adding more info to the dataframe, e.g. the likes (kudos) 
# please write the code immediately down here (in the empty space) 
# save the file, and then push to the GitHub repo 



### Your Turn (1) - end