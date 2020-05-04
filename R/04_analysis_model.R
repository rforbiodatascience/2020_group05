#Linear Modeling of Data - Analysis

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("modelr")

# Define functions
# ------------------------------------------------------------------------------


# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv") 

# Wrangle data
# ------------------------------------------------------------------------------
#splitting data into training and test sets
data_train <- data %>% 
  slice(1:168)
data_test <- data %>% 
  slice(169:210) ####OBS Change this to correct, when aug has right columns

#Modeling
#-------------------------------------------------------------------------------

#Simpel linear model - no subcategorising 
simple_model <- lm(carrier ~ LD+H+PK+CK, data = data_train)
log_reg_model <- glm(carrier ~ PK+LD+H+CK, family=binomial(link='logit'),data=data_train)



grid <- data_train %>% 
  data_grid(PK, .model = simple_model) %>% 
  add_predictions(simple_model, "pred")
grid

grid2 <- data_train %>% 
  data_grid(PK, .model = log_reg_model) %>% 
  add_predictions(log_reg_model, "carrier")
grid2

data_train <- data_train %>% 
  add_residuals(simple_model, "resid")

#---residuals 


# Visualise
# ------------------------------------------------------------------------------
pl1 <- grid2 %>% 
  ggplot(mapping = aes(carrier, pred)) +
  geom_point() +
  theme_bw()
pl1

pl2 <- data_train %>% 
  ggplot(mapping = aes(PK, carrier))+
  geom_point() +
  geom_line(data = grid, color = 'red')
  theme_bw()
pl2

pl3 <- data_train %>% 
  ggplot(mapping = aes(x=PK, fill = as.factor(carrier)), alpha = 0.5)+
  geom_point(pch = 21, aes(y = H)) +
  geom_line(data = grid2, color = 'red', aes(y = carrier))
pl3

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "path/to/my/results/plot.png",
       plot = pl1,
       width = 10,
       height = 6)

write_tsv(x = my_data_subset,
          path = "path/to/my/data_subset.tsv")