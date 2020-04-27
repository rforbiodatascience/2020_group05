#PC Analysis of the data

# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("ggrepel")

# Define functions
# ------------------------------------------------------------------------------


# Load data
# ------------------------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv") #possibly change to aug data?

# Wrangle data
# ------------------------------------------------------------------------------
pca_values <- data %>%
  select(carrier, CK, H, PK, LD)
  #add_column(X1 = 0, .before = "carrier")


#wrangle and save data
#makes a 20x20 matrix with the values againt each other 
pca_values <- drop_na(pca_values) %>% 
  select(carrier:LD) %>%
  slice(1:20) %>%
  write_tsv(path = "data/04_PCA_table.tsv")

#creation of PCA object
pca_values <- pca_values %>% 
  prcomp(center = TRUE, scale = TRUE)

#getting x and y values of the two PC components we want to plot
x <- bl62_pca %>% 
  tidy("pcs") %>% 
  filter(PC==1) %>% 
  pull(percent)

x <- str_c("PC1 (", round(x*100, 2), "%)")
y <- bl62_pca %>%
  tidy("pcs") %>% 
  filter(PC==2) %>% 
  pull(percent)

y <- str_c("PC2 (", round(y*100, 2), "%)")

# hhh

#plotting the PCA
bl62_pca_aug %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2,
             label = aa, colour = chem_class)) + 
             geom_label_repel() + 
             theme(legend.position = "bottom") +  
             scale_colour_manual(values = c("red", "blue", "black", "purple", "green", "yellow")) +
             labs(x = x, y = y)