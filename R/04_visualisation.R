#Descriptive data visulisation 
#Analysis of clean data to explore the general features of the data
#Are there any obvios trends in the data

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("patchwork")

# 
source(file = "R/99_proj_func.R")

# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv") %>% 
  mutate(carrier = factor(carrier))


# Wrangle data
# ------------------------------------------------------------------------------
#Creating age groups and merging H and PK (These have similar scale of protein levels)
data_subset <- data %>% 
  mutate(age_group = cut(x = Age, breaks = seq(10,100, by = 10))) %>% 
  pivot_longer(c('H','PK'), names_to = "Protein", values_to = "Level")


# Visualise
# ----------------Age Distribution----------------------------
#Age distribution of the data: 
age_distribution <- data %>% 
  ggplot(mapping = aes(x = Age, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Distribution of Age and Carrier")


#----------------Protein levels density----------------------
pl_ck <- data %>% 
  ggplot(mapping = aes(x = CK, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Density plot of the CK values")

pl_ck <- data %>% 
  density_plot(x_p = CK)
#non-standard evaluation
density_plot(data$CK)

pl_h <- data %>% 
  ggplot(mapping = aes(x = H, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Density plot of the H values")

pl_pk <- data %>% 
  ggplot(mapping = aes(x = PK, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Density plot of the PK value")

pl_ld <- data %>% 
  ggplot(mapping = aes(x = LD, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Density plot of the LD value")

density_proteins <- ((pl_pk/pl_h) | (pl_ld/pl_ck))

#----------------Age and Protein-----------------------------
#Is there a clear pattern depending on age? 
pl2_ck <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = CK, fill = carrier)) +
  geom_boxplot(alpha = 0.5) + 
  labs(title = "Distribution of levels of creatine kinase (CK) to age",
       x = "Age Group") +
  theme(legend.position = "none")

pl2_ld <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = LD, fill = carrier)) +
  geom_boxplot(alpha = 0.5) + 
  labs(title = "Distribution of levels of LD to age",
       x = "Age Group")+
  theme(legend.position = "none")


#Age groups, using grid to make two plots at once
pl2_age_group <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = Level, fill = carrier)) +
  geom_boxplot(alpha = 0.5)+
  labs(title = 'The levels of H and PK shown among age groups', 
       fill = "Carrier Status",
       x = "Age group",
       y = "Protein level") + 
  facet_grid(Protein ~.) 

protein_ages <- ((pl2_ck/pl2_ld) | pl2_age_group) #With patchwork

#-------------------Protein-protein-------------------------
#Are ther coorelation with carrier-status and the levels of enzyme
pl3_ck_ld <- data %>% 
  ggplot(mapping = aes(x = CK, y = LD, fill = carrier)) +
    geom_point(pch = 21) + 
    labs(title = "Distribution of levels of CK and LD")

pl3_ck_h <- data %>% 
  ggplot(mapping = aes(x = CK, y = H, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of CK and H")

pl3_ck_pk <- data %>% 
  ggplot(mapping = aes(x = CK, y = PK, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of H and LD")

pl3_pk_ld <- data %>% 
  ggplot(mapping = aes(x = PK, y = LD, fill = carrier)) +
  geom_point(pch = 21) +
  labs(title = "Distribution of levels of PK and LD")

pl3_pk_h <- data %>% 
  ggplot(mapping = aes(x = PK, y = H, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels PK and H")

pl3_h_ld <- data %>% 
  ggplot(mapping = aes(x = H, y = LD, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of H and LD")

protein <- ( pl3_ck_h/pl3_pk_h | pl3_ck_pk/pl3_pk_ld | pl3_ck_ld/pl3_h_ld)


# Write data
# ---------Age and protein---------------------------------------------------------------------
ggsave(filename = "results/age_distribution.png",
       plot = age_distribution,
       width = 10,
       height = 6)

ggsave(filename = "results/density_proteins.png",
       plot = density_proteins,
       width = 10, 
       height = 10)

ggsave(filename = "results/age_groups_protein_levels.png",
       plot = protein_ages,
       width = 10,
       height = 6)

ggsave(filename = "results/proteins.png",
       plot = protein,
       width = 10,
       height = 6)
