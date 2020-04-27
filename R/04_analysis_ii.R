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
dmd_data <- read_tsv(file = "data/03_aug_data.tsv") #possibly change to aug data?

# Wrangle data
# ------------------------------------------------------------------------------
dmd_data <- drop_na(dmd_data) %>%
  select(carrier, CK, H, PK, LD)
  #add_column(X1 = 0, .before = "carrier")

#wrangle and save data
#makes a 20x20 matrix with the values againt each other 
dmd_data <- dmd_data %>% 
  select(carrier:LD) %>%
  slice(1:20) %>%
  write_tsv(path = "data/04_PCA_table.tsv")

#creation of PCA object
dmd_pca <- dmd_data %>% 
  prcomp(center = TRUE, scale = TRUE)

#creation of scree plot to see the variation explained
dmd_pca %>% 
  tidy("pcs") %>% 
  ggplot(aes(x = PC, y = percent)) +
  geom_col() + 
  theme_classic()

#get the data we want to show
dmd_pca_aug <- dmd_pca %>% 
  augment(dmd_data)

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
dmd_pca_aug %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2,
             label = carrier, colour = carrier)) + 
             geom_label_repel() + 
             theme(legend.position = "bottom") +  
             #scale_colour_manual(values = c("red", "blue", "black", "purple", "green", "yellow")) +
             labs(x = x, y = y)