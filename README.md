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

* tidyverse 1.3.0
* devtools 2.3.0
* keras 2.2.5.0
* rsample 0.0.6
* broom 0.5.6
* purr 0.3.4
* ggrepel 0.8.2
* shiny 1.4.0.2
* patchwork 1.0.0
 
## Installation:
The following code download this data analysis pipeline, when run in the terminal:

```{r}
git clone https://github.com/rforbiodatascience/2020_group05
```
In case keras installation is causing trouble, try installing it as followes:

```{r}
install_github("rstudio/keras")
# Would you like to install miniconda? Y
library(keras)
install_keras(tensorflow = "1.13.1")
```
 
## Usage:
In the '/R' run '00_doit.R'.
It will check that all nessary packages are installed and download them in case they are not. 
Then the script will run every script in the correct order. All generated data will be placed in '/data', while the outputted plots will can be found in '/results'. 
Further documentation can be found in the folder doc.


#-----Delete this at some point:!!!!
## To do List: 

Tuesday:
Small practical stuff missing: 
- [] Linear into app (Tobias)
- [] Make axis logarithmic on protein-protein plot - ALTERNATIVELY, CHANGE THE PLOT (Astrid)
- [X] Change PCA variance explained a little (carina)
- [X] ROC plot Legend change (Astrid)


- [] Make presentation 
- [X] Make sure it can run start to finish in one go
- [X] Written here 'how to run the scripts'
- [X] Go through learning objectives 
- [X] Go through all the plots

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
