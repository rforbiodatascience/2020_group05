# Descriptive data visulisation 
# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("patchwork")


# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")


# Load data ---------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv", 
                 col_types = cols(carrier = col_factor()))


# Wrangle data ------------------------------------------------------------
# Creating age groups and merging H and PK (These have similar scale of protein levels)
data_subset_age <- data %>% 
  mutate(age_group = cut(x = Age, 
                         breaks = seq(10, 100, by = 10))) 

data_subset_pivot <- data %>% 
  pivot_longer(c("H", "PK", "LD", "CK"), 
               names_to = c("Protein_high"), 
               values_to = "Level") %>% 
  pivot_longer(c())

# Visualise ---------------------------------------------------------------
# Age Distribution --------------------------------------------------------
age_distribution_plot <- data %>% 
  ggplot(mapping = aes(x = Age, fill = carrier)) +
  geom_density(alpha = 0.5) + 
  labs(title = "Distribution of Age and Carrier",
       y = "Density")


# Protein levels density --------------------------------------------------
density_ck <- data %>% 
  filter(CK < 500) %>% 
  density_plot(x_p = CK,
               title_input = "Creatine Kinase")

density_h <- density_plot(data = data,
                          x_p = H,
                          title_input = "Hemopexin")

density_ld <- density_plot(data = data,
                           x_p = LD,
                           title_input = "Lactate Dehydroginase")

density_pk <- data %>% 
  filter(PK < 80) %>% 
  density_plot(x_p = PK,
               title_input = "Pyruvate Kinase")

density_protein_plot <- ((density_pk/density_h) | (density_ld/density_ck)) + 
  plot_annotation(title = "Density plot of enzyme levels") +
  plot_layout(guides = "collect") & 
  theme(legend.position = "right")
  

# Age and Protein ---------------------------------------------------------
boxplot_ck <- boxplot_func(data = data_subset_age,
                           x_protein = CK,
                           age_group = age_group,
                           title_input = "Creatine Kinase")

boxplot_ld <- boxplot_func(data = data_subset_age,
                           x_protein = LD,
                           age_group = age_group,
                           title_input = "Lactate Dehydroginase")

boxplot_h <- boxplot_func(data = data_subset_age,
                           x_protein = H,
                           age_group = age_group,
                           title_input = "Hemopexin")

boxplot_pk <- boxplot_func(data = data_subset_age,
                           x_protein = PK,
                           age_group = age_group,
                           title_input = "Pyruvate Kinase")

protein_ages_plot <- ((boxplot_ck/boxplot_ld) | boxplot_h/boxplot_pk) +
  plot_annotation(title = "Enzyme levels among age groups") +
  plot_layout(guides = "collect") & 
  theme(legend.position = "right")

# Protein-protein ---------------------------------------------------------
# Correlation between carrier-status and the levels of enzyme
CK_vs_LD <- scatter_func_log(data = data,
                         x_protein = CK,
                         y_protein = LD,
                         title_input = "CK and LD")

CK_vs_H <- scatter_func_log(data = data,
                        x_protein = CK,
                        y_protein = H,
                        title_input = "CK and H")

CK_vs_PK <- scatter_func_log(data = data,
                         x_protein = CK,
                         y_protein = PK,
                         title_input = "CK and PK")

LD_vs_H <- scatter_func(data = data,
                        x_protein = LD,
                        y_protein = H,
                        title_input = "LD and H")

LD_vs_PK <- scatter_func(data = data,
                         x_protein = LD,
                         y_protein = PK,
                         title_input = "LD and PK")

H_vs_PK <- scatter_func(data = data,
                        x_protein = H,
                        y_protein = PK,
                        title_input = "H and PK")

protein_protein_plot <- ( CK_vs_H/H_vs_PK | CK_vs_PK/LD_vs_PK | CK_vs_LD/LD_vs_H) +
  plot_annotation(title = "Correlation between enzyme levels") +
  plot_layout(guides = "collect") & 
  theme(legend.position = "bottom")

#---Carrrier stauts and protein
level_carrier_plot <-data_subset_pivot %>% 
  ggplot(mapping = aes(x = Level, y = carrier)) +
  geom_point() + 
  facet_grid(~Protein, scales = "free")

# Write data --------------------------------------------------------------
ggsave(filename = "results/04_age_distribution.png",
       plot = age_distribution_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/04_density_proteins.png",
       plot = density_protein_plot,
       width = 7, 
       height = 5)

ggsave(filename = "results/04_age_groups_protein_levels.png",
       plot = protein_ages_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/04_proteins.png",
       plot = protein_protein_plot,
       width = 10,
       height = 6)

ggsave(filename = "results/04_level_carrier.png",
       plot = level_carrier_plot,
       width = 10,
       height = 6)
