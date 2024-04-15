# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_qc2018.csv") %>%
  select(Q18.4, Q18.6, Q18.10, Q18.2,
         ## for weighting
         Q23.2, Q23.1, UserLanguage, Q21.8) %>%
  mutate(id_respondent = 1:nrow(.))


## variables for weighting
# age
table(raw_df$Q23.2)

# gender
table(raw_df$Q23.1)

# langue
table(raw_df$UserLanguage, useNA = "always")
table(raw_df$Q21.8, useNA = "always")

# Clean -------------------------------------------------------------------

clean_df <- data.frame(
  id_respondent = 1:nrow(raw_df)
)


# Symbols -----------------------------------------------------------------
df_symbols <- tidyr::pivot_longer(raw_df %>% select(id_respondent, Q18.4, Q18.6, Q18.10, Q18.2),
                                  cols = c(Q18.4, Q18.6, Q18.10, Q18.2),
                                names_to = "symbol", values_to = "value") %>%
  tidyr::drop_na(value) %>%
  mutate(symbol = case_when(
    symbol == "Q18.4" ~ "hijab",
    symbol == "Q18.6" ~ "pendantif_croissant",
    symbol == "Q18.10" ~ "petite_croix",
    symbol == "Q18.2" ~ "grosse_croix"
  ),
  authority = clean_var(value, target = "authority"),
  teacher = clean_var(value, target = "teacher")) %>%
  select(id_respondent, symbol, authority, teacher)


# Weights -----------------------------------------------------------------

raw_df_weights <- raw_df %>%
  mutate(age = case_when(
    (2018 - Q23.2) %in% 18:34 ~ "18_34",
    (2018 - Q23.2) %in% 35:44 ~ "35_44",
    (2018 - Q23.2) %in% 45:59 ~ "45_59",
    (2018 - Q23.2) %in% 60:74 ~ "60_74",
    (2018 - Q23.2) %in% 75:99 ~ "75_99"
  ),
  gender = case_when(
    Q23.1  %in% c("Female", "Woman", "Women") ~ "female",
    Q23.1  %in% c("Male", "Masculin", "Man", "Men") ~ "male"
  ),
  langue = case_when(
    UserLanguage == "FR" ~ "fr",
    UserLanguage == "EN" ~ "en"),
  langue = ifelse(!(Q21.8 %in% c("French", "Français", "English")), "other", langue)
  ) %>%
  select(id_respondent, age, gender, langue) %>%
  tidyr::drop_na() %>%
  fastDummies::dummy_cols(select_columns = c("age", "gender", "langue"),
                          remove_selected_columns = TRUE)

marginals <- c(`(Intercept)` = 1,
               age_18_34 = 0.257,
               age_35_44 = 0.161,
               age_45_59 = 0.27,
               age_60_74 = 0.217,
               age_75_99 = 0.096,
               gender_female = 0.508,
               gender_male = 0.492,
               langue_fr = 0.771,
               langue_en = 0.075,
               langue_other = 0.154)
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
         year = 2018) %>%
  select(year, symbol, authority, teacher, weight)


# Save --------------------------------------------------------------------
saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2018.rds")
