#TEST FOR THE VARIANCE EXPLAINED
library(tidyverse)
library(broom)
library(knitr)
#library(ggfortify)

#data
USArrests %>% head() %>% knitr::kable()
us_arrests <- USArrests %>% 
  rownames_to_column(var = "state") %>% 
  # I prefer column names to be all lowercase so I am going to change them here
  rename_all(tolower) %>% 
  as_tibble()

us_arrests
#pca
us_arrests_pca <- us_arrests %>% 
  group_nest() %>% 
  mutate(pca = map(data, ~ prcomp(.x %>% select(-state), 
                                  center = TRUE, scale = TRUE)),
         pca_aug = map2(pca, data, ~augment(.x, data = .y)))
