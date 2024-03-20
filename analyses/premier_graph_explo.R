# Packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)

# Data --------------------------------------------------------------------
data <- readRDS("SignesReligieux2024/Data/cleandata/merged_data.rds") %>%
  tidyr::pivot_longer(., cols = starts_with(c("autority", "teacher")),
                      values_to = "bannish") %>%
  tidyr::separate(., col = name, into = c("target", "symbol"),
                  sep = "_")

graph_df <- data %>%
  group_by(year, target, symbol) %>%
  summarise(n_bannish = sum(bannish),
            n = n()) %>%
  mutate(prop = n_bannish / n * 100)

ggplot(graph_df, aes(x = year, y = prop)) +
  facet_grid(rows = vars(target),
             cols = vars(symbol)) +
  geom_col()
