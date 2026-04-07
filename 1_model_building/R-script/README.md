This folder contains all **R scripts** used to build, tune, and evaluate classification models in the `model_building` stage.

#### Script Descriptions

- **`1_initial_setup.R`**
  Loads necessary packages, sets the working directory, and initializes data objects.

- **`2_recipes.R`**
  Defines preprocessing recipes, including removal of unnecessary columns, imputation steps, normalization, and encoding.

- [**`3_tune/`** ](3_tune/)
  Contains model-specific tuning scripts for different algorithms.

- **`4_model_analysis.R`**
  Summarizes tuning results, selects best-performing models, and compares ROC-AUC metrics.

- **`4a_tune_visualization.R`**
  Produces tuning diagnostics and visual comparisons of hyperparameter performance across models.

- [**`5_ensemble`/**](5_ensemble/)
Includes all scripts related to ensemble modeling, such as stacking, member model registration, ensemble training, and final evaluation.
