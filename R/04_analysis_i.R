#Analysis of clean data to explore the general features of the data

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
data <- read_csv(file = "data/02_clean_data.csv") #possibly change to aug data?

# Wrangle data
# ------------------------------------------------------------------------------
my_data_subset <- data 
#%>% 
#  filter(...) %>% 
#  select(...) %>% 
#  mutate(...) %>% 
#  arrange(...)


# Visualise
# ------------------------------------------------------------------------------
#Age distribution of the data: 
pl1 <- my_data_subset %>% 
  ggplot(mapping = aes(x = age)) +
  geom_histogram()
pl1

#Distribution of the genes som function af
  # - age 
  # - eachother (ck, h, pk, ld)
  # - Color code acording to carrier and non carrier (should we make them char instead of no)

pl2 <- my_data_subset %>% 
  ggplot(mapping = aes(x = age, y = ck, color = carrier)) +
  geom_point() + 
  labs(title = "Distribution of levels of ck to age")
pl2

pl3 <- my_data_subset %>% 
  ggplot(mapping = aes(x = h, y = ck, color = carrier))+
  geom_point() + 
  labs(title = "Name")
pl3


# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/age_distribution.png",
       plot = pl1,
       width = 10,
       height = 6)

write_tsv(x = my_data_subset,
          path = "path/to/my/data_subset.tsv")