# Final Project
# Tune/Fit Naive Bayes Model 

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(doParallel)
library(tictoc)
library(discrim)

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
nb_model <- naive_Bayes(
  smoothness = tune()
) |>
  set_engine("klaR") |>
  set_mode("classification")

# workflow ----
nb_wflow <-
  workflow() |>
  add_model(nb_model) |>
  add_recipe(patient_recipe)

# hyperparameter tuning values 
nb_params <- extract_parameter_set_dials(nb_model) 
nb_grid <- grid_regular(nb_params, levels = 3)

# tuning
tic.clearlog() # clear log
tic("nb") # start clock


nb_tune <- tune_grid(
  nb_wflow,
  resamples = patient_survival_folds,
  grid = nb_grid,
  control = keep_wflow
)

toc(log = TRUE) # stop clock

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_nb <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# stop processing 
stopCluster(cl)

# write out results (fitted/trained workflows) ----
save(nb_tune, tictoc_nb, 
     file = here("1_model_building/tune-model/nb_tune.rda"))


