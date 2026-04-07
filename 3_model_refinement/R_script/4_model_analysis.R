# Final Project 
# Model selection/comparison & analysis

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
# load fitting model
list.files (
  here("3_model_refinement/tune-model/"),
  pattern = "tune.rda",
  full.names = TRUE
)|>
  map(load, envir = .GlobalEnv)

# visual inspection using autoplot----
## Random Forest
autoplot(rf_tune, metric = "roc_auc")

### ROC and accuracy has the same best model----------------------------------------------------------
# Compile table 
model_tune <- as_workflow_set(
  rf = rf_tune,
  bt = bt_tune,
  nn = nn_tune 
)

## Create time table
time_tbl <- tictoc_rf|> #1: rf
  bind_rows(tictoc_bt)|> #2: bt
  bind_rows(tictoc_nn)|> #3: nn
  mutate(
    runtime = round(runtime/60, digits = 0) # in minutes
  )|>
  select(model, runtime)


# Create Evaluation table----
## Select top model based on ROC-AUC
top_models <- model_tune |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>  
  slice_max(mean, by = wflow_id)|>
  select(wflow_id, .config)

## Retrieve  ROC AUC for these models  
tune_roc_tbl <-  model_tune|>
  collect_metrics() |>
  inner_join(top_models, by = c("wflow_id",".config"))|> 
  filter(.metric == "roc_auc") |> 
  bind_cols(time_tbl)|>
  select(wflow_id, mean, std_err, runtime)|>
  mutate(
    wflow_id = case_when(
      wflow_id %in%  "rf"~ "Random forest",
      wflow_id %in%  "bt"~ "Boosted tree",
      wflow_id %in%  "nn"~ "Neural network"
    )
  )|>
  rename(
    "Model" = wflow_id,  
    "Mean" = mean, 
    "Standard Error" = std_err,
    "Runtime (minutes)" = runtime
  )

## Save table 
save(tune_roc_tbl,
     file = here("3_model_refinement/results/tune_roc_tbl.rda")
)
