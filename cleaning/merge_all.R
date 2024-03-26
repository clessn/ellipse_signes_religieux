# Packages ----------------------------------------------------------------
library(dplyr)

# List all files to bind --------------------------------------------------

files <- list.files("SignesReligieux2024/Data/cleandata/by_year",
                    full.names = TRUE)

merged_df <- bind_rows(lapply(X = files, FUN = readRDS))


# Validate ----------------------------------------------------------------
validate_df <- merged_df %>%
  group_by(year, symbol) %>%
  summarise(n = n(),
            authority = sum(authority, na.rm = TRUE),
            teacher = sum(teacher, na.rm = TRUE)) %>%
  mutate(prop_authority = authority / n,
         prop_teacher = teacher / n)

saveRDS(merged_df, "SignesReligieux2024/Data/cleandata/merged_data.rds")
