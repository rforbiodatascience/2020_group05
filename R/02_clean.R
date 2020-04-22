# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Load data
# ------------------------------------------------------------------------------
df <- read_csv(file = "data/_raw/01_dmd.csv")

# Wrangle data
# ------------------------------------------------------------------------------

# View data to check for anomalities, NAs and other elements in the data.
View(df)
count(df)

# Are there any numbers we should round up/down?
df <- df %>% 
  mutate(pk = round(pk, 3))

# Are there anything we should group?

# Are there any NAs?
# Yes


# Alternatively, make a tibble and look through this


#we want to see if we can remove patients that has NA values and we do this by visualising 
df <- drop_na(df)
count(df)
#178 patients, so we dropped 14



# Write data
# ------------------------------------------------------------------------------
write_tsv(x = my_data_clean,
          path = "data/02_my_data_clean.tsv")

