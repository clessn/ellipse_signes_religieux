# Packages ----------------------------------------------------------------
library(dplyr)

# List all files to bind --------------------------------------------------

files <- list.files("SignesReligieux2024/Data/cleandata/by_year",
                    full.names = TRUE)

merged_df <- bind_rows(lapply(files, FUN = readRDS))

saveRDS(merged_df, "SignesReligieux2024/Data/cleandata/merged_data.rds")
