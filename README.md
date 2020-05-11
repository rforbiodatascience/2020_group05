# 2020_group05
## Description of the data: 
209 observations correspond to blood samples on 192 patients (17 patients have two samples in the dataset)

### Background for study: 
Enzyme levels were measured in known carriers (75 samples) and in a group of non-carriers (134 samples). 
Anomaly of the dataset: 16 out of 17 subjects having two blood samples drawn had differing carrier status for the two observations.

### Goals:
Investigate the chance of a women being a carrier of DMD  based on serum markers and family pedigree. 
Another question of interest is whether age and season should be taken into account. It is of interest to measure how much pk and ld add toward predicting the carrier status. The importance of age and sample date is also of interest.
 
##Running the scripts:
In the folder 'R', the script 00_doit.R is placed. Run this script and it will check that all nessary packages are installed and download them in case they are not. 
Then the script will run every script in the correct order. All generated data will be placed in data, while the outputted plots will can be found in results. 
Further documentation can be found in the folder doc.


#-----Delete this at some point:!!!!
## To do List: 

Monday:
- [] Finish Shiny App
- [] Make functions work 
- [] make function for confusionmatrix 
- [x] Make stratification for ANN work 
- [] Maybe add AGE as a variable to the models?

Tuesday:
- [] Make sure it can run start to finish in one go
- [] Finished markdown
- [] Written here 'how to run the scripts'
- [] Go through scripts to make sure everything is 'Tidy'
- [] Go throug learning objectives

Wednesday:
- [] Practice presentation

##Questions
- Hvordan skal det skrives/presenteres?
- Er præsentation 20 min? 
- Functioner virker ikke..??
- Shiny app, skal vi have flere modeller eller bare én
- Skal den have sit eget repo. 