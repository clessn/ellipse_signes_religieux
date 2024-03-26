# Loader packages ---------------------------------------------------------

library(dplyr)
library(ggplot2)
library(clessnverse)


# Data --------------------------------------------------------------------

data <- readRDS("SignesReligieux2024/Data/cleandata/merged_data.rds") %>%
  tidyr::pivot_longer(., cols = c(authority, teacher),
                      names_to = "position", values_to = "value")

graph_df <- data %>%
  select(symbol, position, value) %>%
  group_by(symbol, position) %>%
  summarise(proportion = mean(value)) %>%
  mutate(symbol = recode(symbol,
                         'grosse_croix' = 'Grosse croix',
                         'hijab' = 'Hijab',
                         'pendantif_croissant' = 'Pendantif croissant',
                         'petite_croix' = 'Petite croix'),
         symbol = factor(symbol, levels = c("Grosse croix", "Petite croix", "Hijab", "Pendantif croissant"))  )



# Graph -------------------------------------------------------------------
colors <- c(
  "Grosse croix" = "#4DA6FF",       # Bleu clair pour chrétien ostentatoire
  "Petite croix" = "#003399",       # Bleu foncé pour chrétien non-ostentatoire
  "Hijab" = "#FF9933",              # Orange pour musulman ostentatoire
  "Pendantif croissant" = "#CC5200" # Marron pour musulman non-ostentatoire
)

ggplot(graph_df, aes(x=position, y=proportion, fill=symbol)) +
  geom_col() +
  facet_wrap(~symbol) +
  labs(title="Comparaison de la position des répondants selon le scénario par symbole",
       x="Scénarios: Position d'autorité et enseignant",
       y="Proportion favorisant l'interdiction \n du symbole religieux (%)") +
  clessnverse::theme_clean_light() +
  scale_fill_manual(values=colors) +
  theme(legend.position = "none",
        strip.text = element_text(size=14),
        axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=c(authority="Position d'autorité",
                            teacher="Enseignant")) +
  scale_y_continuous(labels=c(0, 25, 50, 75, 100), limits=c(0, 1))

ggsave("SignesReligieux2024/graphs/global.png",
       width = 10, height = 6, dpi = 300)
