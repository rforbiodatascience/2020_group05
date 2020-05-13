
# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
df <- read_tsv(file = "data/_raw/T38.tsv", col_names = FALSE)
df_carrier <- read_tsv(file = "data/_raw/dmd_carrier.tsv", col_names = FALSE)


# Write data --------------------------------------------------------------
write_tsv(x = df,
          path = "data/01_df.tsv")
write_tsv(x = df_carrier,
          path = "data/01_carrier_data.tsv")
