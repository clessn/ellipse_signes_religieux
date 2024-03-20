# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_canada2019_weights.csv") %>%
  ### filter for Quebec
  filter(Q3 == "Quebec" | Q4 == "Quebec")

clean_df <- data.frame(
  id = 1:nrow(raw_df),
  year = 2019,
  weight = as.numeric(raw_df$weight)
)

# Clean -------------------------------------------------------------------

## This symbol should be banned in the following cases (select all that apply):
## For government officials in positions of authority (e.g. judges, police) (13)
## For participants in the Canadian citizenship ceremony (14)
## For public school teachers (15)
## For public school students (16)
## For those in all public spaces (e.g. on sidewalks, in public parks) (17)
## In none of these cases (18)

## 4 Symboles
## Hijab: Q190
## Pendantif croissant: Q192
## Petite croix: Q196
## Grosse croix: Q187

### Hijab ####
hijab <- raw_df$Q190
table(hijab)
clean_df$autority_hijab <- clean_var(raw_vector = hijab,
                                     target = "autority")
table(clean_df$autority_hijab)

clean_df$teacher_hijab <- clean_var(raw_vector = hijab,
                                    target = "teacher")
table(clean_df$teacher_hijab)

### Pendantif croissant ####
pendantif_croissant <- raw_df$Q192
table(pendantif_croissant)
clean_df$autority_pendantif_croissant <- clean_var(raw_vector = pendantif_croissant,
                                                   target = "autority")
table(clean_df$autority_pendantif_croissant)

clean_df$teacher_pendantif_croissant <- clean_var(raw_vector = pendantif_croissant,
                                                  target = "teacher")
table(clean_df$teacher_pendantif_croissant)

### Petite croix ####
petite_croix <- raw_df$Q196
table(petite_croix)
clean_df$autority_petite_croix <- clean_var(raw_vector = petite_croix,
                                            target = "autority")
table(clean_df$autority_petite_croix)

clean_df$teacher_petite_croix <- clean_var(raw_vector = petite_croix,
                                           target = "teacher")
table(clean_df$teacher_petite_croix)

### Grosse croix ####
grosse_croix <- raw_df$Q187
table(grosse_croix)
clean_df$autority_grosse_croix <- clean_var(raw_vector = grosse_croix,
                                            target = "autority")
table(clean_df$autority_grosse_croix)

clean_df$teacher_grosse_croix <- clean_var(raw_vector = grosse_croix,
                                           target = "teacher")
table(clean_df$teacher_grosse_croix)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2019.rds")
