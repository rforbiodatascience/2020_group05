
# Set working directory ---------------------------------------------------
setwd('/cloud/project/')


# Check packages ----------------------------------------------------------
# Checking for the required packages download if not present
packages <- c("tidyverse",
              "devtools",
              "keras",
              "rsample",
              "tidymodels",
              "broom",
              "purrr",
              "ggrepel",
              "shiny",
              "patchwork")

install.packages(setdiff(packages, rownames(installed.packages())))


# Run all files -----------------------------------------------------------
source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")
source(file = "R/04_visualisation.R")
source(file = "R/04_pca.R")
source(file = "R/04_analysis_ann.R") 
source(file = "R/04_linear_models.R")
