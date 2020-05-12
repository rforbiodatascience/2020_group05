# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load Libraries-----------------------------------------------------------
library("tidyverse")
library("broom")
library("rsample")
library("purrr")

# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")

# Load data ---------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv")


# Wrangle data ------------------------------------------------------------
# Split data set using leave one out (loo)
data_batch <- loo_cv(data)

# Split loo splits into model-data and leave-one-out-datapoint:
data_batch <- data_batch %>%
  mutate(modeldata = map(splits, analysis),
         leaveout  = map(splits, assessment))


# Modelling ---------------------------------------------------------------
# Adding a linear model and predict on the holdout, unpack dataframes
data_batch <- data_batch %>% 
  mutate(linear_model = map(.x = modeldata, 
                            .f = linear_model_def),       
         log_model    = map(.x = modeldata, 
                            .f = log_reg_model_def),     
         pred_linear  = map2(linear_model, leaveout, predict),         
         pred_log     = map2(log_model, leaveout, predict, type = "response")) %>%        
  unnest(pred_log, pred_linear, leaveout)                                 

data_batch <- data_batch %>% 
  pivot_longer(c(log_model, linear_model), 
               names_to = "Model_Type", 
               values_to = "models") %>% 
  pivot_longer(c(pred_log, pred_linear), 
               names_to = "pred_type", 
               values_to = "pred")

# Clean out the wrong combinations
data_batch <- data_batch %>% 
  filter(Model_Type == "log_model" & pred_type == "pred_log" | 
         Model_Type == "linear_model" & pred_type == "pred_linear")

View(data_batch)
# Roc & Auc----------------------------------------------------------------
# Calculating True-positive rate (TPR) and False-positive rate (FPR)
roc <- data_batch %>% 
  select(pred_type, carrier, pred) %>%
  mutate(Positive = carrier == 1) %>%            #Carrier actual values
  group_by(pred_type, pred) %>%                            
  summarise(Positive = sum(Positive),            #Turned to integers
            Negative = n() - sum(Positive)) %>% 
  arrange(-pred) %>%
  mutate(TPR = cumsum(Positive) / sum(Positive),
         FPR = cumsum(Negative) / sum(Negative))

# Calculating the area under the curve (AUC)
auc_value <- roc %>% group_by(pred_type) %>% 
  summarise(AUC = sum(diff(FPR) * na.omit(lead(TPR) + TPR)) / 2)


# Confusion Matrix --------------------------------------------------------
# Threshold is at 0.5
# Change to binary prediction
data_batch <- data_batch %>%
  mutate(pred_binary = case_when(pred > 0.5 ~ 1, 
                                 pred < 0.5 ~ 0))

# Making values for confusion matrix
data_batch <- data_batch %>% 
  mutate(CM = case_when(pred_binary == 1 & carrier == 1 ~ "TP",
                        pred_binary == 1 & carrier == 0 ~ "FP",
                        pred_binary == 0 & carrier == 1 ~ "FN",
                        pred_binary == 0 & carrier == 0 ~ "TN"))

confusion_matrix <- data_batch %>% 
  select(pred_type, CM) %>% 
  group_by(pred_type, CM) %>% 
  summarise(freq = n()) 

confusion_matrix1 <- confusion_matrix %>% 
  filter(pred_type == "pred_linear") %>% 
  arrange(desc(CM)) %>% 
  ungroup() %>% 
  select(freq) %>% 
  unlist(use.names = FALSE)

confusion_matrix2 <- confusion_matrix %>% 
  filter(pred_type == "pred_log") %>% 
  arrange(desc(CM)) %>%  
  ungroup() %>% 
  select(freq) %>% 
  unlist(use.names = FALSE)

# Visualise ---------------------------------------------------------------
roc_plot <- roc %>% 
  ggplot(aes(FPR, TPR, color = pred_type)) +
  geom_line() +
  theme_bw() +
  labs(title = "ROC plot of the models", 
       subtitle = str_c("AUC Linear model = ", round(auc_value$AUC[1],3), ",   ", 
                        "AUC Logistic Model = ", round(auc_value$AUC[2], 3))) +
  scale_color_discrete(name = "Prediction", labels = c("Linear", "Logistic"))

CM_plot_linear <- confusion_matrix_plot(confusion_matrix = confusion_matrix1,
                                        title_input = "Confusion Matrix of Linear Model",
                                        subtitle_input = " ")

CM_plot_log <- confusion_matrix_plot(confusion_matrix = confusion_matrix2,
                                     title_input = "Confusion Matrix of Logistic Regression Model",
                                     subtitle_input = "  ")

# Write data --------------------------------------------------------------
ggsave(filename = "results/06_roc.png",
       plot   = roc_plot,
       width  = 10,
       height = 6)

ggsave(filename = "results/06_confusion_matrix_linear_model.png",
       plot   = CM_plot_linear,
       width  = 10, 
       height = 6)

ggsave(filename = "results/06_confusion_matrix_log_model.png",
       plot   = CM_plot_log,
       width  = 10, 
       height = 6)

