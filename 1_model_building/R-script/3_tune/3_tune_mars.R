# Final Project
# Tune MARS (Multivariate Adaptive Regression Splines) model

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(doParallel)
library(tictoc)

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- detectCores(logical = TRUE)
cl <- makePSOCKcluster(num_cores)
registerDoParallel(cl)

# load data ----
load(here("1_model_building/data_splits/patient_survival_folds.rda"))
load(here("1_model_building/data_splits/keep_wflow.rda"))

# load your recipe ----
load(here("1_model_building/recipes/patient_recipe.rda"))

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

# tuning
tic.clearlog() # clear log
tic("mars") # start clock


mars_tune <- tune_grid(
  mars_wflow,
  resamples = patient_survival_folds,
  grid = mars_grid, 
  control = keep_wflow
)

toc(log = TRUE) # stop clock

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_mars <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# stop processing 
stopCluster(cl)

# write out results (fitted/trained workflows) ----
save(mars_tune, tictoc_mars, 
     file = here("1_model_building/tune-model/mars_tune.rda"))


