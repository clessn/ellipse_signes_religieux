# Packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)

# Data --------------------------------------------------------------------
data <- readRDS("SignesReligieux2024/Data/cleandata/merged_data.rds") %>%
  tidyr::pivot_longer(., cols = c("authority", "teacher", "citizenship",
                                  "student", "all_public"),
                      names_to = "position", values_to = "value")

# Wrangling ---------------------------------------------------------------

graph_df <- data %>%
  tidyr::drop_na() %>%
  group_by(year, symbol, position) %>%
  summarise(prop = weighted.mean(value, weight, na.rm = TRUE) * 100,
            n = n())

write.csv(graph_df, "SignesReligieux2024/Data/cleandata/by_year.csv")

# Graph -------------------------------------------------------------------

colors <- c(
  "Grosse croix" = "#4DA6FF",       # Bleu clair pour chrétien ostentatoire
  "Petite croix" = "#003399",       # Bleu foncé pour chrétien non-ostentatoire
  "Hijab" = "#FF9933",              # Orange pour musulman ostentatoire
  "Pendantif croissant" = "#CC5200" # Marron pour musulman non-ostentatoire
)

ggplot(graph_df,
       aes(x = year, y = prop,
           color = symbol)) +
  facet_wrap(~position) +
  geom_point() +
  geom_line(aes(group = symbol)) +
  scale_y_continuous(name = "Proportion favorisant l'interdiction\ndu symbole religieux (%)", limits = c(0, 100)) +
  scale_x_continuous(breaks = c(2015, 2018, 2019, 2022)) +
  scale_color_manual(values = colors) +
  guides(color = guide_legend(title = "", nrow = 2)) +
  xlab("") +
  ggtitle("Évolution de la proportion favorisant\nl'interdiction de symboles religieux, 2015-2022") +
  clessnize::theme_clean_light() +
  theme(axis.text.x = element_text(hjust = 0.5, size = 11),
        axis.text.y = element_text(size = 11),
        axis.title.y = element_text(hjust = 0.5, size = 13),
        strip.text.x = element_text(size = 13),
        legend.text = element_text(size = 13))

ggsave("SignesReligieux2024/graphs/by_year.png",
       width = 10, height = 6, dpi = 300)
