# Clear Workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("keras")
library("devtools")
#install_keras(tensorflow = "1.13.1") # KØR DENNE FØRSTE GANG PÅ DIN RSTUDIO CLOUD


# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")

# Load data ---------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", 
               col_types = cols(carrier = col_factor()))

# Wrangle data ------------------------------------------------------------
nn_dat <- df %>% 
  select(CK, H, PK, LD, carrier) %>% 
  mutate(CK = normalize(CK),
         H  = normalize(H),
         PK = normalize(PK),
         LD = normalize(LD)) %>% 
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
test_size <- 0.25

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
  layer_dense(units = 4, activation = "relu", kernel_initializer = "random_normal", input_shape = 4) %>% 
  layer_dense(units = 3, activation = "relu", kernel_initializer = "random_normal") %>% 
  layer_dense(units = 2, activation = "sigmoid", kernel_initializer = "random_normal")

# NOTE: relu is very computational efficient, quick convergence. sigmoid is computational 
# expensive but gives clear predictions.
# Input shape = 4 because we have four variables. 
# kernel_initializer = the start weights, random_normal takes random values from a normal distribution
# units = number of hidden units, input should be same as amount of variables, output layer should 
# be 1 when it is a classifier like ours, hidden layer somewhere in between.

# Compile model
model %>%
  compile(loss      = "binary_crossentropy",
          optimizer = "adam",
          metrics   = c("accuracy"))

# NOTE: binary_crossentropy is the default and preferred loss function for binary classification problem

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
Actual_values    <- factor(c(1, 0, 0, 1))
Predicted_values <- factor(c(1, 0, 1, 0))
goodbad          <- factor(c("good", "good", "bad", "bad"))

CM_plot <- confusion_matrix_plot(Actual_values = Actual_values,
                                 Predicted_values = Predicted_values,
                                 confusion_matrix = confusion_matrix,
                                 goodbad = goodbad,
                                 title_input = "Confusion Matrix of Artificial Neural Network",
                                 subtitle_input = str_c("Accuracy = ", round(performance$acc, 3) * 100, "%"))

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/ann_confusion_matrix.png",
       plot     = CM_plot,
       width    = 10,
       height   = 6)

ggsave(filename = "results/ann_training.png",
       plot     = ANN_plot,
       width    = 10,
       height   = 6)

# Save ANN model for Shiny-App
save_model_hdf5(model, 
                filepath = "data/04_ANN_model")

write_tsv(nn_dat,
          path = "data/07_ANN_data.tsv")
