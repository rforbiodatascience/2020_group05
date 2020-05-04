# LINEAR MODELS AND SO ON!!!!!!
# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("broom")
library("rsample")
library("tidymodels")
#install.packages("rsample")
#install.packages("tidymodels")

# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv")
View(data)

# Wrangle data
# ------------------------------------------------------------------------------
# leave one out
data_batch <- loo_cv(data)
View(data_batch)
#Modeling
#-------------------------------------------------------------------------------
#Simpel linear model - no subcategorising 
simple_model <- lm(carrier ~ LD + H + PK + CK, data = data)
log_reg_model <- glm(carrier ~ PK + LD + H + CK, 
                     family = binomial(link = "logit"), 
                     data = data)

#coefficients for the models
simple_model %>% tidy()
# only intercept, LD and H 

log_reg_model %>% tidy()
# only intercept, H and CK

# brug den her function på en eller anden maade
predict(simple_model, newdata = data_batch())

