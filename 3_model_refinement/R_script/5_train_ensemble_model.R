# Train & explore ensemble model

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
load(here("3_model_refinement/tune-model/rf_tune.rda"))
load(here("3_model_refinement/tune-model/bt_tune.rda"))
load(here("3_model_refinement/tune-model/nn_tune.rda"))

autoplot(rf_tune, metric = "roc_auc")

# Create data stack ----
patient_data_st <-
  stacks() |>
  add_candidates(bt_tune) |>
  add_candidates(rf_tune) |>
  add_candidates(nn_tune)

patient_data_st

# Fit the stack ----
# penalty values for blending (set penalty argument when blending)
blend_penalty <- c(10^(-6:-1), 0.5, 1, 1.5, 2)

# Blend predictions (tuning step, set seed)
set.seed(2004)

patient_model_st <-
  patient_data_st |>
  blend_predictions(penalty = blend_penalty)

# Save blended model stack for reproducibility & easy reference (for report)
save(patient_model_st, file = here("3_model_refinement/tune-model/patient_model_st.rda"))

# Explore the blended model stack
autoplot(patient_model_st)
ensemble_autoplot <- autoplot(patient_model_st, type = "weights")

save(ensemble_autoplot, file = here("3_model_refinement/tune-model/ensemble_autoplot.rda"))

load(here("3_model_refinement/tune-model/patient_model_st.rda"))

# fit to training set ----
patient_trained_st <-
  patient_model_st |>
  fit_members()

# Save trained ensemble model for reproducibility & easy reference (for report)
save(patient_trained_st, file = here("3_model_refinement/tune-model/patient_trained_st.rda"))