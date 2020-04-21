#This script will load the data from either the package or from Raw depending.. 

library(readxl)
df <- read.csv(file = '/cloud/project/_raw/dmd.csv')
df

#To use tibble load tidyverse 
library(tidyverse)
filter(data = df, obsno== 1)
df_split
#---------------------Forget the following 
#Seperating the table (raw) into two tables
#We need to group the data in order to split it with dplyr
df_grouped <- df %>% 
  group_by(obsno)

df_split <- group_split(df_grouped)
df_split
