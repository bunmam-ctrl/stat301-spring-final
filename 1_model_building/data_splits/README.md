This folder contains all **data objects and resampling components** used during the model development pipeline.

#### Contents

- **`patient_survival_training.rda`**
  Training set (80% of the original dataset), used for model fitting and validation.

- **`patient_survival_testing.rda`**
  Testing set (20% of the original dataset), reserved for final model evaluation.

- **`patient_survival_folds.rda`**
  Cross-validation folds used for training: 5-fold CV with 3 repeats.

- **`keep_wflow.rda`**
  Stores selected workflow objects for final model execution or reuse.

- **`my_metrics.rda`**
  Custom metric set including ROC-AUC and other evaluation criteria used consistently across model comparisons.

