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
data <- data %>% mutate_at(vars(carrier), as_factor)

#splitting data into training and test sets
data_train <- data %>% 
  slice(1:168)
data_test <- data %>% 
  slice(169:210) ####OBS Change this to correct, when aug has right columns

#Modeling
#-------------------------------------------------------------------------------

#Simpel linear model - no subcategorising 
simple_model <- lm(carrier ~ LD+H+PK+CK, data = data_train)
log_reg_model <- glm(carrier ~ LD+H+PK+CK,family=binomial(link='logit'),data=data_train)


grid <- data_train %>% 
  data_grid(carrier, .model = simple_model) %>% 
  add_predictions(simple_model, "carrier")
grid

grid2 <- data_train %>% 
  data_grid(carrier, .model = log_reg_model) %>% 
  add_predictions(log_reg_model)
grid2

data_train <- data_train %>% 
  add_residuals(simple_model, "resid")
View(data_train)
# Visualise
# ------------------------------------------------------------------------------
pl1 <- grid2 %>% 
  ggplot(mapping = aes(carrier, pred)) +
  geom_point() +
  theme_bw()
pl1

pl2 <- data_train %>% 
  ggplot(mapping = aes(CK, carrier))+
  geom_point() +
  theme_bw()
pl2

pl3 <- data_train %>% 
  ggplot(mapping = aes(CK, carrier))+
  geom_point(color = 'blue') + 
  geom_line(data = grid, color = 'red')
pl3

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "path/to/my/results/plot.png",
       plot = pl1,
       width = 10,
       height = 6)

write_tsv(x = my_data_subset,
          path = "path/to/my/data_subset.tsv")