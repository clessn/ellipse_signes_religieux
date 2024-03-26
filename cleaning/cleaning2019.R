# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_canada2019_weights.csv") %>%
  filter(Q3 == "Quebec" | Q4 == "Quebec") %>%
  select(Q190, Q192, Q196, Q187, weight)

# Clean -------------------------------------------------------------------
clean_df <- tidyr::pivot_longer(raw_df, cols = c(Q190, Q192, Q196, Q187),
                                names_to = "symbol", values_to = "value") %>%

  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "Q190" ~ "hijab",
    symbol == "Q192" ~ "pendantif_croissant",
    symbol == "Q196" ~ "petite_croix",
    symbol == "Q187" ~ "grosse_croix"
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher"),
  year = 2019) %>%
  select(year, symbol, authority, teacher, weight)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2019.rds")
