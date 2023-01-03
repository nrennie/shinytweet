library(rtweet)
library(dplyr)
library(stringr)
library(tibble)

# function to grab original data from twitter

start_data <- function(n = 3000) {
  # define parameters
  username <- "nrennie35"
  words_to_keep <- c("rstats", " r ", "rstudio", "tidyverse", 
                     "python", "shiny", "ggplot2", 
                     "tableau", "rladies", "dataviz", "vizualisation", 
                     "visualisation")
  
  # get likes
  likes <- get_favorites(username, n = n)
  
  # get users data
  users <- users_data(likes)
  likes$user <- users$screen_name
  likes$protected <- users$protected
  likes <- as_tibble(likes)
  
  # get urls
  entity <- likes$entities
  urls <- lapply(seq_len(length(entity)), function(x) entity[[x]]$urls$expanded_url[1])
  likes$content_url <- urls
  
  # data wrangling to filter likes
  likes <- likes %>% 
    filter(protected == FALSE) %>%
    mutate(lower_text = tolower(full_text)) %>%
    filter(str_detect(lower_text, str_c(words_to_keep, collapse = "|"))) %>% 
    filter(!is.na(content_url)) %>% 
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
  
  # save file
  readr::write_rds(likes, 'likes.rds')
}
