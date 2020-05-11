# 2020_group05
## Description: 
Duchenne Muscular Dystrophy (DMD) is a rare, genetic disorder that causes progressive degeneration and atrophy of skeletal and heart muscles. Most females with this mutation show no evidence of muscular weakness, but they are able to pass the mutation on to their offspring without showing any symptoms.our enzyme and serum proteins have been linked to carrier status in asymptomatic females. These include creatine kinase (CK), hemopexin (H), lactate dehydroginase (LD) and pyruvate kinase (PK), which are measured in blood samples from serum. 

## Data:
The raw data consist of two datasets. One contains 209 observations from bloodsamples, with 13 variables. Most importantly, the measured enzyme levels of the four serum markers. The other dataset contains the information on which observation is a carrier (75 samples) or non-carrier (134 samples). 
Other varibles such as hospital id, age and data of sample is also included in the data. 

### Goal:
Create different models which can asses if the woman is likely to be a carrier or not.  

## Software Requirements:
* R 

R packages: 

* Tidyverse
* Devtools
* Keras
* rsample
* tidymodels
* broom 
* purr
* ggrepel
* shiny
* patchwork
 
## Installation:
The following code download this data analysis pipeline, when run in the terminal: ??

```{r}
git clone https://github.com/rforbiodatascience/2020_group05
```
 
## Usage:
In the '/R' run '00_doit.R'.
It will check that all nessary packages are installed and download them in case they are not. 
Then the script will run every script in the correct order. All generated data will be placed in '/data', while the outputted plots will can be found in '/results'. 
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
- [X] Plots good names and numbers
- [X] tidycheck

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
