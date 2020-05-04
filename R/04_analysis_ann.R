# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")
library("keras")
library("devtools")
#install_keras(tensorflow = "1.13.1") # KØR DENNE FØRSTE GANG PÅ DIN RSTUDIO CLOUD

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_proj_func.R")

# Load data
# ------------------------------------------------------------------------------
df <- read_tsv(file = "data/03_aug_data.tsv", col_types = cols(carrier = col_factor()))
df <- df %>% drop_na()

# Wrangle data
# ------------------------------------------------------------------------------
nn_dat <- df %>% 
  select(CK, H, PK, LD, carrier) %>% 
    mutate(CK = normalize(CK),
           H = normalize(H),
           PK = normalize(PK),
           LD = normalize(LD)) %>% 
      rename(CK_feat = CK,
             H_feat = H,
             PK_feat = PK,
             LD_feat = LD) %>% 
        mutate(class_num = as.numeric(carrier) - 1,
               class_label = ifelse(carrier == 0, 'non-carrier', 'carrier'))

nn_dat %>% 
  head(3)

# Split into training/test set
# ------------------------------------------------------------------------------
test_f <- 0.20
nn_dat <- nn_dat %>%
  mutate(partition = sample(x = c('train','test'),
                            size = nrow(.),
                            replace = TRUE,
                            prob = c(1 - test_f, test_f)))

nn_dat %>% count(partition)

# Train partition
x_train <- nn_dat %>%
  filter(partition == 'train') %>%
  select(contains("feat")) %>%
  as.matrix

y_train <- nn_dat %>%
  filter(partition == 'train') %>%
  pull(carrier) %>% 
  to_categorical(2)

# Test partition
x_test <- nn_dat %>%
  filter(partition == 'test') %>%
  select(contains("feat")) %>%
  as.matrix

y_test <- nn_dat %>%
  filter(partition == 'test') %>%
  pull(carrier) %>% 
  to_categorical(2)

# Define the model
# ------------------------------------------------------------------------------
model <- keras_model_sequential() %>% 
  layer_dense(units = 2, activation = 'relu', input_shape = 4, kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 4, activation = 'relu', kernel_initializer = 'random_normal') %>% 
  layer_dense(units = 2, activation = 'sigmoid', kernel_initializer = 'random_normal')

# Compile model
model %>%
  compile(loss = 'binary_crossentropy',
          optimizer = 'adam',
          metrics = c('accuracy'))

model %>%
  summary

# Train the ANN
# ------------------------------------------------------------------------------
history <- model %>%
          fit(x = x_train,
              y = y_train,
              epochs = 300,
              batch_size = 10)

plot(history) 

# Evaluate network performance
perf <- model %>% 
       evaluate(x_test, y_test)
perf

nn_dat <- nn_dat %>%
  filter(partition == 'test') %>%
  mutate(class_num = factor(class_num),
         y_pred = factor(predict_classes(model, x_test)),
         Correct = factor(ifelse(class_num == y_pred, "Yes", "No")))

plot_dat %>% 
  select(-contains("feat")) %>% 
  head(3)

# Visualization
# ------------------------------------------------------------------------------
title     = "Classification Performance of Artificial Neural Network"
sub_title = str_c("Accuracy = ", round(perf$acc, 3) * 100, "%")
x_lab     = "True carrier"
y_lab     = "Predicted carrier"
plt1 <- plot_dat %>% 
  ggplot(aes(x = class_num, y = y_pred, colour = Correct)) +
  geom_jitter() +
  scale_x_discrete(labels = levels(nn_dat$class_label)) +
  scale_y_discrete(labels = levels(nn_dat$class_label)) +
  theme_bw() +
  labs(title = title, subtitle = sub_title, x = x_lab, y = y_lab)

# Confusing matrix
# ------------------------------------------------------------------------------
confmatplot <- function(G, GHAT){
  # Plot confusion matrix based on the true labels in G and the predicted labels in GHAT
  #
  # Author: Laura Frølich, lff@imm.dtu.dk
  # Edited by (november 2018): Martin J�rgensen, marjor@dtu.dk
  
  cm =  table(G, GHAT)
  classes <- sort(unique(c(G, GHAT))) # classes in alphabetical order
  nclasses <- length(classes)
  
  if(dim(cm)[2]<nclasses){
    presentCols <- colnames(cm)
    matchingcols <- match(presentCols, classes)
    mismatchingcols <- (1:nclasses)[-matchingcols]
    while(length(mismatchingcols)!=0){
      icol <- mismatchingcols[1]
      ## new code
      if(icol == 1){
        cm <- cbind(rep(0, times = dim(cm)[1]), cm[,1:dim(cm)[2]])
      }else if( icol == nclasses){
        cm <- cbind(cm[,1:dim(cm)[2]],rep(0, times = dim(cm)[1]))
      }else{
        cm <- cbind(cm[,1:(icol-1)],rep(0,times = dim(cm)[1]),cm[,icol:dim(cm)[2]])
      }
      mismatchingcols <- mismatchingcols[-1]
      ##
    }
    colnames(cm) <- classes[1:dim(cm)[2]]
    presentCols <- colnames(cm)
    matchingcols <- match(presentCols, classes)
    mismatchingcols <- (1:nclasses)[-matchingcols]
  }  
  
  
  nclasses <- dim(cm)[1]
  classNames <- colnames(cm)
  
  image(1:nclasses, 1:nclasses, t(cm[nclasses:1,]), 
        main='Confusion matrix', xlab='Predicted carrier', ylab="Actual carrier", xaxt="n", yaxt="n", col=heat.colors(nclasses^2)[(nclasses^2):1])
  
  errorrate <- (sum(cm)-sum(diag(cm)))/sum(cm)*100 # error rate
  accuracy <- (sum(diag(cm)))/sum(cm)*100 # accuracy
  
  mtext(paste('Accuracy = ', round(accuracy, digits=3), '%, Error Rate = ', round(errorrate, digits=3), '%', sep=''))
  
  axisseq <- 1:nclasses
  axis(1, at=axisseq, labels=FALSE)
  axis(2, at=axisseq, labels=FALSE)
  
  text(par("usr")[1] - 0.15, axisseq, srt = 90, adj = 0.5, labels = classNames[length(classNames):1], xpd = TRUE) #?
  text(axisseq, par("usr")[3] - 0.15, srt = 0, adj = 0.5, labels = classNames, xpd = TRUE)
  
  for(iclass in 1:nclasses){
    for(jclass in 1:nclasses){
      text(jclass, iclass, labels=cm[length(classNames)-iclass+1,jclass])
    }
  }
}

confmatplot(as.numeric(nn_dat$class_num) -  1, as.numeric(nn_dat$y_pred) - 1)

# Write data
# ------------------------------------------------------------------------------
ggsave(filename = "results/ann_classification.png",
       plot = plt1,
       width = 10,
       height = 6)

