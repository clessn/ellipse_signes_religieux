# Packages ----------------------------------------------------------------
library(dplyr)

## Fonction pour nettoyer la variable (utilisée pour chaque sondage)
clean_var <- function(raw_vector, target = c("teacher", "authority")){
  patterns <- c("teacher" = "public school teachers",
                "authority" = "government officials")
  pattern <- patterns[target]
  output <- as.numeric(grepl(pattern = pattern, x = raw_vector))
  return(output)
}

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_canada2015_weights.csv") %>%
  ### filter for Quebec
  filter(X1.2 == "Quebec") %>%
  select(X, X16.5, X16.7, X16.11, X16.2, weight)

# Clean -------------------------------------------------------------------
clean_df <- tidyr::pivot_longer(raw_df, cols = c(X16.5, X16.7, X16.11, X16.2),
                                names_to = "symbol", values_to = "value") %>%
  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "X16.5" ~ "hijab",
    symbol == "X16.7" ~ "pendantif_croissant",
    symbol == "X16.11" ~ "petite_croix",
    symbol == "X16.2" ~ "grosse_croix"
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher"),
  year = 2015) %>%
  select(year, symbol, authority, teacher, weight)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2015.rds")
