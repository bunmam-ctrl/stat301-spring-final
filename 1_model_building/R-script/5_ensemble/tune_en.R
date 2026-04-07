# Final Project 
# Define and tune elastic net (ensemble)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(stacks)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load resamples ----
load(here("1_model_building/data_splits/patient_survival_folds.rda"))

# load preprocessing/recipe ----
load(here("1_model_building/recipes/patient_recipe.rda"))
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


### tuning ----
en_tune <- en_wflow|>
  tune_grid(
    resamples = patient_survival_folds,
    grid = en_grid,
    control = stacks::control_stack_grid(),
    metrics = my_metrics)



### Save workflow and tuning ----
save(en_tune ,
     file = here("1_model_building/tune-model/ensemble_tune/en_tune.rda"))

