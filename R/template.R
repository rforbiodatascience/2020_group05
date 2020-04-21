#Template on how to structure a script acording to Leon 
#(based on Exercises with git)

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Define functions
# ------------------------------------------------------------------------------
foo <- function(x){
  return("bar")
}

# Load data
# ------------------------------------------------------------------------------
my_data <- read_tsv(file = "path/to/my/data.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
my_data_subset <- my_data %>% 
  filter(...) %>% 
  select(...) %>% 
  mutate(...) %>% 
  arrange(...)

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