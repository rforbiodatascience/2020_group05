#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load libraries
library(shiny)
library(tidyverse)
library(keras)

# Load dataframe + model
ANN_model <- load_model_hdf5("../data/04_ANN_model")

summary(ANN_model)

x <- c(0.029065200, 0.5892857, 0.075559701, 0.29569892)

x_shiny <- matrix(x, nrow = 1, ncol = 4)
#colnames(x_shiny) <- c("CK_feat", "H_feat", "PK_feat", "LD_feat")

x_shiny


# ANN prediction --------------------------------------------
prediction_ANN <- ANN_model %>% 
    predict_classes(x_shiny)

prediction_ANN


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # App title ----
    titlePanel("DMD predictor"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Text for providing a caption ----
            # Note: Changes made to the caption in the textInput control
            # are updated in the output area immediately as you type
            textInput(inputId = "caption",
                      label = "Caption:",
                      value = "Data Summary"),
            
            # Input: Selector for choosing dataset ----
            selectInput(inputId = "dataset",
                        label = "Choose a dataset:",
                        choices = c("rock", "pressure", "cars")),
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "obs",
                         label = "Number of observations to view:",
                         value = 10),
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "pk", 
                         label = "Pyruvate Kinase (PK)", 
                         value = 0-110, min = 0, max = 110),
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "ck", 
                         label = "Creatine Kinase (CK)", 
                         value = 0, min = 0, max = 1300),
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "h", 
                         label = "Hemopexin (H)", 
                         value = 0, min = 0, max = 120),
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "ld", 
                         label = "Lactate Dehydroginase (LD)", 
                         value = 0, min = 0, max = 450)
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Formatted text for caption ----
            h3(textOutput("caption", container = span)),
            
            # Output: Verbatim text for data summary ----
            verbatimTextOutput("summary"),
            
            # Output: HTML table with requested number of observations ----
            tableOutput("view")
                
            )
        )
    )
)