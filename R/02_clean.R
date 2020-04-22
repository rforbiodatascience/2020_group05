# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/_raw/T38.tsv", col_names = FALSE)

# Wrangle data
# ------------------------------------------------------------------------------

# View data to check for anomalities, NAs and other elements in the data.
View(df)

# We need to remove the first three columns, since they are redundant for the data.
# Additionally, we need to remove the 8th column since it only contains 0s

df <- df %>% 
  select(- c(X1, X2, X3, X8))

# Add column names

df <- df %>% 
  rename( ObservationNumber = X4, 
          ID = X5,
          Age = X6,
          Month = X7,
          Year = X9,
          CK = X10,
          H = X11,
          PK = X12,
          LD = X13)

# We also need to change the 9th column from 079 etc. to year (1979)
df <- df %>% 
  mutate(Year = case_when(Year == '077' ~ 1977,
                          Year == '078' ~ 1978,
                          Year == '079' ~ 1979,
                          Year == '080' ~ 1980
                          ))

# Change values of -9999 to NA
df <- df %>% 
# Count the NAs to see if we can remove the observation




View(df)

# Write data
# ------------------------------------------------------------------------------
write_csv(x = df,
          path = "data/02_clean_data.csv")
