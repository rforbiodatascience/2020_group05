#Descriptive data visulisation 
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
data <- read_tsv(file = "data/03_aug_data.tsv",col_types = cols(carrier = col_factor())) 


# Wrangle data
# ------------------------------------------------------------------------------
#creating age groups and merging H and PK 
data_subset <- data %>% 
  mutate(age_group = cut(x = Age, breaks = seq(10,100, by = 10))) %>% 
  pivot_longer(c('H','PK'), names_to = "Protein", values_to = "Level")



# Visualise
# ------------------------------------------------------------------------------
#Age distribution of the data: 
pl1 <- data %>% 
  ggplot(mapping = aes(x = Age, fill = carrier, alpha = 0.5)) +
  geom_density() + 
  labs(title = "Distribution of Age and Carrier")
pl1 #Possibly we need to make it different so it is easier to see, is bar better? 
#Point: the elder do not really have any non-carrieres, there for we cannot say anything about
#the patterns concerning that type


#----------------Age and Protein-----------------------------
#Is there a clear pattern depending on age? 
pl2_ck <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = CK, fill = carrier), alpha = 0.5) +
  geom_boxplot() + 
  labs(title = "Distribution of levels of creatine kinase (CK) to age")
pl2_ck

pl2_ld <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = LD, fill = carrier), alpha = 0.5) +
  geom_boxplot() + 
  labs(title = "Distribution of levels of LD to age")
pl2_ld

#age group - long format? with the different protein values to make grid?
pl2_age_group <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = Level, fill = carrier), alpha = 0.8) +
  geom_boxplot()+
  labs(title = 'The levels of protein shown among age groups', 
       fill = "Carrier Status",
       x = "Age group",
       y = "Protein level") + 
  facet_grid(Protein ~.)
pl2_age_group


#-------------------Protein-protein-------------------------
#Are ther coorelation with carrier-status and the levels of enzyme
pl3_ck_ld <- data %>% 
  ggplot(mapping = aes(x = CK, y = LD, fill = carrier), alpha = 0.5) +
    geom_point(pch = 21) + 
    labs(title = "Distribution of levels of CK and LD")
pl3_ck_ld

pl3_ck_h <- data %>% 
  ggplot(mapping = aes(x = CK, y = H, fill = carrier), alpha = 0.5) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of CK and H")
pl3_ck_h

pl3_ck_pk <- data %>% 
  ggplot(mapping = aes(x = CK, y = PK, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of H and LD")
pl3_ck_pk

pl3_pk_ld <- data %>% 
  ggplot(mapping = aes(x = PK, y = LD, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of PK and LD")
pl3_pk_ld

pl3_pk_h <- data %>% 
  ggplot(mapping = aes(x = PK, y = H, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels PK and H")
pl3_pk_h

pl3_h_ld <- data %>% 
  ggplot(mapping = aes(x = H, y = LD, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of H and LD")
pl3_h_ld

#----------Season and Protein------------------
#pl3_seasons <- data %>% 
#  ggpplot(mapping aes(x = season)) +
#  geom_density(aes(y = CK))

# Write data
# ---------Age and protein---------------------------------------------------------------------
ggsave(filename = "results/age_distribution.png",
       plot = pl1,
       width = 10,
       height = 6)

ggsave(filename = "results/Age_CK_level.png",
       plot = pl2_ck,
       width = 10,
       height = 6)

ggsave(filename = "results/Age_PK_level.png",
       plot = pl2_pk,
       width = 10,
       height = 6)

ggsave(filename = "results/Age_groups_LD_H_level.png",
       plot = pl2_age_group,
       width = 10,
       height = 10)

#-------Protein-protein------------------------
ggsave(filename = "results/CK-LD.png",
       plot = pl3_ck_ld,
       width = 10,
       height = 10)
ggsave(filename = "results/CK-H.png",
       plot = pl3_ck_h,
       width = 10,
       height = 10)
ggsave(filename = "results/CK-PK.png",
       plot = pl3_ck_pk,
       width = 10,
       height = 10)
ggsave(filename = "results/PK-H.png",
       plot = pl3_pk_h,
       width = 10,
       height = 10)
ggsave(filename = "results/PK-LD.png",
       plot = pl3_pk_ld,
       width = 10,
       height = 10)
ggsave(filename = "results/H-LD.png",
       plot = pl3_h_ld,
       width = 10,
       height = 10)

#---------------Season-Protein-------------
#ggsave(filename = "results/season-LD.png")

#write_tsv(x = my_data_subset, path = "path/to/my/data_subset.tsv")