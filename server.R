# read in data
likes <- readRDS('likes.rds')

# Define server logic  ----
server <- function(input, output) {
  
  output$table_output = reactable::renderReactable({
    
    # create table
    reactable::reactable(likes,
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
