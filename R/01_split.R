#This script will load the data from either the package or from Raw depending.. 
library(tidyverse)
df <- read_csv(file = '/cloud/project/data/_raw/dmd.csv')

#Splitting the data so we can fake joining 
df_split1 <- df %>% filter(obsno == 1)
df_split2 <- df %>% filter(obsno == 2)

#Moving the two new 'raw data sets' into _raw 
write_csv(df_split1, '/cloud/project/data/_raw/dmd_obsno_1.csv', append = FALSE, quote_escape = "double")
write_csv(df_split2, '/cloud/project/data/_raw/dmd_obsno_2.csv', append = FALSE, quote_escape = "double")
