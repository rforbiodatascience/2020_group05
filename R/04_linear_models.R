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

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_proj_func.R")


# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv")


# Wrangle data
# ------------------------------------------------------------------------------
# leave one out
data_batch <- loo_cv(data)

#splitting data into Model-data and leave-one-out-datapoint:
data_batch <- data_batch %>%
  mutate(modeldata = map(splits, analysis),
         leaveout = map(splits, assessment))

#Modeling
#-------------------------------------------------------------------------------

#Adding a linear model and the using the holdout to predict
data_batch <- data_batch %>% 
  mutate(simple_model = map(.x = modeldata, .f = simple_model_def),       #Adding simpel model
         log_model = map(.x = modeldata, .f = log_reg_model_def)) %>%  #Adding log model
  mutate(pred_log = map2(log_model, leaveout, predict),
         pred_sim = map2(simple_model, leaveout, predict)) %>%            #Adding prediction from log
  unnest(pred_log, pred_sim, leaveout)                                            #Unpacking dataframes


data_batch <- data_batch %>% 
  pivot_longer(c(log_model, simple_model), names_to = "Model_Type", values_to = "models") %>% 
  pivot_longer(c(pred_log, pred_sim), names_to = "pred_type", values_to = "pred")

#Calculating True-positive rate (TPR) and False-positive rate (FPR)
roc <- data_batch %>% 
  select(pred_type, Model_Type, carrier, pred) %>%
  mutate(Positive = carrier == 1) %>%            #Carrier holds the real information (True/False)
  group_by(pred_type, pred) %>%                            
  summarise(Positive = sum(Positive),            #Turned to integers
            Negative = n() - sum(Positive)) %>% 
  arrange(-pred) %>%
  mutate(TPR = cumsum(Positive) / sum(Positive),
         FPR = cumsum(Negative) / sum(Negative))

#Calculating the area under the curve (AUC)
auc_value <- roc %>% group_by(pred_type) %>% 
  summarise(AUC = sum(diff(FPR) * na.omit(lead(TPR) + TPR)) / 2)
auc_value

#---Calculating Confusion matrix when threshold is 0.5
#Change to binary prediction
data_batch <- data_batch %>%
  mutate(pred_binary = case_when(pred > 0.5 ~ 1, #Change this value!??
                                 pred < 0.5 ~ 0))

#Making values for confusion matrix
data_batch <- data_batch %>% 
  mutate(CM = case_when(pred_binary == 1 & carrier == 1 ~ "TP",
                        pred_binary == 1 & carrier == 0 ~ "FP",
                        pred_binary == 0 & carrier == 1 ~ "FN",
                        pred_binary == 0 & carrier == 0 ~ "TN"))

#summaries results of values in new table
confusion_matrix <- data_batch %>% 
  select(CM) %>% 
  group_by(CM) %>% 
  summarise(freq = n())

#Setting up for visulisation
Actual_values <- factor(c("carrier", "non_carrier", "non_carrier", "carrier"))
Predicted_values <- factor(c("non_carrier", "carrier", "non_carrier", "carrier"))

Y <- confusion_matrix %>% 
  select(freq) %>% 
  unlist(use.names = FALSE)

df <- data.frame(Actual_values, Predicted_values, Y)



# Visualise
# ------------------------------------------------------------------------------
roc_plot <- roc %>% 
  ggplot(aes(FPR, TPR, color = pred_type)) +
  geom_line() +
  theme_bw()+
  labs(title = "ROC plot with logistic regression model", 
       subtitle = str_c("AUC Log model = ", round(auc_value$AUC[1],3), "   ", 
                        "AUC Simple Model = ", round(auc_value$AUC[2], 3)))
roc_plot

confusion_matrix_plot <- df %>% 
  ggplot(mapping = aes(x = Actual_values, y = Predicted_values)) +
    geom_tile(aes(fill = Y), colour = "white") +
    geom_text(aes(label = sprintf("%1.0f", Y))) +
    scale_fill_gradient(low = "lightblue", high = "lightgreen") +
    theme_bw() + 
    theme(legend.position = "none") +
    labs(x = "Actual values", 
         y = "Predicted values", 
         title = "Confusion Matrix of Simple Linear Model",
        subtitle = "Threshold = 0.5")

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/roc_log.png",
       plot = roc_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/confusion_matrix.png",
       plot = confusion_matrix_plot,
       width = 10, 
       height = 6)


