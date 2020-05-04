# LINEAR MODELS AND SO ON!!!!!!
# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/01_df.tsv", col_names = TRUE)
df_carrier <- read_tsv(file = "data/01_carrier_data.tsv")

# Wrangle data df