#This script will load the data from either the package or from Raw depending.. 

library(devtools)
install_github('ramhiser/datamicroarray')
data('khan', package = 'datamicroarray')
View(khan$x)
