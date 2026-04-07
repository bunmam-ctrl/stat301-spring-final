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
set.seed(3013)
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
keep_wflow <- control_grid(save_workflow = TRUE)
my_metrics <- metric_set(accuracy, roc_auc)

# save out training, testing, folds
save(patient_survival_training, file = here("1_model_building/data_splits/patient_survival_training.rda"))
save(patient_survival_testing, file = here("1_model_building/data_splits/patient_survival_testing.rda"))
save(patient_survival_folds, file = here("1_model_building/data_splits/patient_survival_folds.rda"))
save(keep_wflow, file = here("1_model_building/data_splits/keep_wflow.rda"))
save(my_metrics, file = here("1_model_building/data_splits/my_metrics.rda"))