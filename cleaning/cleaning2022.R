# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/pes_qc22_relig_symb/2022-11-09_pes_qc22_religious_symb_data.csv") %>%
  select(Q101, Q103, Q107, Q98)


# Clean -------------------------------------------------------------------

clean_df <- tidyr::pivot_longer(raw_df, cols = c(Q101, Q103, Q107, Q98),
                                names_to = "symbol", values_to = "value") %>%
  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "Q101" ~ "hijab",
    symbol == "Q103" ~ "pendantif_croissant",
    symbol == "Q107" ~ "petite_croix",
    symbol == "Q98" ~ "grosse_croix"
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher"),
  year = 2022,
  weight = NA) %>%
  select(year, symbol, authority, teacher, weight)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2022.rds")
