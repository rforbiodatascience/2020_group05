# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("keras")
library("devtools")
# install_keras(tensorflow = "1.13.1") # KØR DENNE FØRSTE GANG PÅ DIN RSTUDIO CLOUD

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_proj_func.R")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", col_types = cols(carrier = col_factor()))

# Wrangle data
# ------------------------------------------------------------------------------
head(df)
nn_dat <- df %>% 
  select(CK, H, PK, LD, carrier) %>% 
  rename(CK_feat = CK,
         H_feat = H,
         PK_feat = PK,
         LD_feat = LD) %>% 
  mutate(class_num = carrier,
         class_label = ifelse(carrier == 0, 'non-carrier', 'carrier'))
nn_dat %>% head(3)

# Split into training/test set
test_f = 0.20 # EDIT THIS (LOO??)
nn_dat = nn_dat %>%
  mutate(partition = sample(x = c('train','test'),
                            size = nrow(.),
                            replace = TRUE,
                            prob = c(1 - test_f, test_f)))
nn_dat %>% count(partition)

x_train = nn_dat %>%
  filter(partition == 'train') %>%
  select(contains("feat")) %>%
  as.matrix
y_train = nn_dat %>%
  filter(partition == 'train') %>%
  pull(class_num) %>%
  to_categorical(2)

x_test = nn_dat %>%
  filter(partition == 'test') %>%
  select(contains("feat")) %>%
  as.matrix
y_test = nn_dat %>%
  filter(partition == 'test') %>%
  pull(class_num) %>%
  to_categorical(2)

###############################EDIT BELOW###########################
# Define the model
model = keras_model_sequential() %>% 
  layer_dense(units = 4, activation = 'relu', input_shape = 4) %>% 
  layer_dense(units = 2, activation = 'softmax')

# Compile model
model %>%
  compile(loss = 'categorical_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics = c('accuracy')
  )

model %>%
  summary

# Train the ANN
history = model %>%
  fit(x = x_train,
      y = y_train,
      epochs = 50,
      batch_size = 20,
      validation_split = 0.2
  )

plot(history) 

# Evaluate network performance
perf = model %>% evaluate(x_test, y_test)
perf

plot_dat = nn_dat %>%
  filter(partition == 'test') %>%
  mutate(class_num = factor(class_num),
         y_pred = factor(predict_classes(model, x_test)),
         Correct = factor(ifelse(class_num == y_pred, "Yes", "No")))
plot_dat %>% select(-contains("feat")) %>% head(3)

# Visualization
title     = "Classification Performance of Artificial Neural Network"
sub_title = str_c("Accuracy = ", round(perf$acc, 3) * 100, "%")
x_lab     = "True iris class"
y_lab     = "Predicted iris class"
plot_dat %>% ggplot(aes(x = class_num, y = y_pred, colour = Correct)) +
  geom_jitter() +
  scale_x_discrete(labels = levels(nn_dat$class_label)) +
  scale_y_discrete(labels = levels(nn_dat$class_label)) +
  theme_bw() +
  labs(title = title, subtitle = sub_title, x = x_lab, y = y_lab)
