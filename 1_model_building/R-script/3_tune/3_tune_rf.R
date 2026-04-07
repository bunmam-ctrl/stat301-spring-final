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
set.seed(3013)

# set up parallel processing ----
num_cores <- parallel::detectCores(logical = FALSE)
registerDoMC(cores = num_cores)

# load training data
load(here("1_model_building/data_splits/patient_survival_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("1_model_building/recipes/rf_recipe.rda"))
load(here("1_model_building/data_splits/keep_wflow.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# model specifications ----
rf_spec <- 
  rand_forest(
    trees = 1000, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger") |> 
  set_mode("classification")

# define workflows ----
rf_wkflow <- workflow() |>
  add_model(rf_spec) |>
  add_recipe(rf_recipe)

tic.clearlog() # clear log
tic("Random Forest") # start clock

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec)

# change hyperparameter ranges
rf_params <- hardhat::extract_parameter_set_dials(rf_spec) %>% 
  update(
    mtry = mtry(c(1, 10)),
    min_n = min_n()
  ) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 3)

# fit workflows/models ----
rf_tune <- rf_wkflow |> 
  tune_grid(
    patient_survival_folds, 
    grid = rf_grid, 
    control = keep_wflow,
    metrics = my_metrics
  )

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
     file = here("1_model_building/tune-model/rf_tune.rda"))
