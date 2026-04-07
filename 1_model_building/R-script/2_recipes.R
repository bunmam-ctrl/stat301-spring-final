# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load required objects ----
load(here("1_model_building/data_splits/patient_survival_training.rda"))

# build recipe ----
patient_recipe <- recipe(hospital_death ~., data = patient_survival_training
) |>
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), threshold = 0.05) |>
  step_dummy(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

# check recipe
patient_recipe |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

# build rf recipe ----
rf_recipe <- recipe(hospital_death ~., data = patient_survival_training
) |>
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), threshold = 0.05) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

# check recipe
rf_recipe |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

# build mars recipe 
mars_recipe <- recipe(
  hospital_death ~., data = patient_survival_training
) |> 
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), threshold = 0.05) |>
  step_corr(all_numeric_predictors(), threshold = 0.9) 

## check recipe
mars_recipe |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse() 

# naive bayes: zv, impute, decorrelate
nb_recipe <- recipe(
  hospital_death ~., data = patient_survival_training
) |> 
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9)

# boosted tree recipe: zv, impute. decorrelate
bt_recipe <- recipe(hospital_death ~ ., data = patient_survival_training) |>
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9) |> 
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), threshold = 0.05) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_numeric_predictors())



# save recipe
save(patient_recipe, 
     file = here("1_model_building/recipes/patient_recipe.rda"))
save(rf_recipe, 
     file = here("1_model_building/recipes/rf_recipe.rda"))
save(mars_recipe, 
     file = here("1_model_building/recipes/mars_recipe.rda"))
save(nb_recipe, 
     file = here("1_model_building/recipes/nb_recipe.rda"))
save(bt_recipe, 
     file = here("1_model_building/recipes/bt_recipe.rda"))
