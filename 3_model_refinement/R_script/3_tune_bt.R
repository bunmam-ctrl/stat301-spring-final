# Final Project 
# Tuning Boosted Tree

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(tictoc)
library(doParallel)

# handle common conflicts 
tidymodels_prefer()

# parallel processing ----
num_cores <- detectCores(logical = TRUE)
cl <- makePSOCKcluster(num_cores)
registerDoParallel(cl)

# load resamples ----
load(here("2_model_tuning/data_splits/patient_survival_folds.rda"))

# load preprocessing/recipe ----
load(here("3_model_refinement/recipes/tree_complex_recipe.rda"))
load(here("2_model_tuning//data_splits/ctrl_grid.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))


# Set seed
set.seed(963)
# model specification ----
bt_spec <- 
  boost_tree( 
    min_n = tune(),
    mtry = tune(),
    learn_rate = tune(),
    trees = tune()
  ) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

# # check tuning parameters
# hardhat::extract_parameter_set_dials(bt_spec)

# set-up tuning grid ----
bt_params <- hardhat::extract_parameter_set_dials(bt_spec)|>
  update(mtry = mtry(c(15, 20)),
         trees = trees(range = c(1000, 2000)),
         min_n = min_n(range = c(3, 5)),
         learn_rate = learn_rate(range = c(-2, -1.6)))


# define grid
bt_grid <- grid_regular(bt_params, levels = c(2,4,3,5))

# workflow ----
bt_wflow <-
  workflow() |>
  add_model(bt_spec) |>
  add_recipe(tree_complex_recipe)

# Tuning/fitting ----
tic.clearlog() # clear log
tic("boosted tree") # start clock

bt_tune <- bt_wflow |> 
  tune_grid(
    resamples = patient_survival_folds, 
    grid = bt_grid, 
    control = ctrl_grid, 
    metrics = my_metrics)


toc(log = TRUE) # stop clock
# stop processing 
stopCluster(cl)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_bt <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# Write out results & workflow
save(bt_tune, tictoc_bt,
     file = here("3_model_refinement/tune-model/bt_tune.rda"))