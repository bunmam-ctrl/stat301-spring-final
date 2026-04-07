# Final Project
# Explore ensemble model (en, mars)

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
list.files(
  here("1_model_building/tune-model/ensemble_tune"),
  pattern = "tune.rda",
  full.names = TRUE
)|>
  map(load, envir = .GlobalEnv)


# Create data stack ----
data_stack <- stacks()|>
  add_candidates(en_tune)|>
  add_candidates(mars_tune)


# Fit the stack ----
## penalty values for blending (set penalty argument when blending)
blend_penalty <- c(10^(-6:-1), 0.5, 1, 1.5, 2)

# Penalty is the amount of regularization
## Higher penalty = fewer members
## Lower penalty = more members

## Blend predictions (tuning step, set seed)
set.seed(67364)

stack_blend <- data_stack|>
  blend_predictions(penalty = blend_penalty)

## Save blended model stack for reproducibility & easy reference
save(stack_blend,
     file = here("1_model_building/tune-model/ensemble_tune/stack_blend.rda"))

