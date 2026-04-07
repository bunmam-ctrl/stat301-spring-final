# Final Project 
# Interaction between numerical variables and age 

# load packages ----
library(here)
library(tidyverse)

# Load data
load(here("1_model_building/data_splits/patient_survival_training.rda"))

# Select only numeric columns
numeric_data <- patient_survival_training |>
  select(where(is.numeric))

# Compute correlation matrix
cor_matrix <- round(cor(patient_survival_training[sapply(patient_survival_training, is.numeric)], use = "pairwise.complete.obs"), digits = 2)

# Extract age correlations and make a data frame
age_cor <- cor_matrix["age", ] |>
  round(2) |>
  enframe(name = "variable", value = "correlation") |>
  filter(variable != "age") |>  # Remove self-correlation
  arrange(desc(abs(correlation)))

# Plotting

age_corr_plot <- age_cor|>
  ggplot(aes(x = reorder(variable, correlation), 
             y = correlation, 
             fill = correlation)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  labs(
    title = "Correlation of Numeric Variables with Age",
    x = "Variable",
    y = "Correlation Coefficient"
  ) +
  theme_minimal(base_size = 13)+ 
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12),
    strip.text = element_text(face = "italic", size = 12),
    legend.title = element_text(size = 14, hjust = 0.5),
    legend.text = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45),
    axis.text.y = element_text(size = 10)
  )


ggsave(age_corr_plot, height = 14,width = 8,
       filename = here("data-check/age_corr_plot.png"))

