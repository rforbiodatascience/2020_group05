# 2020_group05
## Description of the data: 
209 observations correspond to blood samples on 192 patients (17 patients have two samples in the dataset)

### Background for study: 
Enzyme levels were measured in known carriers (75 samples) and in a group of non-carriers (134 samples). 
Anomaly of the dataset: 16 out of 17 subjects having two blood samples drawn had differing carrier status for the two observations.

### Goals:
Investigate the chance of a women being a carrier of DMD  based on serum markers and family pedigree. 
Another question of interest is whether age and season should be taken into account. It is of interest to measure how much pk and ld add toward predicting the carrier status. The importance of age and sample date is also of interest.
 
## Running the scripts:
In the folder 'R', the script 00_doit.R is placed. Run this script and it will check that all nessary packages are installed and download them in case they are not. 
Then the script will run every script in the correct order. All generated data will be placed in data, while the outputted plots will can be found in results. 
Further documentation can be found in the folder doc.


#-----Delete this at some point:!!!!
## To do List: 

Monday:
Tobias: 
- [] Finish Shiny App (make folder or repo as we wish)

Cecilie:
- [x] Make functions work (Non standard evaluation)
- [X] Make function for confusionmatrix 

Astrid: 
- [X] correct linar model confusion matrix 
- [X] change name of simple model

Carina:
- [X] Change confusion matrix axis reversed
- [] Plots good names and numbers
- [] Begin tidycheck

- [x] Make stratification for ANN work 
- [X] Maybe add AGE as a variable to the models? - No see plot


Tuesday:
- [] Make sure it can run start to finish in one go
- [] Make presentation 
- [] Written here 'how to run the scripts'
- [] Go through learning objectives

----Everything tidy check
- [] 00_doit
- [] 01_load
- [] 02_clean
- [] 03_augment
- [] 04_
- [] ....
- [] pca

Wednesday:
- [] Practice presentation
