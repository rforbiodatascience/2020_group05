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
                helpText("Below you should fill in your respective values."),
                
                # Input: Selector for choosing dataset ----
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
                
                tabsetPanel(type = "tabs",
                            tabPanel("Artificial Neural Network", 
                                     verbatimTextOutput("prediction_ann")),
                            tabPanel("Logistic Classification", 
                                     verbatimTextOutput("prediction_log")),
                            tabPanel("Linear Classification", 
                                     verbatimTextOutput("prediction_lm"))
                ),
                
                br(),
                
                p("These density plots visualize the distribution",
                  "of the enzyme levels among carrier/non-carrier",
                  "in the data set used to train the model.",
                  "From this you can see if your own levels",
                  "(marked with the red vertical line) are clearly",
                  "in one group or if they are in the cross-section",
                  "where the results might be inconclusive."),
                
                # Output: Formatted text for caption ----
                #h5(textOutput("prediction_ann")),
                
                #br(), br(),
                
                #textOutput("probabilities"),
                
                br(), br(),
                
                plotOutput("distributions")
                
                #textOutput("prediction_lm"),
                
                #br(), br(),
                
                #textOutput("prediction_log")
            )    
        )
        
    )
)