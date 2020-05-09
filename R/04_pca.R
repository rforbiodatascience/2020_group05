#PC Analysis of the data

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("ggrepel")
library("broom")

# Define functions
# ------------------------------------------------------------------------------


# Load data
# ------------------------------------------------------------------------------
dmd_data <- read_tsv(file = "data/03_aug_data.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
dmd_data <- drop_na(dmd_data) %>%
  select(carrier, CK, H, PK, LD)

#wrangle and save data
#makes a 20x20 matrix with the values againt each other 
dmd_data <- dmd_data %>% 
  select(carrier:LD) %>%
  write_tsv(path = "data/04_PCA_table.tsv")

#creation of PCA object
dmd_pca <- dmd_data %>% 
  prcomp(center = TRUE, scale = TRUE)

#get the data we want to show
dmd_pca_aug <- dmd_pca %>% 
  augment(dmd_data)

#variance explained
var_exp <- dmd_pca %>% 
  tidy("pcs") %>% 
  pull(percent)

var_exp_plot <- var_exp_plot %>%
  ggplot(aes(PC, var_exp)) +
  geom_point() + 
  geom_line()

#getting x and y values of the two PC components we want to plot
x <- dmd_pca %>% 
  tidy("pcs") %>% 
  filter(PC==1) %>% 
  pull(percent)
x <- str_c("PC1 (", round(x*100, 2), "%)")

y <- dmd_pca %>%
  tidy("pcs") %>% 
  filter(PC==2) %>% 
  pull(percent)
y <- str_c("PC2 (", round(y*100, 2), "%)")

#plotting the PCA
#PC1 and PC2
pc1_pc2 <- dmd_pca_aug %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2,
             colour = factor(carrier))) +
  geom_point(size = 1.0) +
  theme(legend.position = "bottom") +  
  labs(x = x, y = y, colour = "Carrier Status", title = "Principal Component Analysis (PCA)")

# Write data
# -----------------------------------------------------------------
ggsave(filename = "results/pc1_pc2.png",
       plot = pc1_pc2,
       width = 10, 
       height = 6)
