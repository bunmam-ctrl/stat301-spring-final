# Final Project
# Explore ensemble model

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load stacking model 
load(here("1_model_building/tune-model/ensemble_tune/stack_blend.rda"))

### Plotting
stacking_coefficients_plot <- autoplot(stack_blend, 
                                       type = "weights") +
  theme_minimal()+ 
  theme_minimal() +
  labs(
    title = "Stacking Coefficients",
    subtitle = "(Penalty = 0.01)",
    x = "Stacking Coefficient",
    y = "Member",
    fill = "Model") +
  scale_fill_manual(
    values = c(
      "logistic_reg" = "#4E79A7",
      "mars" = "#59A14F"),
    labels = c(
      "logistic_reg" = "Elastic net",
      "mars" = "MARs")) + 
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, face = "italic", hjust = 0.5),
    legend.title = element_text(size = 16, face = "bold"),
    legend.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    axis.text.x = element_text(size = 12, hjust = 1),
    axis.text.y = element_text(size = 12)
  )

ggsave(stacking_coefficients_plot,
       filename = here("1_model_building/results/stacking_coefficients_plot.png"))
