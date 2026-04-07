# Final Project
# Define and Fit Boosted Tree
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
bt_model <- boost_tree(
  mtry = tune(),
  trees = tune(),
  min_n = tune(),
  learn_rate = tune()
) |>
  set_engine("xgboost") |>
  set_mode("classification")

# workflow ----
bt_wflow <-
  workflow() |>
  add_model(bt_model) |>
  add_recipe(patient_recipe)

# hyperparameter tuning values 
set.seed(625)

bt_params <- extract_parameter_set_dials(bt_model) |> 
  update(
    mtry = mtry(c(1,10)),
    trees = trees(), 
    min_n = min_n(),
    learn_rate = learn_rate(range = c(-3, -0.3))
  )

bt_grid <- grid_regular(bt_params, levels = 3)

# tuning
tic.clearlog() # clear log
tic("bt") # start clock


bt_tune <- tune_grid(
  bt_wflow,
  resamples = patient_survival_folds,
  grid = bt_grid, 
  control = keep_wflow
)

toc(log = TRUE) # stop clock

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_bt <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# stop processing 
stopCluster(cl)

# write out results (fitted/trained workflows) ----
save(bt_tune, tictoc_bt, 
     file = here("1_model_building/tune-model/bt_tune.rda"))


