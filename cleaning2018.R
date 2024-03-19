# Packages ----------------------------------------------------------------
library(dplyr)

# Data --------------------------------------------------------------------

data2018 <- read.csv("SignesReligieux2024/Data/data_pes_qc2018.csv")

# Clean -------------------------------------------------------------------

## This symbol should be banned in the following cases (select all that apply):
## For government officials in positions of authority (e.g. judges, police) (13)
## For participants in the Canadian citizenship ceremony (14)
## For public school teachers (15)
## For public school students (16)
## For those in all public spaces (e.g. on sidewalks, in public parks) (17)
## In none of these cases (18)

## 4 Symboles
## Hijab: Q18
## Pendantif croissant: Q18.6
## Petite croix: Q18.10
## Grosse croix: Q18.2
