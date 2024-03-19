# Packages ----------------------------------------------------------------
library(dplyr)

# Data --------------------------------------------------------------------

data <- read.csv("SignesReligieux2024/Data/data_pes_canada2015_weights.csv")

# Clean -------------------------------------------------------------------

## les variables : X16.2 à X16.12

### tidyr::pivot_longer

