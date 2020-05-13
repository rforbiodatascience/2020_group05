library(shiny)
library(tidyverse)
library(keras)
library(patchwork)


# Load data ---------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", 
               col_types = cols(carrier = col_factor()))

# Load models
ANN_model <- load_model_hdf5("data/07_ANN_model.hdf5")

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
    output$prediction_ann <- renderText({
        
        vector_input <- User_vector()
        
        class_predicted_ann <- predict_classes(ANN_model, vector_input, verbose = 1) 
        
        #probability_ann <- predict_proba(ANN_model, vector_input, verbose = 1)
        
        if (class_predicted_ann == 0) { 
        paste("Congratulations, you've been classified as a non-carrier :)")
        }
        else {
        paste("You've been classified as a carrier :(")
        }
    })
    
    
    # Logistic model ---------------------------------------------------------------
    
    output$prediction_log <- renderText({
    
        vector_input <- User_vector() %>% 
            as.tibble() %>% rename(CK = CK_feat,
                                   PK = PK_feat,
                                   LD = LD_feat,
                                   H = H_feat)
        
        log_model <- glm(carrier ~ PK + LD + H + CK, 
                         family = binomial(link = "logit"), 
                         data = df)
        
        class_predicted_log <- predict(log_model, vector_input, type = "response")
        
        if (class_predicted_log <= 0.500) { 
            paste("Congratulations, you've been classified as a non-carrier :)")
        }
        else {
            paste("You've been classified as a carrier :(")
        }
    
    })
    # Linear model ---------------------------------------------------------------
    
    output$prediction_lm <- renderText({
        
        vector_input <- User_vector() %>% 
            as.tibble() %>% rename(CK = CK_feat,
                                   PK = PK_feat,
                                   LD = LD_feat,
                                   H = H_feat)
        
        lm_model <- lm(carrier ~ LD + H + PK + CK,
                       data = df)
        
        class_predicted_lm <- predict(lm_model, vector_input, type = "response")
        
        if (class_predicted_lm <= 0.17) { 
            paste("Congratulations, you've been classified as a non-carrier :)")
        }
        else {
            paste("You've been classified as a carrier :(")
        }
        
    })
    # Distributions ---------------------------------------------------------------
    
    output$distributions <- renderPlot({
    
    dist_ld <- df %>% 
        ggplot(aes(LD, fill = carrier)) +
        geom_density(alpha=0.8) +
        geom_vline(xintercept = input$ld, colour = "red") +
        xlab("Enzyme level") + 
        ggtitle("Lactate Dehydroginase levels")
    
    dist_h <- df %>% 
        ggplot(aes(H, fill = carrier)) +
        geom_density(alpha=0.8) +
        geom_vline(xintercept = input$h, colour = "red") +
        xlab("Enzyme level") + 
        ggtitle("Hexopexin levels")
    
    dist_ck <- df %>% 
        filter(CK <= 300) %>% 
            ggplot(aes(CK, fill = carrier)) +
            geom_density(alpha=0.8) +
            geom_vline(xintercept = input$ck, colour = "red") +
            xlab("Enzyme level") + 
            ggtitle("Creatine Kinase levels")
        
    dist_pk <- df %>% 
        filter(PK <= 60) %>% 
            ggplot(aes(PK, fill = carrier)) +
            geom_density(alpha=0.8) +
            geom_vline(xintercept = input$pk, colour = "red") +
            xlab("Enzyme level") + 
            ggtitle("Pyruvate Kinase levels")
        
        ((dist_ck/dist_h) | (dist_pk/dist_ld)) + 
        plot_annotation(title = "Density plot of enzyme levels", 
                        caption = "Filtered CK levels <= 300. Filtered PK levels <= 60") +
        plot_layout(guides = "collect") + 
        theme(legend.position = "right")
    })
    
})

