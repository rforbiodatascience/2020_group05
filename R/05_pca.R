# Principal Component Analysis

# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")
library("patchwork")


# Load data ---------------------------------------------------------------
data <- read_tsv(file = "data/03_aug_data.tsv")


# Wrangle data ------------------------------------------------------------
data <- data %>%
  select(carrier, CK, H, PK, LD)

# PCA object
pca_object <- data %>% 
  prcomp(center = TRUE, scale = TRUE)

# Add fitted values to dataframe
data <- pca_object %>% 
  augment(data)


# Variance explained plot -------------------------------------------------
var_exp <- pca_object %>% 
  tidy("pcs") %>% 
  mutate(percent = percent * 100,
         cumulative = cumulative * 100)
# Plot
var_exp_plot <- var_exp %>% 
  ggplot(mapping = aes(x = PC)) +
  geom_bar(aes(y = percent, fill = "deepskyblue"), stat = "identity", width = 0.5) +
  geom_line(aes(y = cumulative, fill = "black"), group = 1) +
  geom_point(aes(y = cumulative), group = 1) +
  scale_fill_identity(name = "",
                       breaks = c("deepskyblue", "black"),
                       labels = c("PCA", "Cumulative"),
                       guide = "legend") +
  theme(legend.position = "bottom") +  
  labs(title = "PCA Variance Explained", 
       x = "Dimension", 
       y = "Variance explained (%)")

# PCA plot ----------------------------------------------------------------
# Extract variance explained by PC1 and PC2 for axis labels
PC1 <- pca_object %>% 
  tidy("pcs") %>% 
  filter(PC == 1) %>% 
  pull(percent)
PC1 <- str_c("PC1 (", round(PC1 * 100, 2), "%)")

PC2 <- pca_object %>%
  tidy("pcs") %>% 
  filter(PC == 2) %>% 
  pull(percent)
PC2 <- str_c("PC2 (", round(PC2 * 100, 2), "%)")

# Plot PC1 and PC2
pc1_pc2_plot <- data %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2, colour = factor(carrier))) +
  geom_point(size = 1.0) +
  theme(legend.position = "bottom") +  
  labs(x = PC1, 
       y = PC2, 
       colour = "Carrier Status", 
       title = "Principal Component Analysis (PCA)")

#Combined:
combined <- (var_exp_plot | pc1_pc2_plot) +
  plot_layout(widths = c(1, 2))

# Write data --------------------------------------------------------------
ggsave(filename = "results/05_pca_and_variance.png",
       plot = combined,
       width = 10,
       height = 6)
