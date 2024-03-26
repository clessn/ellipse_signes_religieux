# Packages ----------------------------------------------------------------
library(dplyr)

# Data --------------------------------------------------------------------

data2015 <- read.csv("SignesReligieux2024/Data/data_pes_canada2015_weights.csv")

# Clean -------------------------------------------------------------------

## This symbol should be banned in the following cases (select all that apply):
## For government officials in positions of authority (e.g. judges, police) (13)
## For participants in the Canadian citizenship ceremony (14)
## For public school teachers (15)
## For public school students (16)
## For those in all public spaces (e.g. on sidewalks, in public parks) (17)
## In none of these cases (18)

## 4 Symboles
## Hijab: X16.5
## Pendantif croissant: X16.7
## Petite croix: X16.11
## Grosse croix: X16.2

table(data$X16.2)

### tidyr::X16.2### tidyr::pivot_longer

# Filtrer seulement le Québec
