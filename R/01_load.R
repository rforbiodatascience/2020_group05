#This script will load the data from either the package or from Raw depending.. 
library(tidyverse)
df <- read_tsv(file = '/cloud/project/data/_raw/T38.tsv', col_names = FALSE)

View(df)

