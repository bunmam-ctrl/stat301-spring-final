# Final Project
# Train final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load required objects ----
load(here("1_model_building/data_splits/patient_survival_training.rda"))
load(here("1_model_building/tune-model/bt_tune.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# finalize workflow ----
final_wkflow <- bt_tune |> 
  extract_workflow() |>  
  finalize_workflow(select_best(bt_tune, 
                                metric = "roc_auc"))

# train final model ----
# fit finalized workflow to full training data
  
final_fit <- fit(final_wkflow, patient_survival_training)

# save final fitted model ----
save(final_fit, 
     file = here("4_final_evaluation/final_fit.rda"))
