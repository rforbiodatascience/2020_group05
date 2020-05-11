library(shiny)
library(tidyverse)
library(keras)

# Define functions --------------------------------------------------------
#source(file = "../R/99_proj_func.R")

# Load model
ANN_model <- load_model_hdf5("../data/07_ANN_model") # HUSKE AT TILFØJE ../ på alle PATHS!!!!! inden du kører APPEN

# Load data ---------------------------------------------------------------
df <- read_tsv(file = "../data/03_aug_data.tsv", 
               col_types = cols(carrier = col_factor()))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    enzymeValues <- reactive({
        
        data.frame(
            Name = c("Creatine Kinase",
                     "Hemopexin",
                     "Puryvate Kinase",
                     "Lactate Dehydroginase"),
            Value = as.character(c(input$ck,
                                   input$h,
                                   input$pk,
                                   input$ld)),
            stringsAsFactors = FALSE)
        
    })
    
    output$values <- renderTable({
        enzymeValues()
    })
    
    User_vector <- reactive({
        
        data.frame(
            CK_feat = as.numeric(input$ck),
            H_feat = as.numeric(input$h),
            PK_feat = as.numeric(input$pk),
            LD_feat = as.numeric(input$ld),
            stringsAsFactors = FALSE) %>% 
            as.matrix
        
    })
    
    
    # ANN ---------------------------------------------------------------
    output$prediction <- renderText({
        
        vector <- User_vector()
        
        paste0("The predicted class number is ", predict_classes(ANN_model, vector, verbose = 1))
    })
    
    # Logistic ---------------------------------------------------------------
    
    
    # Linear ---------------------------------------------------------------
    
    # Distributions ---------------------------------------------------------------
    
    output$distribution_ld <- renderPlot({ 
        df %>% 
            ggplot(aes(LD)) +
            geom_density(fill = "#69b3a2", color="#e9ecef", alpha=0.8) +
            geom_vline(xintercept = input$ld, colour = "red") +
            xlab("Enzyme level (unit ?!)") + 
            ggtitle("Lactate Dehydroginase levels")
    })
})
