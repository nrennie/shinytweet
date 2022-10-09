library(rtweet)
library(dplyr)
library(tibble)
library(stringr)
library(readr)

# function to grab new data
new_data <- function(n = 30) {
  # define parameters
  username <- "nrennie35"
  words_to_keep <- c("rstats", " r ", "rstudio", "tidyverse", 
                     "python", "shiny", "ggplot2", 
                     "tableau", "rladies", "dataviz", "vizualisation", 
                     "visualisation")
  url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  
  # get likes data from twitter
  likes <- get_favorites(username, n = n)
  
  # add user data
  users <- users_data(likes)
  likes$user <- users$screen_name
  likes <- as_tibble(likes)
  
  # data wrangling
  likes <- likes %>% 
    mutate(lower_text = tolower(full_text)) %>%
    filter(str_detect(lower_text, str_c(words_to_keep, collapse = "|"))) %>% 
    mutate(content_url = str_extract(full_text, url_pattern)) %>%
    filter(nchar(content_url) > 0) %>% 
    mutate(url = paste0("<a href='", content_url, "' target='_blank'>", "LINK", "</a>")) %>% 
    mutate(tweet_link = paste0("https://twitter.com/", user, "/status/", id_str), 
           user_link = paste0("https://twitter.com/", user))
  
  # more data wrangling for table
  likes <- likes %>% 
  select(created_at, user, full_text, tweet_link, content_url) %>% 
    rename(Date = created_at, 
           User = user,
           Tweet = full_text, 
           URL = tweet_link,
           Link = content_url) %>% 
    mutate(Date = rtweet:::format_date(Date), 
           Date = as.Date(Date))
  
  # return data
  return(likes)
}

# authenticate
my_app <- rtweet_app(bearer_token = Sys.getenv("BEARER", unset = NA))
auth_as(my_app)

# function to update data set
update_data <- function(since_id) {
  new_data_df <- new_data()
  likes <- readr::read_rds('likes.rds')
  likes <- rbind(new_data_df, likes)
  likes <- distinct(likes)
  readr::write_rds(likes, 'likes.rds')
}

# run update
update_data()
