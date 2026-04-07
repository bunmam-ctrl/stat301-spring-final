# Final Project
# Define and fit Random Forest

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(1234)

# set up parallel processing ----
num_cores <- parallel::detectCores(logical = FALSE)
registerDoMC(cores = num_cores)

# load resamples ----
load(here("2_model_tuning/data_splits/patient_survival_folds.rda"))

# load preprocessing/recipe ----
load(here("2_model_tuning/recipes/tree_complex_recipe.rda"))
load(here("2_model_tuning//data_splits/ctrl_grid.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))
# model specifications ----
rf_spec <- 
  rand_forest(
    trees = 2000,
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger") |> 
  set_mode("classification")

# define workflows ----
rf_wkflow <- workflow() |>
  add_model(rf_spec) |>
  add_recipe(tree_complex_recipe)

tic.clearlog() # clear log
tic("Random Forest") # start clock

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec)

# change hyperparameter ranges
rf_params <- hardhat::extract_parameter_set_dials(rf_spec)|>
  update(
    mtry = mtry(c(20,30)),
    min_n = min_n(c(2, 5))
  ) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 3)

# fit workflows/models ----
rf_tune <- rf_wkflow |> 
  tune_grid(
    patient_survival_folds, 
    grid = rf_grid, 
    control = ctrl_grid,
    metrics = my_metrics)

toc(log = TRUE)

# Extract runtime info----
time_log <- tic.log(format = FALSE)

tictoc_rf <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)
# write out results (fitted/trained workflows) ----
save(rf_tune, 
     tictoc_rf,
     file = here("2_model_tuning/tune-model/rf_tune.rda"))