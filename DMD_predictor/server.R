library(shiny)
library(tidyverse)
library(keras)
library(patchwork)

# Define functions --------------------------------------------------------
source(file = "../R/99_proj_func.R")

# Load model
ANN_model <- load_model_hdf5("../data/07_ANN_model") # HUSKE AT TILFØJE ../ på alle PATHS!!!!! inden du kører APPEN

# Load data ---------------------------------------------------------------
df <- read_tsv(file = "../data/03_aug_data.tsv", 
               col_types = cols(carrier = col_factor()))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
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
        
        
        
        class_predicted <- predict_classes(ANN_model, vector, verbose = 1) 
        
        if (class_predicted == 0) { 
        paste0("Congratulations, you've been classified as a non-carrier :)")
        }
        else {
        paste0("You've been classified as a carrier. :(")
        }
    })
    
    output$probabilities <- renderText({
        
        vector <- User_vector()
        
        probability_ann <- predict_proba(ANN_model, vector, verbose = 1)
        
        paste0("The classification is based on this probability: ", 
               round(probability_ann[1], digits = 3))
    })
    
    # Logistic ---------------------------------------------------------------
    
    
    
    # Linear ---------------------------------------------------------------
    
    # Distributions ---------------------------------------------------------------
    
    output$distributions <- renderPlot({
    
    dist_ld <- df %>% 
        ggplot(aes(LD, fill = carrier)) +
        geom_density(alpha=0.8) +
        geom_vline(xintercept = input$ld, colour = "red") +
        xlab("Enzyme level (unit ?!)") + 
        ggtitle("Lactate Dehydroginase levels")
    
    dist_h <- df %>% 
        ggplot(aes(H, fill = carrier)) +
        geom_density(alpha=0.8) +
        geom_vline(xintercept = input$h, colour = "red") +
        xlab("Enzyme level (unit ?!)") + 
        ggtitle("Hexopexin levels")
    
    dist_ck <- df %>% 
        filter(CK <= 150) %>% 
            ggplot(aes(CK, fill = carrier)) +
            geom_density(alpha=0.8) +
            geom_vline(xintercept = input$ck, colour = "red") +
            xlab("Enzyme level (unit ?!)") + 
            ggtitle("Creatine Kinase levels")
        
    dist_pk <- df %>% 
        filter(PK <= 60) %>% 
            ggplot(aes(PK, fill = carrier)) +
            geom_density(alpha=0.8) +
            geom_vline(xintercept = input$pk, colour = "red") +
            xlab("Enzyme level (unit ?!)") + 
            ggtitle("Pyruvate Kinase levels")
        
        ((dist_ck/dist_h) | (dist_pk/dist_ld)) + 
        plot_annotation(title = "Density plot of enzyme levels", 
                        caption = "Filtered CK levels <= 150. Filtered PK levels <= 60") +
        plot_layout(guides = "collect") & 
        theme(legend.position = "right")
    })
})
