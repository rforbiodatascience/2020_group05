# Define project functions
# ------------------------------------------------------------------------------
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
func2 <- function(x){
  return(x^2)
}
...