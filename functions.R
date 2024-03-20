clean_var <- function(raw_vector, target = c("teacher", "autority")){
  patterns <- c("teacher" = "public school teachers",
                "autority" = "government officials")
  pattern <- patterns[target]
  output <- as.numeric(grepl(pattern = pattern, x = raw_vector))
  return(output)
}
