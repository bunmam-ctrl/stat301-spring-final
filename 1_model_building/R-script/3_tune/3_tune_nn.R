# Final Project 
# Define and tune neural network

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load resamples ----
load(here("1_model_building/data_splits/patient_survival_folds.rda"))

# load preprocessing/recipe ----
load(here("1_model_building/recipes/patient_recipe.rda"))
load(here("1_model_building/data_splits/keep_wflow.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# parallel processing ----
num_cores <- detectCores(logical = FALSE)
registerDoMC(cores = num_cores)

# model specifications ----
nn_model <- mlp( hidden_units = tune(),
                 penalty = tune())|>
  set_mode("classification")|>
  set_engine("nnet")


# define workflows----
nn_wflow <- workflow()|>
  add_recipe(patient_recipe)|>
  add_model(nn_model)


tic.clearlog() # clear log
tic("Neural Networks") # start clock

# hyperparameter tuning values 
nn_params <- extract_parameter_set_dials(nn_model)


nn_grid <- grid_space_filling(nn_params, size = 20)

# tuning---
nn_tune <- nn_wflow|>
  tune_grid(
    resamples = patient_survival_folds,
    grid = nn_grid,
    control = keep_wflow,
    metrics = my_metrics)

toc(log = TRUE)

# Extract runtime info----
time_log <- tic.log(format = FALSE)

tictoc_nn <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

### Save workflow and tuning----
save(nn_tune, 
     tictoc_nn,
     file = here("1_model_building/tune-model/nn_tune.rda"))



