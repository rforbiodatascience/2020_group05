# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("naniar")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/01_df.tsv", col_names = TRUE)
df_carrier <- read_tsv(file = "data/01_carrier_data.tsv")

# Wrangle data df
# ------------------------------------------------------------------------------

# View data to check for anomalities, NAs and other elements in the data.
df

# Visual of missing data
vis_miss(df)

# Plot of missing data, 
# where the missing data is shifted 10% under the minimum value
ggplot(df, aes(x = LD,  y = PK)) +
  geom_miss_point()

# We need to remove the first three columns, since they are redundant for the data.
# Additionally, we need to remove the 8th column since it only contains 0s

df <- df %>% 
      select(- c(X1, X2, X3, X8))

# Add column names
df <- df %>% 
      rename(ObservationNumber = X4, 
             ID = X5,
             Age = X6,
             Month = X7,
             Year = X9,
             CK = X10,
             H = X11,
             PK = X12,
             LD = X13)

# Add column names to carrier data
df_carrier <- df_carrier %>% 
  rename(ID = X1,
         carrier = X2)

# We also need to change the 9th column from 079 etc. to year (1979)
df <- df %>% 
      mutate(Year = case_when(Year == '077' ~ 1977,
                              Year == '078' ~ 1978,
                              Year == '079' ~ 1979,
                              Year == '080' ~ 1980))

# Change values of -9999 to NA
df <- df %>%
      mutate(LD = na_if(LD, '-9999'), 
             PK = na_if(PK, '-9999'))

# Count the NAs to see if we can remove the observation
# FIND A WAY TO MAKE THIS WORK

# Wrangle data df_carrier
# ------------ß------------------------------------------------------------------
df_carrier <- df_carrier %>% 
              select(hospid, carrier) %>%
              rename(ID = hospid)

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = df,
          path = "data/02_clean_data_df.tsv")
write_tsv(x = df_carrier,
          path = "data/02_clean_data_df_carrier.tsv")

