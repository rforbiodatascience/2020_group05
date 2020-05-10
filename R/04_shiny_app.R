# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("shiny")
library("keras")

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_proj_func.R")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", col_types = cols(carrier = col_factor()))
ann_model <- load_model_hdf5("data/04_ANN_model")

# App
# ------------------------------------------------------------------------------
ui <- fluidPage(
  headerPanel("Welcome to Duchenne muscular dystrophy carrier status predictor"),
  sidebarLayout(
    textOutput("guide"),
    sidebarPanel(
    numericInput("pk", "Pyruvate Kinase (PK)", value = 0, min = 0, max = 110),
    numericInput("ck", "Creatine Kinase (CK)", value = 0, min = 0, max = 1300),
    numericInput("h", "Hemopexin (H)", value = 0, min = 0, max = 120),
    numericInput("ld", "Lactate Dehydroginase (LD)", value = 0, min = 0, max = 450)
  )),
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

#ld_value <- 200
#ld <- data %>% 
#  ggplot(mapping = aes(x = LD, fill = carrier, alpha = 0.5)) +
#  geom_density() + 
#  geom_vline(xintercept = ld_value)
#  labs(title = "Distribution of Age and Carrier")
