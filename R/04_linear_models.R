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
log_reg_model_def <- function(df) {
  glm(carrier ~ PK + LD + H + CK, 
      family = binomial(link = "logit"), 
      data = data)}

#obs - this is not used: 
simple_model_def <- function(df) {
  lm(carrier ~ LD + H + PK + CK,
     data = data)}


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
  mutate(models = map(.x = modeldata, .f = log_reg_model_def)) %>%  #Adding model
  mutate(pred = map2(models, leaveout, predict)) %>%                #Adding prediction
  unnest(pred, leaveout)                                            #Unpacking dataframes

#Calculating True-positive rate (TPR) and False-positive rate (FPR)
roc <- data_batch %>% 
  select(carrier, pred) %>%
  mutate(Positive = carrier == 1) %>%            #Carrier holds the real information (True/False)
  group_by(pred) %>%                            
  summarise(Positive = sum(Positive),            #Turned to integers
            Negative = n() - sum(Positive)) %>% 
  arrange(-pred) %>%
  mutate(TPR = cumsum(Positive) / sum(Positive),
         FPR = cumsum(Negative) / sum(Negative))

#Calculating the area under the curve (AUC)
auc_value <- roc %>% 
  summarise(AUC = sum(diff(FPR) * na.omit(lead(TPR) + TPR)) / 2)


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
  ggplot(aes(FPR, TPR)) +
  geom_line(color = "blue") +
  theme_bw()+
  labs(title = "ROC plot with logistic regression model", subtitle = "AUC = 0.945") 

confusion_matrix_plot <- df %>% 
  ggplot(mapping = aes(x = Actual_values, y = Predicted_values)) +
    geom_tile(aes(fill = Y), colour = "white") +
    geom_text(aes(label = sprintf("%1.0f", Y))) +
    scale_fill_gradient(low = "lightblue", high = "lightgreen") +
    theme_bw() + 
    theme(legend.position = "none") +
    labs(x = "Actual values", y = "Predicted values", 
       title = "Confusion Matrix of Simple Linear Model")

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/roc.png",
       plot = roc_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/confusion_matrix.png",
       plot = confusion_matrix_plot,
       width = 10, 
       height = 6)

#write_tsv(x = my_data_subset,
#          path = "path/to/my/data_subset.tsv")

