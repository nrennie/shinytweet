# Define server logic  ----

# read in data
likes <- readRDS('likes.rds')

server <- function(input, output) {
  
  output$table_output = reactable::renderReactable({
    table_df <- likes %>% 
      select(created_at, user, full_text, tweet_link, content_url) %>% 
      rename(Date = created_at, 
             User = user,
             Tweet = full_text, 
             URL = tweet_link,
             Link = content_url) %>% 
      mutate(Date = rtweet:::format_date(Date), 
             Date = as.Date(Date))
    reactable::reactable(table_df,
                         columns = list(
                           Date = colDef(align = "center",
                                         minWidth = 60),
                           User = colDef(cell = function(User) {
                             htmltools::tags$a(href = paste0("https://twitter.com/", as.character(User)),
                                               target = "_blank", paste0("@",User))
                           }),
                           Tweet = colDef(align = "left",
                                         minWidth = 100),
                           URL = colDef(cell = function(URL) {
                             htmltools::tags$a(href = as.character(URL),
                                               target = "_blank", as.character(URL))
                           }),
                           Link = colDef(cell = function(Link) {
                             htmltools::tags$a(href = as.character(Link),
                                               target = "_blank", as.character(Link))
                           })),
                         striped = TRUE,
                         defaultPageSize = 8)
  })
  
}
