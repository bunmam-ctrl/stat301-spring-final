# Final Project 
# Define and fit SVM poly (model_building)

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)
library(doMC)

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load resamples ----
load(here("1_model_building/data_splits/patient_survival_folds.rda"))

# load preprocessing/recipe ----
load(here("1_model_building/recipes/patient_recipe.rda"))
load(here("1_model_building/data_splits/keep_wflow.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# model specifications ----
svm_poly_model <- svm_poly(
  mode = "classification",
  cost = tune(),
  degree = tune(),
  scale_factor = tune()
) |>
  set_engine("kernlab")

# define workflows ----
svm_poly_wflow <- workflow() |>
  add_model(svm_poly_model) |>
  add_recipe(patient_recipe)

# hyperparameter tuning values ----
svm_poly_params <- extract_parameter_set_dials(svm_poly_model)

svm_poly_grid <- grid_regular(svm_poly_params, levels = 3)

# fit workflow/model ----
tic.clearlog() # clear log
tic("SVM-poly") # start clock

# tuning code in here
svm_poly_tune <- svm_poly_wflow |>
  tune_grid(
    resamples = patient_survival_folds,
    grid = svm_poly_grid,
    control = keep_wflow,
    metrics = my_metrics
  )

toc(log = TRUE) # stop clock

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_svm_poly <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows & runtime info) ----
save(svm_poly_tune,
     tictoc_svm_poly,
     file = here("1_model_building/tune-model/svm_poly_tune.rda"))