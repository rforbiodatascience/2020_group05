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
age_distribution_plot <- data %>% 
  ggplot(mapping = aes(x = Age, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Distribution of Age and Carrier")


#----------------Protein levels density----------------------
pl_ck <- density_plot(data = data,
                      x_p = CK,
                      title_input = "Density plot of the CK values")

#non-standard evaluation

pl_h <- density_plot(data = data,
                     x_p = H,
                     title_input = "Density plot of the H values")

pl_ld <- density_plot(data = data,
                     x_p = LD,
                     title_input = "Density plot of the LD values")

pl_pk <- density_plot(data = data,
                     x_p = PK,
                     title_input = "Density plot of the PK values")

density_protein_plot <- ((pl_pk/pl_h) | (pl_ld/pl_ck))

#----------------Age and Protein-----------------------------
#Is there a clear pattern depending on age? 
boxplot_ck <- boxplot_func(data = data_subset,
                           x_protein = CK,
                           age_group = age_group,
                           title_input = "Distribution of levels of creatine kinase (CK) to age")

boxplot_ld <- boxplot_func(data = data_subset,
                           x_protein = LD,
                           age_group = age_group,
                           title_input = "Distribution of levels of LD to age")

#Age groups, using grid to make two plots at once
boxplot_pk_h <- data_subset %>% 
  ggplot(mapping = aes(x = age_group, y = Level, fill = carrier)) +
  geom_boxplot(alpha = 0.5)+
  labs(title = 'The levels of H and PK shown among age groups', 
       fill = "Carrier Status",
       x = "Age group",
       y = "Protein level") + 
  facet_grid(Protein ~.) 

protein_ages_plot <- ((boxplot_ck/boxplot_ld) | boxplot_pk_h) #With patchwork

#-------------------Protein-protein-------------------------
#Are there any coorelation with carrier-status and the levels of enzyme?
CK_vs_LD <- scatter_func(data = data,
                         x_protein = CK,
                         y_protein = LD,
                         title_input = "Distribution of levels of CK and LD")

CK_vs_H <- scatter_func(data = data,
                        x_protein = CK,
                        y_protein = H,
                        title_input = "Distribution of levels of CK and H")

CK_vs_PK <- scatter_func(data = data,
                        x_protein = CK,
                        y_protein = PK,
                        title_input = "Distribution of levels of CK and PK")

LD_vs_H <- scatter_func(data = data,
                        x_protein = LD,
                        y_protein = H,
                        title_input = "Distribution of levels of LD and H")

LD_vs_PK <- scatter_func(data = data,
                        x_protein = LD,
                        y_protein = PK,
                        title_input = "Distribution of levels of LD and PK")

H_vs_PK <- scatter_func(data = data,
                        x_protein = H,
                        y_protein = PK,
                        title_input = "Distribution of levels of H and PK")

protein_protein_plot <- ( CK_vs_H/H_vs_PK | CK_vs_PK/LD_vs_PK | CK_vs_LD/LD_vs_H)

# Write data
# ---------Age and protein---------------------------------------------------------------------
ggsave(filename = "results/age_distribution.png",
       plot = age_distribution_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/density_proteins.png",
       plot = density_protein_plot,
       width = 10, 
       height = 10)

ggsave(filename = "results/age_groups_protein_levels.png",
       plot = protein_ages_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/proteins.png",
       plot = protein_protein_plot,
       width = 10,
       height = 6)
