# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("keras")
library("devtools")
#install_keras(tensorflow = "1.13.1") # KØR DENNE FØRSTE GANG PÅ DIN RSTUDIO CLOUD

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_proj_func.R")

# normalize <- function(x) {
#   return ((x - min(x)) / (max(x) - min(x)))
# }

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", col_types = cols(carrier = col_factor()))
df <- df %>% drop_na()

# Wrangle data
# ------------------------------------------------------------------------------
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
        mutate(class_label = ifelse(carrier == 0, 'non-carrier', 'carrier'))

nn_dat %>% 
  head(3)

# Split into training/test set
# ------------------------------------------------------------------------------
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

###############################EDIT BELOW###########################
# Define the model
model <- keras_model_sequential() %>% 
  layer_dense(units = 2, activation = 'relu', input_shape = 4, kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 4, activation = 'relu', kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 2, activation = 'sigmoid', kernel_initializer = 'random_normal')

# Compile model
model %>%
  compile(loss = 'binary_crossentropy',
          optimizer = 'adam',
          metrics = c('accuracy'))

model %>%
  summary

# Train the ANN
history <- model %>%
          fit(x = x_train,
              y = y_train,
              epochs = 300,
              batch_size = 10)

plot(history) 

# Evaluate network performance
perf <- model %>% 
       evaluate(x_test, y_test)
perf

plot_dat <- nn_dat %>%
  filter(partition == 'test') %>%
  mutate(class_num = factor(carrier),
         y_pred = factor(predict_classes(model, x_test)),
         Correct = factor(ifelse(carrier == y_pred, "Yes", "No")))

plot_dat %>% 
  select(-contains("feat")) %>% 
  head(3)

# Visualization
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
