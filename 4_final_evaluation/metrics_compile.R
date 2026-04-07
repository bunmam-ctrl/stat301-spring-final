# Final Projects
# Compiling metrics, std err, and runtime from three stages 

# load packages ----
library(tidyverse)
library(here)
library(flextable)

# load model_building
load(here("1_model_building/results/tune_roc_tbl.rda"))

tbl_1 <- tune_roc_tbl|>
  rename(std_err = "Standard Error")|>
  mutate(
    Mean = round(Mean, 5),
    "Standard error" = round(std_err, 5),
    Stage = "Model building"
  )|>
  select(-std_err)


# load model_tuning
load(here("2_model_tuning/results/tune_roc_tbl.rda"))

tbl_2 <- tune_roc_tbl|>
  rename(std_err = "Standard Error")|>
  mutate(
    Mean = round(Mean, 5),
    "Standard error" = round(std_err, 5),
    Stage = "Model tuning"
  )|>
  select(-std_err)

# load model_building
load(here("3_model_refinement/results/tune_roc_tbl.rda"))

tbl_3 <- tune_roc_tbl|>
  rename(std_err = "Standard Error")|>
  mutate(
    Mean = round(Mean, 5),
    "Standard error" = round(std_err, 5),
    Stage = "Model refinement"
  )|>
  select(-std_err)

tbl_compile <- tbl_1|>
  bind_rows(tbl_2, tbl_3)|>
  relocate(Stage, .before = 0)|>
  relocate("Standard error", .after = Mean)

# Reformat table ----
## Identify last row of each model for adding a separator line
line_positions <- which(!duplicated(tbl_compile$Stage, 
                                    fromLast = TRUE))

tbl_compile_reformat <- tbl_compile |>
  flextable() |>
  merge_v(j = "Stage") |>  # Merge Model type column
  theme_booktabs() |>  # Improve table styling
  align(j = c("Stage", "Model"), align = "left") |>  # Align text
  align(j = c("Mean", "Standard error"), align = "center") |>
  bold(part = "header") |>  # Bold headers
  padding(padding = 5, part = "all") |>  # Increase padding for better spacing
  hline(i = line_positions, border = fp_border_default(width = 2))   # Add bold horizontal line between models

save_as_image(tbl_compile_reformat,
              path = here("4_final_evaluation/tbl_compile_reformat.png"))