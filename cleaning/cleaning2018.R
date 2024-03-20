# Packages ----------------------------------------------------------------
library(dplyr)
source("functions.R")

# Data --------------------------------------------------------------------

raw_df <- read.csv("SignesReligieux2024/Data/data_pes_qc2018.csv")

clean_df <- data.frame(
  id = 1:nrow(raw_df),
  year = 2018,
  weight = as.numeric(NA)
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
## Hijab: Q18.4
## Pendantif croissant: Q18.6
## Petite croix: Q18.10
## Grosse croix: Q18.2

### Hijab ####
hijab <- raw_df$Q18.4
table(hijab)
clean_df$autority_hijab <- clean_var(raw_vector = hijab,
                                     target = "autority")
table(clean_df$autority_hijab)

clean_df$teacher_hijab <- clean_var(raw_vector = hijab,
                                    target = "teacher")
table(clean_df$teacher_hijab)

### Pendantif croissant ####
pendantif_croissant <- raw_df$Q18.6
table(pendantif_croissant)
clean_df$autority_pendantif_croissant <- clean_var(raw_vector = pendantif_croissant,
                                                   target = "autority")
table(clean_df$autority_pendantif_croissant)

clean_df$teacher_pendantif_croissant <- clean_var(raw_vector = pendantif_croissant,
                                                  target = "teacher")
table(clean_df$teacher_pendantif_croissant)

### Petite croix ####
petite_croix <- raw_df$Q18.10
table(petite_croix)
clean_df$autority_petite_croix <- clean_var(raw_vector = petite_croix,
                                            target = "autority")
table(clean_df$autority_petite_croix)

clean_df$teacher_petite_croix <- clean_var(raw_vector = petite_croix,
                                           target = "teacher")
table(clean_df$teacher_petite_croix)

### Grosse croix ####
grosse_croix <- raw_df$Q18.2
table(grosse_croix)
clean_df$autority_grosse_croix <- clean_var(raw_vector = grosse_croix,
                                            target = "autority")
table(clean_df$autority_grosse_croix)

clean_df$teacher_grosse_croix <- clean_var(raw_vector = grosse_croix,
                                           target = "teacher")
table(clean_df$teacher_grosse_croix)

saveRDS(clean_df, "SignesReligieux2024/Data/cleandata/by_year/data2018.rds")
