# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_canada2019_weights.csv") %>%
  filter(Q3 == "Quebec" | Q4 == "Quebec") %>%
  select(Q187, Q188, Q189, Q190, Q191, Q192, Q193, Q194, Q195, Q196, Q197, weight, ResponseId, RecipientEmail...9)

# Clean -------------------------------------------------------------------
clean_df <- tidyr::pivot_longer(raw_df, cols = c(Q187, Q188, Q189, Q190, Q191, Q192, Q193, Q194, Q195, Q196, Q197),
                                names_to = "symbol", values_to = "value") %>%

  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "Q187" ~ "grosse_croix",
    symbol == "Q188" ~ "burqa",
    symbol == "Q189" ~ "chador",
    symbol == "Q190" ~ "hijab",
    symbol == "Q191" ~ "david",
    symbol == "Q192" ~ "pendantif_croissant",
    symbol == "Q193" ~ "kippa",
    symbol == "Q194" ~ "kirpan",
    symbol == "Q195" ~ "niqab",
    symbol == "Q196" ~ "petite_croix",
    symbol == "Q197" ~ "turban",
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher"),
  year = 2019) %>%
  select(year, symbol, authority, teacher, weight, ResponseId, RecipientEmail = RecipientEmail...9)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2019.rds")
