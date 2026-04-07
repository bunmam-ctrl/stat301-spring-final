This directory contains all scripts, objects, and outputs related to the **final model refinement phase** of development. In this stage, top-performing models were fine-tuned using enhanced preprocessing, more sophisticated imputation strategies, and narrowed hyperparameter search grids. This phase also laid the groundwork for ensemble modeling by finalizing individual model components.

### Subdirectories

- [**`R_script/`**](R_script/):
  Contains R scripts for refining model workflows, applying enhanced imputation methods (e.g., bagged trees, KNN), and preparing final models for stacking.

- [**`recipes/`**](recipes/):
  Holds finalized preprocessing pipelines for each refined model. Recipes include updated feature engineering, robust imputation, and consistency with prior modeling phases.

- [**`results/`**](results/):
  Stores evaluation outputs such as refined ROC-AUC metrics, tuning plots, and comparative model performance summaries.

- [**`tune-model/`**](tune-model/):
  Serialized tuning outputs (`.rda` files) reflecting updated model performance after refinement. These objects are used for final evaluation and ensemble construction.

