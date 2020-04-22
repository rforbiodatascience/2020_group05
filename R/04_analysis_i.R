#Analysis of clean data to explore the general features of the data
#Are there any obvios trends in the data

#ASTRID DO THIS

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
#creating age groups
data_subset <- data %>% 
  mutate(age_group = cut(x = Age, breaks = seq(10,100, by = 10))) %>% 
  pivot_longer(c('H','PK'), names_to = "Protein", values_to = "Level")

#select(slice(cancer_data,1:8),pt_id,age,age_group,event_label,1:5)
#  mutate() %>% 
#  select(slice())
#  filter(...) %>% 
#  select(...) %>% 
#  arrange(...)


# Visualise
# ------------------------------------------------------------------------------
#Age distribution of the data: 
pl1 <- data %>% 
  ggplot(mapping = aes(x = Age, fill = as.factor(carrier), alpha = 0.5)) +
  geom_density() + 
  labs(title = "Distribution of Age and Carrier")
pl1 #Possibly we need to make it different so it is easier to see, is bar better? 
#Point: the elder do not really have any non-carrieres, there for we cannot say anything about
#the patterns concerning that type


#---------------------------------------------
#Is there a clear pattern depending on age? 
pl2_ck <- data %>% 
  ggplot(mapping = aes(x = Age, y = CK)) +
  geom_point() + 
  labs(title = "Distribution of levels of ck to age")
pl2_ck

#age group - long format? with the different protein values to make grid?
pl2_age_group <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = Level, fill = as.factor(carrier)), alpha = 0.8) +
  geom_boxplot()+
  labs(title = 'The levels of protein shown among age groups') + 
  facet_grid(Protein ~.)
pl2_age_group


#--------------------------------------------
#Are there two which are coorelated? 
pl2_ck_h <- my_data_subset %>% 
  ggplot(mapping = aes(x = CK, y = H, fill = as.factor(carrier))) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of ck to age")
pl2_ck_h





# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/age_distribution.png",
       plot = pl1,
       width = 10,
       height = 6)
ggsave(filename = "results/Age_CK_level.png",
       plot = pl2_ck,
       width = 10,
       height = 6)
ggsave(filename = "results/Age_groups_protein_level.png",
       plot = pl2_age_group,
       width = 10,
       height = 10)

#write_tsv(x = my_data_subset, path = "path/to/my/data_subset.tsv")