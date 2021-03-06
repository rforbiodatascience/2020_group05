# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
df         <- read_tsv(file = "data/02_clean_data_df.tsv")
df_carrier <- read_tsv(file = "data/02_clean_data_df_carrier.tsv", 
                       col_types = cols(carrier = col_factor()))


# Wrangle data ------------------------------------------------------------
# Add season based on month
df_aug <- df %>% 
  mutate(season = case_when(Month == "1"| Month == "2" |  Month == "12" ~ "Winter",
                            Month == "3"| Month == "4" |  Month == "5"  ~ "Spring",
                            Month == "6"| Month == "7" |  Month == "8"  ~ "Summer",
                            Month == "9"| Month == "10" | Month == "11" ~ "Fall")
         )

# Change hospital ID from random number to periodical number
df_aug <- df_aug %>% 
  mutate(ID = 501:709)

# Add carrier status
df_aug <- left_join(df_aug, df_carrier)

# Remove NA
df_aug <- drop_na(df_aug)


# Write data --------------------------------------------------------------
write_tsv(x = df_aug,
          path = "data/03_aug_data.tsv")

# Write data to Shiny-App -------------------------------------------------
write_tsv(x = df_aug,
          path = "DMD_predictor/data/03_aug_data.tsv")
