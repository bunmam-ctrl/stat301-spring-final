This directory contains all R scripts used to build, fit, evaluate, and visualize the ensemble model based on the stacking approach. 

### Script Descriptions

- **`ensemble_stack.R`**
  Constructs the initial model stack using candidate member models.

- **`stack_fit.R`**
  Fits the stacked ensemble model using the `blend_predictions()` and `fit_members()` functions.

- **`stack_evaluation.R`**
  Evaluates performance of individual member models and the final ensemble using ROC-AUC and other metrics.

- **`ensemble_evaluation.R`**
  Compares ensemble performance to base learners, generates visualizations, and summarizes findings.

- **`tune_en.R`**
  Tunes the Elastic Net model used in the ensemble as a baseline learner.

- **`tune_mars.R`**
  Tunes the MARS model (Multivariate Adaptive Regression Splines) included in the ensemble.

