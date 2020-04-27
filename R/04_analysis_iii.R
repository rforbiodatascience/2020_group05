# Neural network

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("keras")
library("caret")
library("MASS")

# Define functions
# ------------------------------------------------------------------------------


# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv") #possibly change to aug data?

# Wrangle data
# ------------------------------------------------------------------------------
data <- data %>% 
        mutate_at(vars(carrier), as_factor) %>% 
        drop_na()

TrainData <- data %>% 
            select(CK, H, PK, LD)

TrainClasses <- data %>% 
                select(carrier) %>% 
                unlist()

# Creating models
# ------------------------------------------------------------------------------
# K NEAREST NEIGHRBOOR
knnFit <- train(TrainData, TrainClasses,
                method = "knn",
                preProcess = c("center", "scale"),
                trControl = trainControl(method = "LOOCV"))
print(knnFit)

# ANN
nnetFit <- train(TrainData, TrainClasses,
                 method = "nnet",
                 preProcess = "range",
                 trControl = trainControl(method = "LOOCV"))
print(nnetFit)


