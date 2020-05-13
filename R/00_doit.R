# Set working directory ---------------------------------------------------
setwd("/cloud/project/")

# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")


# Check packages ----------------------------------------------------------
# Checking for the required packages download if not present
install_if_needed(c("tidyverse",
                    "devtools",
                    "keras",
                    "rsample",
                    "broom",
                    "purrr",
                    "ggrepel",
                    "shiny",
                    "patchwork",
                    "shinythemes"))


# Run all files -----------------------------------------------------------
source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")
source(file = "R/04_visualisation.R")
source(file = "R/05_pca.R")
source(file = "R/06_linear_models.R")
source(file = "R/07_ann_model.R")
