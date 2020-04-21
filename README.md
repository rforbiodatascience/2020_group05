# 2020_your_github_user_name

## Questions/Agenda for 20-04-2020

* Are the dataset okay?
* What we imagine we can do with the data
* When is the hand-in

## Description of the data: 
209 observations correspond to blood samples on 192 patients (17 patients have two samples in the dataset)

### Background for study: 
Enzyme levels were measured in known carriers (75 samples) and in a group of non-carriers (134 samples). 
Anomaly of the dataset: 16 out of 17 subjects having two blood samples drawn had differing carrier status for the two observations.

### Goals:
Investigate the chance of a women being a carrier of DMD  based on serum markers and family pedigree. 
Another question of interest is whether age and season should be taken into account. It is of interest to measure how much pk and ld add toward predicting the carrier status. The importance of age and sample date is also of interest.
 
## To do List: 

* Clean data (Contains 8 NAs)
* Make it up to tidy-format
* PCA analysis for at undersøge hvor mange components beskriver variabiliteten.
* See if there is a correlation between level of enzymes and status of women as carriers. Take age + season into account (optional).
* Shiny app - Are you a carrier or..? 


