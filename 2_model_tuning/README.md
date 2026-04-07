This directory contains all files and outputs related to the **hyperparameter tuning phase** of the model development process. It focuses on refining the top-performing models from the initial evaluation through systematic grid searches and updated preprocessing pipelines.

### Subdirectories

- [**`data_splits/`**](data_splits/)
  Contains training/testing split objects and resampling structures (e.g., 5-fold cross-validation with 3 repeats) to ensure consistent model evaluation during tuning.

- [**`R_script/`**](R_script/)
  R scripts that define the refined workflows, execute tuning routines, and generate model performance visualizations.

- [**`recipes/`**](recipes/)
  Updated preprocessing pipelines for each selected model, incorporating modifications such as PCA, interaction terms, and advanced imputation.

- [**`results/`**](results/)
  Stores tuning results including optimal hyperparameter combinations, performance metrics (e.g., ROC-AUC), and plots illustrating model performance across grid values.

- [**`tune-model/`**](tune-model/)
  Serialized tuning objects (`.rda`) capturing the full tuning results for each model, used for later model extraction and comparison.
