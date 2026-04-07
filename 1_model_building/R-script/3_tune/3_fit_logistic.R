# Final Project
# Fit logistic reg model

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)

# Handle conflicts
tidymodels_prefer()

# load data ----
load(here("1_model_building/data_splits/patient_survival_folds.rda"))
load(here("1_model_building/data_splits/keep_wflow.rda"))

# load your recipe ----
load(here("1_model_building/recipes/patient_recipe.rda"))

# model specification ----
log_spec <- logistic_reg() |>
  set_mode("classification") |>
  set_engine("glm")

# workflow ----
log_wflow <-
  workflow() |>
  add_model(log_spec) |>
  add_recipe(patient_recipe)

tic.clearlog() # clear log
tic("Logistic Regression") # start clock

# Fitting---
lg_fit <- log_wflow |>
  fit_resamples(
    resamples = patient_survival_folds,
    control = keep_wflow
  )

toc(log = TRUE)
# Extract runtime info----
time_log <- tic.log(format = FALSE)

tictoc_lg <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)
# write out results (fitted/trained workflows) ----
save(lg_fit, tictoc_lg, 
     file = here("1_model_building/tune-model/lg_fit.rda"))