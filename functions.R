clean_var <- function(raw_vector, target = c("teacher", "authority", "citizenship",
                                             "students", "all_public")){
  patterns <- c("teacher" = "public school teachers",
                "authority" = "government officials",
                "citizenship" = "citizenship ceremony",
                "students" = "students",
                "all_public" = "public spaces")
  pattern <- patterns[target]
  output <- as.numeric(grepl(pattern = pattern, x = raw_vector))
  return(output)
}
