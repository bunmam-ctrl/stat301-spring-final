This folder contains the **data objects and control settings** used specifically for model tuning.

#### Contents

- **`ctrl_grid.rda`**
  Contains the tuning control object (`control_grid()`) used for models undergoing hyperparameter tuning (e.g., boosted tree, random forest, neural network).

- **`ctrl_res.rda`**
  Control object for resampling with `control_resamples()`, typically used for baseline models like logistic regression. *Note: Not relevant for models being tuned in this stage.*

- **`patient_survival_training.rda`**
  Training dataset used to generate resamples for tuning procedures.

- **`patient_survival_testing.rda`**
  Holdout test dataset reserved for final model evaluation.

- **`patient_survival_folds.rda`**
  Object containing stratified 5-fold cross-validation with 3 repeats for robust tuning evaluation.

