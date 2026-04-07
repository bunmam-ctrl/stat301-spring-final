# Final Project 
# Setup pre-processing/recipes (add imputation)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load required objects ----
load(here("2_model_tuning/data_splits/patient_survival_training.rda"))

# build recipe ----
reg_complex_recipe <- recipe(hospital_death ~ ., 
                             data = patient_survival_training) |>
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_bag(all_numeric_predictors(), 
                  impute_with = imp_vars(c(age, bmi)))|>          # Bagged tree imputation for numeric vars
  step_impute_knn(all_nominal_predictors()) |>             # KNN for categorical vars
  step_corr(all_numeric_predictors(), threshold = 0.9) |> 
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), threshold = 0.05) |>
  step_dummy(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())


# check recipe
reg_complex_recipe |>
  prep() |>
  bake(new_data = NULL)

# rf recipe (one-hot dummy encoding)
tree_complex_recipe <- recipe(hospital_death ~., 
                              data = patient_survival_training) |>
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_bag(all_numeric_predictors(), 
                  impute_with = imp_vars(c(age, bmi)))|>          # Bagged tree imputation for numeric vars
  step_impute_knn(all_nominal_predictors()) |>             # KNN for categorical vars
  step_corr(all_numeric_predictors(), 
            threshold = 0.9) |> 
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), 
             threshold = 0.05) |>
  step_dummy(all_nominal_predictors(), 
             one_hot = TRUE) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

# check recipe
tree_complex_recipe |>
  prep() |>
  bake(new_data = NULL)

## nn-speical recipe
nn_complex_recipe <- recipe(hospital_death ~., 
                            data = patient_survival_training) |>
  step_rm(encounter_id, patient_id, hospital_id, ...84) |>
  step_impute_bag(all_numeric_predictors(), 
                  impute_with = imp_vars(c(age, bmi)))|>          # Bagged tree imputation for numeric vars
  step_impute_knn(all_nominal_predictors()) |>        
  step_pca(all_numeric_predictors(), 
           num_comp = tune())|> # reduce dimensionality 
  step_corr(all_numeric_predictors(), threshold = 0.9) |>
  step_novel(all_nominal_predictors()) |>
  step_other(all_nominal_predictors(), threshold = 0.05) |>
  step_dummy(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |>
  step_normalize(all_numeric_predictors())

# save recipe
save(reg_complex_recipe, 
     file = here("3_model_refinement/recipes/reg_complex_recipe.rda"))

save(tree_complex_recipe, 
     file = here("3_model_refinement/recipes/tree_complex_recipe.rda"))

save(nn_complex_recipe, 
     file = here("3_model_refinement/recipes/nn_complex_recipe.rda"))

