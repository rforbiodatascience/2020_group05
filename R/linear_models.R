# LINEAR MODELS AND SO ON!!!!!!
# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("broom")
library("rsample")
library("purrr")
library("tidymodels")
#install.packages("rsample")
#install.packages("tidymodels")

# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv")


# Wrangle data
# ------------------------------------------------------------------------------
# leave one out
data_batch <- loo_cv(data)
#data_batch <- vfold_cv(data, v = 194, repeats =1)
#View(data_batch)


#Modeling
#-------------------------------------------------------------------------------
#Simpel linear model - no subcategorising 
simple_model <- lm(carrier ~ LD + H + PK + CK, data = data)
log_reg_model <- glm(carrier ~ PK + LD + H + CK, 
                     family = binomial(link = "logit"), 
                     data = data)
simple_model_def <- function(df) {
  lm(carrier ~ LD + H + PK + CK, data = data)}

#------------------
#splitting data into Model-data and Holdout-datapoint:
data_batch <- data_batch %>%
  mutate(modeldata = map(splits, analysis),
         holdout = map(splits, assessment))

#Adding a linear model and the using the holdout to predict
data_batch <- data_batch %>% 
  mutate(models = map(modeldata, simple_model_def))
#View(data_batch$model)

library("caret")
data_batch <- data_batch %>% 
  mutate(predicted_value = map_dbl(models, 1:194, ~predict(newdata = holdout)))
View(data_batch$predicted_value)
View(data_batch)
#data_batch %>% tidy()







#------------------------------------------------------------------------
#----Notes from Leon
#coefficients for the models
simple_model %>% tidy()
# only intercept, LD and H 

log_reg_model %>% tidy()
# only intercept, H and CK

# brug den her function på en eller anden maade
predict(simple_model, newdata = data_batch())

#-----A single sample: 
model_1 <- data_batch$splits[[1]] %>% analysis()

hold_out_1 <- data_batch$splits[[1]] %>% assessment()

data_with_model <- lm(carrier ~ LD + H + PK + CK, data = model_1)
View(data_with_model)
predict(object = data_with_model, newdata = hold_out_1)
pred <- data_with_model %>% predict(newdata = hold_out_1)
pred
