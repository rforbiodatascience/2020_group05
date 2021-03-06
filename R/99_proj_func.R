# Define project functions

# Install packages --------------------------------------------------------
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


# Plots -------------------------------------------------------------------
# Density plot function
density_plot <- function(data, x_p, title_input) {
    ggplot(data = data, 
           mapping = aes(x = {{x_p}}, fill = carrier)) +
    geom_density(alpha = 0.5) + 
    labs(title = title_input)
}

# Boxplot function 
boxplot_func <- function(data, x_protein, age_group, title_input, x_label_input){
  ggplot(data = data, 
         mapping = aes(x = {{age_group}}, y = {{x_protein}}, fill = carrier)) +
  geom_boxplot(alpha = 0.5) + 
  labs(title = title_input,
       x = "Age Group") +
  theme(legend.position = "none")
}

# Scatterplot function
scatter_func <- function(data, x_protein, y_protein, title_input){
  ggplot(data = data,
         mapping = aes(x = {{x_protein}}, y = {{y_protein}}, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = title_input)
}

# Scatterplot with logarithmic x-scale
scatter_func_log <- function(data, x_protein, y_protein, title_input){
  ggplot(data = data,
         mapping = aes(x = {{x_protein}}, y = {{y_protein}}, fill = carrier)) +
  geom_point(pch = 21) + 
  labs(title = title_input) +
  scale_x_log10()
}


# Models ------------------------------------------------------------------
# Logistic classification model
log_reg_model_def <- function(df) {
  glm(carrier ~ PK + LD + H + CK, 
      family = binomial(link = "logit"), 
      data = data)}

# Linear model 
linear_model_def <- function(df) {
  lm(carrier ~ LD + H + PK + CK,
     data = data)}

# Confusion matrix plot
confusion_matrix_plot <- function(confusion_matrix, title_input, subtitle_input){
  Actual_values    <- factor(c(1, 0, 0, 1))
  Predicted_values <- factor(c(1, 0, 1, 0))
  goodbad          <- factor(c("good", "good", "bad", "bad"))
  
  ggplot(mapping = aes(x = Predicted_values, y = Actual_values, fill = goodbad)) +
  geom_tile(color = "grey", size = 1, alpha = 0.9) +
  geom_text(aes(label = sprintf("%1.0f", confusion_matrix)), fontface = "bold", size = 10) +
  scale_fill_manual(values = c(good = "forestgreen", bad = "indianred3")) +
  theme_bw() + 
  theme(legend.position = "none") +
  labs(x = "Predicted Values", 
       y = "Actual Values", 
       title = title_input,
       subtitle = subtitle_input)
}
