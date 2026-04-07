# Final Project 
# Define and tune elastic net

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

# Model specifications ----
en_mod <- logistic_reg(mixture = tune(), 
                       penalty = tune())|>
  set_engine("glmnet")|>
  set_mode("classification")


### define workflows ----
en_wflow <- workflow()|>
  add_recipe(patient_recipe)|>
  add_model(en_mod)

### hyperparameter tuning values ----
en_params <- extract_parameter_set_dials(en_wflow)|>
  update(
    mixture = mixture(range = c(0,1)),
    penalty = penalty(range = c(-3,0))
  )

en_grid <- grid_regular(en_params, levels = 10)

tic.clearlog() # clear log
tic("Elastic net") # start clock

### tuning ----
en_tune <- en_wflow|>
  tune_grid(
    resamples = patient_survival_folds,
    grid = en_grid,
    control = keep_wflow,
    metrics = my_metrics)

toc(log = TRUE)

# Extract run time info -----
time_log <- tic.log(format = FALSE)

tictoc_en <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

### Save workflow and tuning ----
save(en_tune , tictoc_en,
     file = here("1_model_building/tune-model/en_tune.rda"))


