# Final Project
# Ensemble final fitting 

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
load(here("1_model_building/tune-model/ensemble_tune/stack_blend.rda"))

# fit to training set ----
ensemble_fit <- stack_blend|>
  fit_members()

# Save trained ensemble model for reproducibility & easy reference 
save(ensemble_fit,
     file = here("1_model_building/tune-model/ensemble_tune/ensemble_fit.rda"))