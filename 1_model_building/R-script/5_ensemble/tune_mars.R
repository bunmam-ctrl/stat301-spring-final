# Final Project
# Tune MARS (Multivariate Adaptive Regression Splines) - Ensemble Model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(stacks)
library(doMC)

# Handle conflicts
tidymodels_prefer()

# load resamples ----
load(here("1_model_building/data_splits/patient_survival_folds.rda"))

# load preprocessing/recipe ----
load(here("1_model_building/recipes/patient_recipe.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# parallel processing ----
num_cores <- detectCores(logical = FALSE)
registerDoMC(cores = num_cores)


# model specification ----
mars_model <- mars(
  mode = "classification",
  num_terms = tune(),
  prod_degree = tune()
) |>
  set_engine("earth")

# workflow ----
mars_wflow <-
  workflow() |>
  add_model(mars_model) |>
  add_recipe(patient_recipe)

# hyperparameter tuning values 
mars_params <- extract_parameter_set_dials(mars_model) 
mars_grid <- grid_regular(mars_params, levels = 3)



mars_tune <- tune_grid(
  mars_wflow,
  resamples = patient_survival_folds,
  grid = mars_grid,
  control = stacks::control_stack_grid(),
  metrics = my_metrics
)


# write out results (fitted/trained workflows) ----
save(mars_tune, 
     file = here("1_model_building/tune-model/ensemble_tune/mars_tune.rda"))


