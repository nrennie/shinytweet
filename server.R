# read in data
likes <- readRDS('likes.rds')

# Define server logic  ----
server <- function(input, output) {
  
  output$table_output = reactable::renderReactable({
    
    # data wrangling for table
    table_df <- likes %>% 
      select(created_at, user, full_text, tweet_link, content_url) %>% 
      rename(Date = created_at, 
             User = user,
             Tweet = full_text, 
             URL = tweet_link,
             Link = content_url) %>% 
      mutate(Date = rtweet:::format_date(Date), 
             Date = as.Date(Date))
    
    # create table
    reactable::reactable(table_df,
                         columns = list(
                           # define date
                           Date = colDef(
                             align = "center",
                             minWidth = 60),
                           # define user
                           User = colDef(
                             cell = function(User) {
                               htmltools::tags$a(href = paste0("https://twitter.com/", as.character(User)),
                                                 target = "_blank", paste0("@",User))},
                             minWidth = 60),
                           # define tweet text
                           Tweet = colDef(
                             align = "left",
                             minWidth = 120),
                           # define tweet url
                           URL = colDef(
                             cell = function(URL) {
                               htmltools::tags$a(href = as.character(URL),
                                                 target = "_blank", as.character(URL))}),
                           # define external link
                           Link = colDef(
                             cell = function(Link) {
                               htmltools::tags$a(href = as.character(Link),
                                                 target = "_blank", as.character(Link))})
                           ),
                         # additional table options
                         striped = TRUE,
                         defaultPageSize = 8)
  })
}
