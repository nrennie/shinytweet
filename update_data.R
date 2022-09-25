# function to grab new data
new_data <- function(since_id, n = Inf) {
  username <- "nrennie35"
  words_to_keep <- c("rstats", " r ", "rstudio", "tidyverse", 
                     "python", "shiny", "ggplot2", 
                     "tableau", "rladies", "dataviz", "vizualisation", 
                     "visualisation")
  url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  likes <- get_favorites(username, since_id = since_id, n = n, parse = FALSE) 
  likes <- likes[[1]][[1]][c("created_at", "full_text", "user", "id_str")]
  likes$user <- likes$user$screen_name
  likes <- as_tibble(likes)
  likes <- likes %>% 
    mutate(lower_text = tolower(full_text)) %>%
    filter(str_detect(lower_text, str_c(words_to_keep, collapse = '|'))) %>% 
    mutate(content_url = str_extract(full_text, url_pattern)) %>%
    filter(nchar(content_url) > 0) %>% 
    mutate(url = paste0("<a href='", content_url,"' target='_blank'>","LINK","</a>")) %>% 
    mutate(tweet_link = paste0("https://twitter.com/", user, "/status/", id_str), 
           user_link = paste0("https://twitter.com/", user))
  return(likes)
}

# function to update data set
update_data <- function(since_id) {
  new_data_df <- new_data(since_id = since_id)
  likes <- rbind(likes, new_data_df)
  write_rds(likes, 'likes.rds')
}

likes <- readRDS('likes.rds')
update_data(since_id = likes$created_at[1])