# load packages for shiny app
library(shiny)
library(dplyr)
library(reactable)
library(bslib)
library(htmltools)
library(lubridate)

# read in data
load(url("https://raw.githubusercontent.com/nrennie/shinytweet/main/likes.RData"))

# UI ----------------------------------------------------------------------

# Define UI ----
ui <- navbarPage(
  # define title
  title = "shinytweet",

  # add theme
  theme = bs_theme(
    version = 4,
    bootswatch = "minty",
    primary = "#12a79d"
  ),
  # add warning
  tags$div(
    style = "border: 1px solid #e6a700; background-color: #fff4cc; color: #5c4400; padding: 12px; border-radius: 4px; margin-bottom: 10px;",
    tags$strong("Warning: "),
    "Due to changes in the Twitter API, this app is no longer updated. Some of the links may be broken."
  ),
  # add in table
  tabPanel("Favourite Tweets", reactable::reactableOutput("table_output"))
)


# Define server logic  ----
server <- function(input, output) {
  output$table_output <- reactable::renderReactable({
    # create table
    reactable::reactable(likes,
      columns = list(
        # define date
        Date = colDef(
          align = "center",
          minWidth = 60
        ),
        # define user
        User = colDef(
          cell = function(User) {
            htmltools::tags$a(
              href = paste0("https://twitter.com/", as.character(User)),
              target = "_blank", paste0("@", User)
            )
          },
          minWidth = 60
        ),
        # define tweet text
        Tweet = colDef(
          align = "left",
          minWidth = 120
        ),
        # define tweet url
        URL = colDef(
          cell = function(URL) {
            htmltools::tags$a(
              href = as.character(URL),
              target = "_blank", as.character(URL)
            )
          }
        ),
        # define external link
        Link = colDef(
          cell = function(Link) {
            htmltools::tags$a(
              href = as.character(Link),
              target = "_blank", as.character(Link)
            )
          }
        )
      ),
      # additional table options
      searchable = TRUE,
      striped = TRUE,
      defaultPageSize = 8
    )
  })
}


# Run app -----------------------------------------------------------------


shinyApp(ui = ui, server = server)
