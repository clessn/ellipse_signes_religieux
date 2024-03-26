# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_qc2018.csv") %>%
  select(Q18.4, Q18.6, Q18.10, Q18.2)

# Clean -------------------------------------------------------------------

clean_df <- tidyr::pivot_longer(raw_df, cols = c(Q18.4, Q18.6, Q18.10, Q18.2),
                                names_to = "symbol", values_to = "value") %>%
  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "Q18.4" ~ "hijab",
    symbol == "Q18.6" ~ "pendantif_croissant",
    symbol == "Q18.10" ~ "petite_croix",
    symbol == "Q18.2" ~ "grosse_croix"
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher"),
  year = 2018,
  weight = NA) %>%
  select(year, symbol, authority, teacher, weight)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2018.rds")
