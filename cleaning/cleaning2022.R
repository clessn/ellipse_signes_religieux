# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/pes_qc22_relig_symb/2022-11-09_pes_qc22_religious_symb_data.csv") %>%
  select(Q101, Q103, Q107, Q98,
         ## for weighting
         age_weight, gender_weight, language_weight, vote_weight) %>%
  mutate(id_respondent = 1:nrow(.))

# Symbols -------------------------------------------------------------------

df_symbols <- tidyr::pivot_longer(raw_df %>% select(id_respondent, Q101, Q103, Q107, Q98),
                                  cols = c(Q101, Q103, Q107, Q98),
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
  select(id_respondent, symbol, authority, teacher)

# Weights ----------------------------------------------------------------

raw_df_weights <- raw_df %>%
  mutate(age = case_when(
     age_weight == "18-29" ~ "18_29",
     age_weight == "30-39" ~ "30_39",
     age_weight == "40-49" ~ "40_49",
     age_weight == "50-64" ~ "50_64",
     age_weight == "65+" ~ "65_99"
  ),
  gender = case_when(
    gender_weight  %in% c("Female", "Woman", "Women") ~ "female",
    gender_weight  %in% c("Male", "Masculin", "Man", "Men") ~ "male"
  ),
  langue = case_when(
    language_weight == "FR" ~ "fr",
    language_weight == "EN" ~ "en"),
  langue = ifelse(!(language_weight %in% c("FR", "EN")), "other", langue),
vote_int = case_when(
  vote_weight == "CAQ" ~ "CAQ",
  vote_weight == "PQ" ~ "PQ",
  vote_weight == "LIB" ~ "PLQ",
  vote_weight == "QS" ~ "QS",
  vote_weight == "CON" ~ "PCQ",
  vote_weight %in% c("AUT", "Ne sais pas", "VERT")  ~ "other",
)) %>%
  select(id_respondent, age, gender, langue, vote_int) %>%
  tidyr::drop_na() %>%
  fastDummies::dummy_cols(select_columns = c("age", "gender", "langue", "vote_int"),
                          remove_selected_columns = TRUE)

marginals <- c(`(Intercept)` = 1,
               age_18_29 = 0.257,
               age_30_39 = 0.161,
               age_40_49 = 0.27,
               age_50_64 = 0.217,
               age_65_99 = 0.096,
               gender_female = 0.508,
               gender_male = 0.492,
               langue_fr = 0.771,
               langue_en = 0.075,
               langue_other = 0.154,
               vote_int_CAQ = 0.271,
               vote_int_PLQ = 0.095,
               vote_int_PQ = 0.097,
               vote_int_QS = 0.102,
               vote_int_PCQ = 0.085,
               vote_int_other = 0.35)
tmp_form <- paste(" ~ 1 +", paste(names(marginals)[names(marginals) != "(Intercept)"],
                                  collapse=" + "), sep = "")

surveyDesign <- survey::svydesign(id = ~ 1, #no clustering
                                  weights = ~ 1,
                                  data = raw_df_weights)

surveyDesign <- survey::calibrate(design     = surveyDesign,
                                  formula    = as.formula(tmp_form),
                                  calfun     = "raking",
                                  population = marginals,
                                  eps        = 0.005,
                                  maxit      = 20000)

weights <- setNames(weights(surveyDesign), 1:length(weights(surveyDesign)))

clean_df <- df_symbols %>%
  mutate(weight = weights[id_respondent],
         year = 2022) %>%
  select(year, symbol, authority, teacher, weight)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2022.rds")
