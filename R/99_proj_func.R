# Define project functions
# ------------------------------------------------------------------------------

# Check wether a package is installed or not
is_installed <- function (pkg) {
  if (system.file(package = pkg) == "")
    FALSE
  else
    TRUE
}

# Install a package or packages if not already installed.
install_if_needed <- function(pkgs) {
  installed_idx <- vapply(pkgs, is_installed, TRUE)
  needed <- pkgs[!installed_idx]
  if (length(needed) > 0) {
    message("Installing needed packages from CRAN: ", paste(needed, collapse = ", "))
    install.packages(needed)
  }
}

# Normalisation function
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Logistic classification model:
log_reg_model_def <- function(df) {
  glm(carrier ~ PK + LD + H + CK, 
      family = binomial(link = "logit"), 
      data = data)}

# Linear model: 
simple_model_def <- function(df) {
  lm(carrier ~ LD + H + PK + CK,
     data = data)}

# Density plot function
density_plot <- function(data, x_p) {
    ggplot(data = data, 
           mapping = aes(x = {{x_p}}, fill = carrier)) +
    geom_density(alpha = 0.5) + 
    labs(title = "Density plot of the CK values")
}

# Boxplot function 
boxplot_func <- function(x_protein){
  ggplot(data = data, 
         mapping = aes(x = age_group, y = x_protein, fill = carrier)) +
  geom_boxplot(alpha = 0.5) + 
  labs(title = "Distribution of levels of LD to age",
       x = "Age Group")+
  theme(legend.position = "none")
}

# Scatterplot function
scatter_func <- function(x_protein, y_protein){
  ggplot(mapping = aes(x = x_protein, y = y_protein, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = "Distribution of levels of CK and LD")
}

# Confusion matrix plot:
confusion_matrix_plot <- function(Actual_values, Predicted_values, confusion_matrix, goodbad, title_input, subtitle_input){
  ggplot(mapping = aes(x = Actual_values, y = Predicted_values, fill = goodbad)) +
  geom_tile(color = "grey", size = 1, alpha = 0.9) +
  geom_text(aes(label = sprintf("%1.0f", confusion_matrix)), fontface = "bold", size = 10) +
  scale_fill_manual(values = c(good = "forestgreen", bad = "indianred3")) +
  theme_bw() + 
  theme(legend.position = "none") +
  labs(x = "Actual values", 
       y = "Predicted values", 
       title = title_input,
       subtitle = subtitle_input)
}