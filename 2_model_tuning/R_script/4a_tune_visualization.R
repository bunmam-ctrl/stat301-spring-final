# Final Project 
# Tuning visualization (visual inspection using autoplot)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
# load fitting model
list.files (
  here("2_model_tuning/tune-model/"),
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
    subtitle = "(Trees = 2000)",
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
  
ggsave(rf_tune_plot, width = 8, height = 8,
       filename = here("2_model_tuning/results/rf_tune_plot.png"))

### Parameters
load(here("1_model_building/results/rf_param.rda"))

rf_param_compile <-  rf_param|>
  mutate("Tuning stage" = "Before")|>
  bind_rows( select_best(rf_tune, 
                         metric = "roc_auc")|>
               select(-.config)|>
               mutate("Tuning stage" = "After",
                      trees = 2000))|>
  rename(
    "Trees" = trees,
    "mtry" = mtry,
    "Min node size" = min_n,
  )|>
  relocate("Tuning stage", .before = 0)|>
  relocate("Trees", .after = "Tuning stage")

save(rf_param_compile,
     file = here("2_model_tuning/results/rf_param_compile.rda")
)

## Boosted Trees
bt_tune_plot <-  autoplot(bt_tune, 
                            metric = "roc_auc") +
  theme_minimal() +
  labs(
    title = "Effect of Different Tuning Hyperparameters \non ROC-AUC in Boosted Tree Models",
    x = "Learning Rate",
    y = "ROC-AUC"
  ) +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 14),
    strip.text = element_text(face = "italic", size = 9),
    legend.title = element_text(size = 12, hjust = 0.5),
    legend.text = element_text(size = 13),
    axis.text.x = element_text(size = 10, angle = 45),
    axis.text.y = element_text(size = 10)
  )


ggsave(bt_tune_plot, width = 8,
       filename = here("2_model_tuning/results/bt_tune_plot.png"))


### Parameters
load(here("1_model_building/results/bt_param.rda"))

bt_param_compile <- bt_param|>
  mutate("Tuning stage" = "Before")|>
  bind_rows(select_best(bt_tune, 
                        metric = "roc_auc")|>
              select(-.config)|>
              mutate("Tuning stage" = "After"))|>
  rename(
    "Trees" = trees,
    "mtry" = mtry,
    "Min node size" = min_n,
    "Learning rate" = learn_rate
  )|>
  relocate("Tuning stage", .before = 0)


save(bt_param_compile,
     file = here("2_model_tuning/results/bt_param_compile.rda")
)



## Neural Network
nn_tune_plot <-  autoplot(nn_tune, 
                          metric = "roc_auc") +
  theme_minimal() +
  labs(
    title = "Effect of Different Tuning Hyperparameters \non ROC-AUC in Neural Network Models",
    x = "Number of Hidden Units",
    y = "ROC-AUC"
  )+
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 14),
    strip.text = element_text(face = "italic", size = 12),
    legend.title = element_text(size = 14, hjust = 0.5),
    legend.text = element_text(size = 12),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10)
  )

ggsave(nn_tune_plot, width = 9, height = 9,
       filename = here("2_model_tuning/results/nn_tune_plot.png"))

### Parameters
load(here("1_model_building/results/nn_param.rda"))

nn_param_compile <- nn_param|>
  mutate("Tuning stage" = "Before")|>
  bind_rows(select_best(nn_tune, 
                        metric = "roc_auc")|>
              select(-.config)|>
              mutate("Tuning stage" = "After"))|>
  rename(
    "Hidden units" = hidden_units,
    "Penalty" = penalty,
    "PCA components" = num_comp
  )|>
  relocate("Tuning stage", .before = 0)


save(nn_param_compile,
     file = here("2_model_tuning/results/nn_param_compile.rda")
)



