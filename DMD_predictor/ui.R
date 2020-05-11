# Load libraries
library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        
        # App title ----
        titlePanel("DMD predictor"),
        
        # Sidebar layout with input and output definitions ----
        sidebarLayout(
            
            # Sidebar panel for inputs ----
            sidebarPanel(
                
                # Input: Selector for choosing dataset ----
                radioButtons(inputId = "models",
                             label = "Choose a model:",
                             choices = c("Linear", "Logistic", "ANN")),
                
                sliderInput(inputId = "ck", 
                            label = "Creatine Kinase (CK)", 
                            value = 650, min = 0, max = 1300),
                
                sliderInput(inputId = "h", 
                            label = "Hemopexin (H)", 
                            value = 60, min = 0, max = 120),
                
                sliderInput(inputId = "pk", 
                            label = "Pyruvate Kinase (PK)", 
                            value = 55, min = 0, max = 110),
                
                # Input: Numeric entry for number of obs to view ----
                sliderInput(inputId = "ld", 
                            label = "Lactate Dehydroginase (LD)", 
                            value = 225, min = 0, max = 450),
                
                # Include clarifying text ----
                helpText("Note: while the data view will show only the specified",
                         "number of observations, the summary will still be based",
                         "on the full dataset."),
                
                # Input: actionButton() to defer the rendering of output ----
                # until the user explicitly clicks the button (rather than
                # doing it immediately when inputs change). This is useful if
                # the computations required to render output are inordinately
                # time-consuming.
                actionButton("update", "Update View")
                
            ),
            
            # Main panel for displaying outputs ----
            mainPanel(
                
                # Output: Formatted text for caption ----
                tableOutput("values"),
                
                verbatimTextOutput("vector"),
                
                verbatimTextOutput("results"),
                
                textOutput("prediction")
            )    
        )
        
    )
)