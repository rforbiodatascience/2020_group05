# Load libraries
library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(theme = shinytheme("flatly"),
        #shinythemes::themeSelector(),
        # App title ----
        titlePanel("DMD predictor"),
        
        # Sidebar layout with input and output definitions ----
        sidebarLayout(
            
            # Sidebar panel for inputs ----
            sidebarPanel(
                
                # Include clarifying text ----
                helpText("Below you should fill in your respective values.",
                         "You can switch back and forth between the models"),
                
                # Input: Selector for choosing dataset ----
                radioButtons(inputId = "models",
                             label = "Choose a model:",
                             choices = c( "ANN", "Linear", "Logistic")),
                
                sliderInput(inputId = "ck", 
                            label = "Creatine Kinase (CK)", 
                            value = 25, min = 0, max = 150), # Meget høj MAX-værdi --- muligvis outlier
                
                sliderInput(inputId = "h", 
                            label = "Hemopexin (H)", 
                            value = 80, min = 0, max = 120),
                
                sliderInput(inputId = "pk", 
                            label = "Pyruvate Kinase (PK)", 
                            value = 10, min = 0, max = 50),
                
                # Input: Numeric entry for number of obs to view ----
                sliderInput(inputId = "ld", 
                            label = "Lactate Dehydroginase (LD)", 
                            value = 150, min = 0, max = 450)
                
            ),
            
            # Main panel for displaying outputs ----
            mainPanel(
                
                # Output: Formatted text for caption ----
                h3(textOutput("prediction_ann")),
                
                br(), br(),
                
                textOutput("probabilities"),
                
                br(), br(),
                
                plotOutput("distributions"),
                
                br(), br(),
                
                textOutput("prediction_lm"),
                
                br(), br(),
                
                textOutput("prediction_log")
            )    
        )
        
    )
)