# Packages ----------------------------------------------------------------
library(dplyr)

# Data --------------------------------------------------------------------

data2022 <- read.csv("SignesReligieux2024/Data/pes_qc22_relig_symb/2022-11-09_pes_qc22_religious_symb_data.csv")

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
