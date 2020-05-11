# Define project functions
# ------------------------------------------------------------------------------
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

#Logaritmic regression model:
log_reg_model_def <- function(df) {
  glm(carrier ~ PK + LD + H + CK, 
      family = binomial(link = "logit"), 
      data = data)}

#Simple linear model: 
simple_model_def <- function(df) {
  lm(carrier ~ LD + H + PK + CK,
     data = data)}

#density plot function
density_plot <- function(x_p) {
    ggplot(data = data, 
           mapping = aes(x = x_p, fill = carrier)) +
    geom_density(alpha = 0.5) + 
    labs(title = "Density plot of the CK values")
}

#Boxplot function 
boxplot_func <- function(x_protein){
  ggplot(data = data, 
         mapping = aes(x = age_group, y = x_protein, fill = carrier)) +
  geom_boxplot(alpha = 0.5) + 
  labs(title = "Distribution of levels of LD to age",
       x = "Age Group")+
  theme(legend.position = "none")
}

#Scatterplot function
scatter_func <- function(x_protein, y_protein){
  ggplot(mapping = aes(x = x_protein, y = y_protein, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of CK and LD")
}

#Confusion matrix plot:
confusion_matrix_plot <- function(Actual_values, Predicted_values, Y, title_input){
  ggplot(mapping = aes(x = Actual_values, y = Predicted_values)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y))) +
  scale_fill_gradient(low = "lightblue", high = "lightgreen") +
  theme_bw() + 
  theme(legend.position = "none") +
  labs(x = "Actual values", 
       y = "Predicted values", 
       title = title_input)
       #subtitle = "Threshold = 0.5")
}
