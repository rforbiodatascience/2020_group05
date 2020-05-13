# Clear Workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("keras")
library("devtools")


# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")


# Load data ---------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", 
               col_types = cols(carrier = col_factor()))


# Wrangle data ------------------------------------------------------------
nn_dat <- df %>% 
  select(CK, H, PK, LD, carrier) %>% 
  rename(CK_feat = CK,
         H_feat  = H,
         PK_feat = PK,
         LD_feat = LD) %>% 
  mutate(class_num = as.numeric(carrier) - 1,
         class_label = ifelse(carrier == 0, "non-carrier", "carrier"))

nn_dat %>%
  head(3)

# Split into training/test set --------------------------------------------
# Stratification
test_size <- 0.20

nn_dat_test <- nn_dat %>%
  group_by(carrier) %>% 
  sample_frac(size = test_size,
              replace = FALSE) %>% 
  mutate(partition = "test")

nn_dat <- nn_dat %>% 
  full_join(nn_dat_test) %>%
  replace_na(list(partition = "train"))

nn_dat %>% count(partition)

# Train partition
x_train <- nn_dat %>%
  filter(partition == "train") %>%
  select(contains("feat")) %>%
  as.matrix

y_train <- nn_dat %>%
  filter(partition == "train") %>%
  pull(carrier) %>% 
  to_categorical(2)

# Test partition
x_test <- nn_dat %>%
  filter(partition == "test") %>%
  select(contains("feat")) %>%
  as.matrix

y_test <- nn_dat %>%
  filter(partition == "test") %>%
  pull(carrier) %>% 
  to_categorical(2)

# Model building --------------------------------------------------------
model <- keras_model_sequential() %>% 
  layer_dense(units = 4, activation = "relu", 
              kernel_initializer = "random_normal", input_shape = 4) %>% 
  layer_dense(units = 3, activation = "relu", 
              kernel_initializer = "random_normal") %>% 
  layer_dense(units = 2, activation = "sigmoid", 
              kernel_initializer = "random_normal")

# Compile model
model %>%
  compile(loss      = "binary_crossentropy",
          optimizer = "adam",
          metrics   = c("accuracy"))

model %>%
  summary


# Train the ANN -----------------------------------------------------------
history <- model %>%
  fit(x = x_train,
      y = y_train,
      epochs = 200,
      batch_size = 10)

ANN_plot <- plot(history) 


# Evaluate network performance --------------------------------------------
performance <- model %>% 
  evaluate(x_test, y_test)
performance

nn_dat <- nn_dat %>%
  filter(partition == "test") %>%
  mutate(class_num = factor(class_num),
         y_pred    = factor(predict_classes(model, x_test)),
         Correct   = factor(ifelse(class_num == y_pred, "Yes", "No")))

nn_dat %>% 
  select(-contains("feat")) %>% 
  head(3)

# Confusion matrix --------------------------------------------------------
# Calculate: true positives (TP), true negatives (TN), 
#            false positives (FP) and false negatives (FN)

TP <- nn_dat %>% 
  filter(carrier == 1 & y_pred == 1) %>% 
  nrow()

TN <- nn_dat %>% 
  filter(carrier == 0 & y_pred == 0) %>% 
  nrow()

FP <- nn_dat %>% 
  filter(carrier == 0 & y_pred == 1) %>% 
  nrow()

FN <- nn_dat %>% 
  filter(carrier == 1 & y_pred == 0) %>% 
  nrow()

# Collect into a matrix and add values for visualisation
confusion_matrix <- c(TP, TN, FP, FN)
title <- "Confusion Matrix of Artificial Neural Network"
subtitle <- str_c("Accuracy = ", round(performance$acc, 3) * 100, "%")

CM_plot <- confusion_matrix_plot(confusion_matrix = confusion_matrix,
                                 title_input = title,
                                 subtitle_input = subtitle)


# Write data --------------------------------------------------------------
ggsave(filename = "results/07_ann_confusion_matrix.png",
       plot     = CM_plot,
       width    = 10,
       height   = 6)

ggsave(filename = "results/07_ann_training.png",
       plot     = ANN_plot,
       width    = 10,
       height   = 6)

# Save ANN model for Shiny-App
save_model_hdf5(model, 
                filepath = "data/07_ANN_model.hdf5")

