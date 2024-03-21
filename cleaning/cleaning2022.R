# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/pes_qc22_relig_symb/2022-11-09_pes_qc22_religious_symb_data.csv")

clean_df <- data.frame(
  id = 1:nrow(raw_df),
  year = 2022,
  weight = as.numeric(NA)
)

# Clean -------------------------------------------------------------------

## This symbol should be banned in the following cases (select all that apply):
## For government officials in positions of authority (e.g. judges, police)
## For participants in the Canadian citizenship ceremony
## For public school teachers
## For public school students
## For those in all public spaces (e.g. on sidewalks, in public parks)
## In none of these cases

## 4 Symboles (Q98-Q108)
## Hijab: Q101
## Pendantif croissant: Q103
## Petite croix: Q107
## Grosse croix: Q98

### Hijab ####
hijab <- raw_df$Q101
table(hijab)
clean_df$autority_hijab <- clean_var(raw_vector = hijab,
                                     target = "autority")
table(clean_df$autority_hijab)

clean_df$teacher_hijab <- clean_var(raw_vector = hijab,
                                    target = "teacher")
table(clean_df$teacher_hijab)

### Pendantif croissant ####
pendantif_croissant <- raw_df$Q103
table(pendantif_croissant)
clean_df$autority_pendantif_croissant <- clean_var(raw_vector = pendantif_croissant,
                                                   target = "autority")
table(clean_df$autority_pendantif_croissant)

clean_df$teacher_pendantif_croissant <- clean_var(raw_vector = pendantif_croissant,
                                                  target = "teacher")
table(clean_df$teacher_pendantif_croissant)

### Petite croix ####
petite_croix <- raw_df$Q107
table(petite_croix)
clean_df$autority_petite_croix <- clean_var(raw_vector = petite_croix,
                                            target = "autority")
table(clean_df$autority_petite_croix)

clean_df$teacher_petite_croix <- clean_var(raw_vector = petite_croix,
                                           target = "teacher")
table(clean_df$teacher_petite_croix)

### Grosse croix ####
grosse_croix <- raw_df$Q98
table(grosse_croix)
clean_df$autority_grosse_croix <- clean_var(raw_vector = grosse_croix,
                                            target = "autority")
table(clean_df$autority_grosse_croix)

clean_df$teacher_grosse_croix <- clean_var(raw_vector = grosse_croix,
                                           target = "teacher")
table(clean_df$teacher_grosse_croix)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2022.rds")

