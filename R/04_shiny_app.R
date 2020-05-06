# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("shiny")

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_proj_func.R")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", col_types = cols(carrier = col_factor()))

# App
# ------------------------------------------------------------------------------
ui <- fluidPage(
  headerPanel("Welcome to Duchenne muscular dystrophy carrier status predictor"),
  sidebarPanel(
    textOutput("guide")
    numericInput("pk", "Pyruvate Kinase (PK)", value = 0, min = 0, max = 110),
    numericInput("ck", "Creatine Kinase (CK)", value = 0, min = 0, max = 1300),
    numericInput("h", "Hemopexin (H)", value = 0, min = 0, max = 120),
    numericInput("ld", "Lactate Dehydroginase (LD)", value = 0, min = 0, max = 450)
  ),
  mainPanel(textOutput("result")
  )
)

server <- function(input, output) {
    output$guide <- renderText({
      paste("Enter the enzyme levels below")
    })
    output$result <- renderText({
      paste("Your carrier status:", input$number)
    })
  }
shinyApp(ui, server)
