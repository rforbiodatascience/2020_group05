#PC Analysis of the data

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Define functions
# ------------------------------------------------------------------------------


# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv") #possibly change to aug data?

# Wrangle data
# ------------------------------------------------------------------------------
pca_values <- data %>%
  select(carrier, CK, H, PK, LD)
  #add_column(X1 = 0, .before = "carrier")


#wrangle and save data
#makes a 20x20 matrix with the values againt each other 
pca_values <- drop_na(pca_values) %>% 
  select(carrier:LD) %>%
  slice(1:20) %>%
  write_tsv(path = "data/04_PCA_table.tsv")

pca_values <- pca_values %>% 
  prcomp(center = TRUE, scale = TRUE)


View(pca_values)