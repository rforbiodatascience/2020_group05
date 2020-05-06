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
         leaveout = map(splits, assessment))

#Adding a linear model and the using the holdout to predict
data_batch <- data_batch %>% 
  mutate(models = map(.x = modeldata, .f = simple_model_def))
View(data_batch$leaveout)

data_batch <- data_batch %>% 
  mutate(pred = map2(models, leaveout, predict))

data_batch <- data_batch %>%
  mutate(pred_binary = case_when(pred > 0.5 ~ 1,
                                 pred < 0.5 ~ 0))

data_batch2 <- data_batch %>% 
  unnest(leaveout)

#confusionmatrix
data_batch2 <- data_batch2 %>% 
  mutate(CM = case_when(pred_binary == 1 & carrier == 1 ~ "TP",
                        pred_binary == 1 & carrier == 0 ~ "FP",
                        pred_binary == 0 & carrier == 1 ~ "FN",
                        pred_binary == 0 & carrier == 0 ~ "TN"))

#make confusion matrix
confusion_matrix <- data_batch2 %>% 
  select(CM) %>% 
  group_by(CM) %>% 
  summarise(freq = n())

View(confusion_matrix) 

Actual_values <- factor(c("non_carrier", "non_carrier", "carrier", "carrier"))
Predicted_values <- factor(c("non_carrier", "carrier", "non_carrier", "carrier"))
Y <- c(44,7,23,120) #LOOK AT THIS LATER!!!!!!!

df <- data.frame(Actual_values, Predicted_values, Y)
ggplot(data =  df, mapping = aes(x = Actual_values, y = Predicted_values)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y)), vjust = 1) +
  scale_fill_gradient(low = "lightblue", high = "lightgreen") +
  theme_bw() + theme(legend.position = "none") +
  labs(x = "Actual values", y = "Predicted values", 
       title = "Confusion Matrix of Simple Linear Model")

#AUC/ROC
#TPR = TP / (TP + FN)
#FPR = TN / (TN + FP)

#calculation of conditional true = carrier status to find TPR/FPR
roc <- data_batch2 %>% 
  select(CM, carrier) %>% 
  mutate(TPR = cumsum(carrier) / sum(carrier),
         FPR = cumsum(!carrier) / sum(!carrier))

roc <- data_batch2 %>% 
  select(CM) %>% 
  filter(CM == "TP") %>% 
  summarise()

View(roc)

roc %>% 
  ggplot(aes( x = FPR, y = TPR)) +
  geom_line() +
  geom_abline(lty = 2) +
  xlab("False positive rate (1-specificity)") + 
  ylab("True positive rate (sensitivity)") +
  ggtitle("ROC")











#roc <- pivot_wider(confusion_matrix, names_from = CM, values_from = freq) %>% 
  #mutate(TPR = TP / (TP + FN),
         #FPR = TN / (TN + FP))

roc %>% 
  ggplot(aes( x = FPR, y = TPR)) +
  geom_line() +
  geom_abline(lty = 2) +
  xlab("False positive rate (1-specificity)") + 
  ylab("True positive rate (sensitivity)") +
  ggtitle("ROC")
