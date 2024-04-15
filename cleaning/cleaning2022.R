# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/pes_qc22_relig_symb/2022-11-09_pes_qc22_religious_symb_data.csv") %>%
  select(Q101, Q103, Q107, Q98,
         ## for weighting
         age_weight, gender_weight, language_weight) %>%
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
  langue = ifelse(!(language_weight %in% c("FR", "EN")), "other", langue)
  ) %>%
  select(id_respondent, age, gender, langue) %>%
  tidyr::drop_na() %>%
  fastDummies::dummy_cols(select_columns = c("age", "gender", "langue"),
                          remove_selected_columns = TRUE)

marginals <- c(`(Intercept)` = 1,
               age_18_29 = 0.1689,
               age_30_39 = 0.1586,
               age_40_49 = 0.1590,
               age_50_64 = 0.2575,
               age_65_99 = 0.2560,
               gender_female = 0.5065,
               gender_male = 0.4935,
               langue_fr = 0.8219,
               langue_en = 0.1295,
               langue_other = 0.0486)
tmp_form <- paste(" ~ 1 +", paste(names(marginals)[names(marginals) != "(Intercept)"],
                                  collapse=" + "), sep = "")

surveyDesign <- survey::svydesign(id = ~ 1, #no clustering
                                  weights = ~ 1,
                                  data = raw_df_weights)

surveyDesign <- survey::calibrate(design     = surveyDesign,
                                  formula    = as.formula(tmp_form),
                                  calfun     = "raking",
                                  population = marginals,
                                  #eps        = 0.005,
                                  maxit      = 20000)

weights <- setNames(weights(surveyDesign), 1:length(weights(surveyDesign)))

clean_df <- df_symbols %>%
  mutate(weight = weights[id_respondent],
         year = 2018) %>%
  select(year, symbol, authority, teacher, weight)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2022.rds")
