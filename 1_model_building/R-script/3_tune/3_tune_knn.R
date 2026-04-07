# Final Project
# Define and fit (K-nearest neighbor)

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

# Set seed
set.seed(1111)

# model specifications ----
knn_model <- nearest_neighbor(neighbors = tune())|>
  set_engine("kknn")|>
  set_mode("classification")

# hyperparameter tuning values---
knn_params <- extract_parameter_set_dials(knn_model)|>
  update(
    neighbors = neighbors(c(150,230)))

knn_grid <- grid_regular(knn_params, levels = 7)


# define workflows----
knn_wflow <- workflow()|>
  add_recipe(patient_recipe)|>
  add_model(knn_model)


tic.clearlog() # clear log
tic("K-Nearest Neighbor") # start clock

# tuning---
knn_tune <- knn_wflow|>
  tune_grid(
    resamples = patient_survival_folds,
    grid = knn_grid,
    control = keep_wflow,
    metrics = my_metrics)

toc(log = TRUE)

# Extract runtime info----
time_log <- tic.log(format = FALSE)

tictoc_knn <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

### Save workflow and tuning----
save(knn_tune, 
     tictoc_knn,
     file = here("1_model_building/tune-model/knn_tune.rda"))
