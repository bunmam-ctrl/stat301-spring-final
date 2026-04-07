This folder contains R scripts used to perform early-stage exploratory data analysis (EDA), target assessment, and feature interaction exploration before formal model development.

#### Scripts

- **`01_initial_cleaning.R`**
  Performs initial preprocessing such as variable renaming, type conversion, and removal of irrelevant columns or completely missing variables.

- **`02_target_var_eda.R`**
  Explores the distribution and imbalance of the target variable (`hospital_death`), including stratified summaries by gender, age, and ethnicity. Supports justification for class balancing methods like downsampling.

- **`03_interact.R`**
  Computes correlation between `age` and all numeric predictors to identify variables with strong interaction potential. Outputs were used to guide the design of `step_interact()` in preprocessing.
