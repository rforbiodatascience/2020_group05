# Set working directory ---------------------------------------------------
setwd("/cloud/project/")


# Define functions --------------------------------------------------------
source(file = "R/99_proj_func.R")


# Check packages ----------------------------------------------------------
# Checking for the required packages download if not present
install_if_needed(c("tidyverse",
                    "devtools",
                    "keras",
                    "rsample",
                    "tidymodels",
                    "broom",
                    "purrr",
                    "ggrepel",
                    "shiny",
                    "patchwork"))


# Run all files -----------------------------------------------------------
source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")
source(file = "R/04_visualisation.R")
source(file = "R/04_pca.R")
source(file = "R/04_analysis_ann.R") 
source(file = "R/04_linear_models.R")
