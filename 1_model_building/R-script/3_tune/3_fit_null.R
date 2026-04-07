# Final Project
# Baseline Models
# Define and fit null model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)

# handle common conflicts
tidymodels_prefer()

# load required objects
load(here("1_model_building/recipes/patient_recipe.rda"))
load(here("1_model_building/data_splits/patient_survival_folds.rda"))

##########################################################################
# Null Model 
##########################################################################
null_spec <- null_model() |>
  set_engine("parsnip") |>
  set_mode("classification")

null_wflow <- workflow() |>
  add_model(null_spec) |>
  add_recipe(patient_recipe)

tic.clearlog() # clear log
tic("Baseline") # start clock


null_fit <- null_wflow |>
  fit_resamples(
    resamples = patient_survival_folds,
    control = control_resamples(save_workflow = TRUE)
  )

toc(log = TRUE)

# Extract runtime info----
time_log <- tic.log(format = FALSE)

tictoc_null <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# save fits ----
save(null_fit, 
     tictoc_null, 
     file = here("1_model_building/tune-model/null_fit.rda"))