library(shiny)
library(dplyr)
library(reactable)
library(bslib)
library(htmltools)
library(lubridate)

# Define UI for app that draws a histogram ----
ui <- ui <- navbarPage(

  title = "{shinytweet}",
  
  theme = bs_theme(version = 4,
                   bootswatch = "minty", 
                   primary = "#12a79d"),
  
  position = "static-top",
  
  tabPanel("My Favourite Tweets",
      reactable::reactableOutput("table_output")
  )
      
)