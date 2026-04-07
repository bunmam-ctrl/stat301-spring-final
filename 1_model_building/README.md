This directory contains all components used in the **initial model development phase**, including baseline models, preprocessing, and model training for performance comparison.

### Subdirectories

- [**`data_splits/`**](data_splits/)
  Stores training/testing split objects and resampling structures (e.g., 5-fold CV with 3 repeats) used during model training.

- [**`R-script/`**](R-script/)
  Scripts used to define and fit models, including the null model, naive Bayes, logistic regression, and initial implementations of tree-based, SVM, and neural network models.

- [**`recipes/`**](recipes/)
  Preprocessing pipelines for each model, including steps for imputation, normalization, encoding, and variable filtering.

- [**`results/`**](results/)
  Saved evaluation metrics (e.g., ROC-AUC), tuning plots, and output predictions for each model during the building stage.

- [**`tune-model/`**](tune-model//)
  Early tuning outputs for models that required basic hyperparameter adjustment (prior to full grid search refinement).

