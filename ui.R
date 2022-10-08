# load packages for shiny app
library(shiny)
library(dplyr)
library(reactable)
library(bslib)
library(htmltools)
library(lubridate)

# Define UI ----
ui <- navbarPage(

  # define title
  title = "{shinytweet}",
  
  # add theme
  theme = bs_theme(version = 4,
                   bootswatch = "minty", 
                   primary = "#12a79d"),
  
  # add in table
  tabPanel("Favourite Tweets", reactable::reactableOutput("table_output"))
      
)