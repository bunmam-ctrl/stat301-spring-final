# Final Project
# Initial data checks & data splitting

# load packages ----
library(tidyverse)
library(tidymodels)
library(themis)
library(here)

# handle common conflicts
tidymodels_prefer()

# load dataset
load(here("data/patient_survival.rda"))

patient_survival_clean <- patient_survival |>
  # keep only obs that are NOT na in price
  filter(!is.na(hospital_death)) |>
  mutate(across(where(is.character), as.factor),
         hospital_death = as.factor(hospital_death)) 

# check the distribution 
ggplot(patient_survival_clean, aes(hospital_death)) +
  geom_bar()

patient_survival_clean |>
  count(hospital_death)

# What is the ratio?
83798/7915
# 10.59:1

# downsample the majority class
# let's say we want 2:1
set.seed(2000)
patient_survival_small <- patient_survival_clean |>
  group_by(hospital_death) |>
  slice_sample(n = 7915*2)

# verify
patient_survival_small |>
  count(hospital_death)

# split our data
patient_survival_split <- initial_split(patient_survival_small, prop = 0.8, strata = hospital_death)

patient_survival_training <- training(patient_survival_split)
patient_survival_testing <- testing(patient_survival_split)

# fold data
patient_survival_folds <- vfold_cv(patient_survival_training, v = 5, repeats = 3, strata = hospital_death)

# controls for fitting resamples ----
ctrl_grid <- control_grid(save_pred = TRUE, save_workflow = TRUE)
ctrl_res <- control_resamples(save_pred = TRUE, save_workflow = TRUE)

# save out training, testing, folds
save(patient_survival_training, file = here("2_model_tuning/data_splits/patient_survival_training.rda"))
save(patient_survival_testing, file = here("2_model_tuning/data_splits/patient_survival_testing.rda"))
save(patient_survival_folds, file = here("2_model_tuning/data_splits/patient_survival_folds.rda"))
save(ctrl_grid, file = here("2_model_tuning/data_splits/ctrl_grid.rda"))
save(ctrl_res, file = here("2_model_tuning/data_splits/ctrl_res.rda"))