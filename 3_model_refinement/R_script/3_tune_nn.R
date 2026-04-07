# Final Project 
# Tune neural network 

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)
library(doMC)

# handle common conflicts
tidymodels_prefer()


# load resamples ----
load(here("2_model_tuning/data_splits/patient_survival_folds.rda"))


# load preprocessing/recipe 
load(here("3_model_refinement/recipes/nn_complex_recipe.rda"))
load(here("2_model_tuning//data_splits/ctrl_grid.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# parallel processing ----
num_cores <- detectCores(logical = FALSE)
registerDoMC(cores = num_cores)

tic.clearlog() # clear log
tic("neural network") # start clock

# Define model
nn_model <- mlp(hidden_units = tune(), 
                penalty = tune())|>
  set_engine("nnet")|>
  set_mode("classification")

# define workflows----
nn_wflow <- workflow()|>
  add_recipe(nn_complex_recipe)|>
  add_model(nn_model)

# hyperparameter tuning values 
nn_params <- extract_parameter_set_dials(nn_model)|>
  update(
    hidden_units = hidden_units(range = c(7, 15)),
    penalty = penalty(range = c(-1, 0.5)),
  ) 
    
rec_params <- extract_parameter_set_dials(nn_complex_recipe)|>
  update(
    num_comp = num_comp(range = c(10, 20)))

## Combine all the parameters 
all_params <- bind_rows(nn_params, rec_params)

nn_grid <- grid_regular(all_params, levels = 5)

# tuning---
nn_tune <- nn_wflow|>
  tune_grid(
    resamples = patient_survival_folds,
    grid = nn_grid,
    control = ctrl_grid,
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
     file = here("3_model_refinement/tune-model/nn_tune.rda"))

