#This script wil clean the data 
library(tidyverse)
df <- read_csv(file = '/cloud/project/_raw/dmd_1.csv')

View(df)
# we look through our data to see if there are anything missing. 

count(df)
#192 patients

#we want to see if we can remove patients that has NA values and we do this by visualising 

# remove the patients that have NA values

df <- drop_na(df)
count(df)

#178 patients, so we dropped 14

