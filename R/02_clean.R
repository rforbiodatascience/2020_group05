# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/01_my_data.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
View(df)
# we look through our data to see if there are anything missing. 

count(df)
#192 patients

#we want to see if we can remove patients that has NA values and we do this by visualising 

# remove the patients that have NA values

df <- drop_na(df)
count(df)

#178 patients, so we dropped 14



# Write data
# ------------------------------------------------------------------------------
write_tsv(x = my_data_clean,
          path = "data/02_my_data_clean.tsv")

