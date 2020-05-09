# Clear Workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")
library("keras")
library("devtools")
library("rsample")
#install_keras(tensorflow = "1.13.1") # KØR DENNE FØRSTE GANG PÅ DIN RSTUDIO CLOUD


# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")


# Load data ---------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", col_types = cols(carrier = col_factor()))

# Wrangle data ------------------------------------------------------------
nn_dat <- df %>% 
  select(CK, H, PK, LD, carrier) %>% 
  mutate(CK = normalize(CK),
         H = normalize(H),
         PK = normalize(PK),
         LD = normalize(LD)) %>% 
  rename(CK_feat = CK,
         H_feat = H,
         PK_feat = PK,
         LD_feat = LD) %>% 
  mutate(class_num = as.numeric(carrier) - 1,
         class_label = ifelse(carrier == 0, 'non-carrier', 'carrier'))

nn_dat %>%
  head(3)

# Split into training/test set --------------------------------------------
# leave one out
data_batch <- loo_cv(nn_dat)

# Splitting data into training and test set:
data_batch <- data_batch %>%
  mutate(traindata = map(splits, analysis),
         testdata = map(splits, assessment))

data_batch <- unnest(data_batch, traindata) %>% 
  group_by(id) %>% 
  nest(x_train = c(LD_feat, CK_feat, H_feat, PK_feat),
                   y_train = c(carrier),
                   perf = c(class_label, class_num))

data_batch <- unnest(data_batch, testdata) %>% 
  group_by(id) %>% 
  nest(x_test = c(LD_feat, CK_feat, H_feat, PK_feat),
       y_test = c(carrier),
       perf2 = c(class_label, class_num))

# Model building --------------------------------------------------------
model <- keras_model_sequential() %>% 
  layer_dense(units = 4, activation = 'relu', input_shape = 4, kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 3, activation = 'relu', kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 1, activation = 'sigmoid', kernel_initializer = 'random_normal')

# NOTE: relu is very computational efficient, quick convergence. sigmoid is computational 
# expensive but gives clear predictions.
# Input shape = 4 because we have four variables. 
# kernel_initializer = the start weights, random_normal takes random values from a normal distribution
# units = number of hidden units, input should be same as amount of variables, output layer should 
# be 1 when it is a classifier like ours, hidden layer somewhere in between.

# Compile model
model %>%
  compile(loss = 'binary_crossentropy',
          optimizer = 'adam',
          metrics = c('accuracy'))

# NOTE: binary_crossentropy is the default and preferred loss function for binary classification problem

model %>%
  summary

# Train the ANN
# ------------------------------------------------------------------------------
data_batch <- data_batch %>% 
  mutate(history = map2(x_train, y_train, fit(model, epochs = 200, batch_size = 5)))

history <- model %>%
  fit(x = x_train,
      y = y_train,
      epochs = 200,
      batch_size = 10)

plot(history) 

# Evaluate network performance
perf <- model %>% 
  evaluate(x_test, y_test)
perf

nn_dat <- nn_dat %>%
  filter(partition == 'test') %>%
  mutate(class_num = factor(class_num),
         y_pred = factor(predict_classes(model, x_test)),
         Correct = factor(ifelse(class_num == y_pred, "Yes", "No")))

plot_dat %>% 
  select(-contains("feat")) %>% 
  head(3)

# Visualization
# ------------------------------------------------------------------------------
title     = "Classification Performance of Artificial Neural Network"
sub_title = str_c("Accuracy = ", round(perf$acc, 3) * 100, "%")
x_lab     = "True carrier"
y_lab     = "Predicted carrier"
plt1 <- plot_dat %>% 
  ggplot(aes(x = class_num, y = y_pred, colour = Correct)) +
  geom_jitter() +
  scale_x_discrete(labels = levels(nn_dat$class_label)) +
  scale_y_discrete(labels = levels(nn_dat$class_label)) +
  theme_bw() +
  labs(title = title, subtitle = sub_title, x = x_lab, y = y_lab)

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/ann_classification.png",
       plot = plt1,
       width = 10,
       height = 6)

