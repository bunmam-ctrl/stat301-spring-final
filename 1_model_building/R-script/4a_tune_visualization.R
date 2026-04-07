# Final Project 
# Tuning visualization (visual inspection using autoplot-- three best model rf, bt, and nn)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
# load fitting model
list.files (
  here("1_model_building/tune-model/"),
  pattern = "tune.rda",
  full.names = TRUE
)|>
  map(load, envir = .GlobalEnv)

## Random Forest
### Plot 
rf_tune_plot <- autoplot(rf_tune, 
                    metric = "roc_auc") + 
  theme_minimal() +
  labs(
    title = " Effect of Minimal Node Size and Randomly \nSelected Predictors on ROC-AUC in Random Forest",
    subtitle = "(Trees = 1000)",
    x =  "Number of Randomly Selected Predictors",
    y = "ROC-AUC"
  )+
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, face = "italic", hjust = 0.5),
    axis.title = element_text(size = 12),
    legend.title = element_text(size = 14, hjust = 0.5),
    legend.text = element_text(size = 12),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
  )

ggsave(rf_tune_plot,  width = 8, height = 8,
       filename = here("1_model_building/results/rf_tune_plot.png"))

## Boosted Trees
bt_tune_plot <-  autoplot(bt_tune, 
                            metric = "roc_auc")+
  theme_minimal() +
  labs(
    title = "Effect of Different Tuning Hyperparameters \non ROC-AUC in Boosted Tree Models",
    x = "Learning Rate",
    y = "ROC-AUC"
  ) +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12),
    strip.text = element_text(face = "italic", size = 9),
    legend.title = element_text(size = 12, hjust = 0.5),
    legend.text = element_text(size = 13),
    axis.text.x = element_text(size = 10, angle = 45),
    axis.text.y = element_text(size = 10)
  )

ggsave(bt_tune_plot, width = 9,
       filename = here("1_model_building/results/bt_tune_plot.png"))

### Parameters
bt_parameters <-  select_best(bt_tune, 
                              metric = "roc_auc")


## SVM Polynomial
 nn_tune_plot <-  autoplot(nn_tune, 
                          metric = "roc_auc") +
  theme_minimal() +
  labs(
    title = "Effect of Different Tuning Hyperparameters \non ROC-AUC in Neural Network Models",
    x = NULL,
    y = "ROC-AUC"
  ) +
  geom_point(color = "#0072B2", size = 2) + 
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12),
    strip.text = element_text(face = "italic", size = 12),
    legend.title = element_text(size = 14, hjust = 0.5),
    legend.text = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45),
    axis.text.y = element_text(size = 10)
  )

ggsave(nn_tune_plot, width = 7,
       filename = here("1_model_building/results/nn_tune_plot.png"))


