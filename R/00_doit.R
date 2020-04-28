# Run all scripts!
# ------------------------------------------------------------------------------
setwd('/cloud/project/')

# Checking for the required packages
# download if not present
packages <- c("tidyverse",
              "caret",
              "naniar",
              "devtools",
              "keras")
install.packages(setdiff(packages, rownames(installed.packages())))

source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")

# PCA
source(file = "R/04_analysis_i.R")

# ANN
source(file = "R/04_analysis_iii.R")