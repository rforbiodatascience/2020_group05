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
my_data <- read_tsv(file = "path/to/my/data.tsv")

# Wrangle data
# ------------------------------------------------------------------------------

#Simpel linear model - no subcategorising 





# Visualise
# ------------------------------------------------------------------------------
pl1 <- my_data_subset %>% 
  ggplot(aes(x = var_1, y = var_2)) +
  geom_point() +
  theme_bw()

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "path/to/my/results/plot.png",
       plot = pl1,
       width = 10,
       height = 6)

write_tsv(x = my_data_subset,
          path = "path/to/my/data_subset.tsv")