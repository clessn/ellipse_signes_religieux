# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_canada2015_weights.csv") %>%
  ### filter for Quebec
  filter(X1.2 == "Quebec") %>%
  select(X, all_of(paste0("X16.", 2:12)), ResponseId, RecipientEmail, weight)

# Clean -------------------------------------------------------------------
clean_df <- tidyr::pivot_longer(raw_df, cols = starts_with("X16"),
                                names_to = "symbol", values_to = "value") %>%
  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "X16.2" ~ "grosse_croix",
    symbol == "X16.3" ~ "burqa",
    symbol == "X16.4" ~ "chador",
    symbol == "X16.5" ~ "hijab",
    symbol == "X16.6" ~ "david",
    symbol == "X16.7" ~ "pendantif_croissant",
    symbol == "X16.8" ~ "kippa",
    symbol == "X16.9" ~ "kirpan",
    symbol == "X16.10" ~ "niqab",
    symbol == "X16.11" ~ "petite_croix",
    symbol == "X16.12" ~ "turban"
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher"),
  citizenship = clean_var(value, target = "citizenship"),
  student = clean_var(value, target = "students"),
  all_public = clean_var(value, target = "all_public"),
  year = 2015) %>%
  select(year, symbol, authority, teacher, citizenship, student, all_public,
         weight, ResponseId, RecipientEmail)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2015.rds")
