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
set.seed(44)
test_f <- 0.20
nn_dat <- nn_dat %>%
  mutate(partition = sample(x = c('train','test'),
                            size = nrow(.),
                            replace = TRUE,
                            prob = c(1 - test_f, test_f)))

nn_dat %>% count(partition)

# Train partition
x_train <- nn_dat %>%
  filter(partition == 'train') %>%
  select(contains("feat")) %>%
  as.matrix

y_train <- nn_dat %>%
  filter(partition == 'train') %>%
  pull(carrier) %>% 
  to_categorical(2)

# Test partition
x_test <- nn_dat %>%
  filter(partition == 'test') %>%
  select(contains("feat")) %>%
  as.matrix

y_test <- nn_dat %>%
  filter(partition == 'test') %>%
  pull(carrier) %>% 
  to_categorical(2)

# Model building --------------------------------------------------------
model <- keras_model_sequential() %>% 
  layer_dense(units = 4, activation = 'relu', input_shape = 4, kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 3, activation = 'relu', kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 2, activation = 'sigmoid', kernel_initializer = 'random_normal')

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

nn_dat %>% 
  select(-contains("feat")) %>% 
  head(3)

# Confusing matrix
# ------------------------------------------------------------------------------
nn_dat <- nn_dat %>% 
  mutate(CM = case_when(y_pred == 1 & carrier == 1 ~ "TP",
                        y_pred == 1 & carrier == 0 ~ "FP",
                        y_pred == 0 & carrier == 1 ~ "FN",
                        y_pred == 0 & carrier == 0 ~ "TN"))

#summaries results of values in new table
confusion_matrix <- nn_dat %>% 
  select(CM) %>% 
  group_by(CM) %>% 
  summarise(freq = n())

#make tibble
cm_tibble <- tibble(CM = c("TP", "FN", "TN", "FP"), freq = c(0, 0, 0, 0))

confusion_matrix <- cm_tibble %>% 
  full_join(confusion_matrix, by = "CM") %>% 
  mutate(freq = freq.x + freq.y) %>% 
  select(CM, freq)


#Setting up for visulisation
Actual_values <- factor(c("carrier", "non_carrier", "non_carrier", "carrier"))
Predicted_values <- factor(c("non_carrier", "carrier", "non_carrier", "carrier"))

Y <- confusion_matrix %>% 
  select(freq) %>% 
  unlist(use.names = FALSE)

df <- data.frame(Actual_values, Predicted_values, Y)

confusion_matrix_plot <- df %>% 
  ggplot(mapping = aes(x = Actual_values, y = Predicted_values)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y))) +
  scale_fill_gradient(low = "lightblue", high = "lightgreen") +
  theme_bw() + 
  theme(legend.position = "none") +
  labs(x = "Actual values", 
       y = "Predicted values", 
       title = "Confusion Matrix of ANN")

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/ann_cm.png",
       plot = confusion_matrix_plot,
       width = 10,
       height = 6)

