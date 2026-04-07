This folder contains the tuning outcomes, evaluation metrics, and supporting files used during the **model development and selection process**. Each file corresponds to a specific stage of hyperparameter tuning, model evaluation, or ensemble model construction.

#### Contents

- `bt_param.rda`, `rf_param.rda`, `nn_param.rda`
  R objects containing the **best hyperparameters** selected for the **boosted tree**, **random forest**, and **neural network** models based on tuning results.

- `bt_tune_plot.png`, `rf_tune_plot.png`, `nn_tune_plot.png`
  Plots showing the **tuning grid performance** (e.g., ROC-AUC) for each model, used to visualize and select optimal configurations.

- `tune_roc_tbl.rda`
  A consolidated **ROC-AUC summary table** comparing all individually tuned models. This table informed decisions for refinement and ensemble inclusion.

- `ensemble_param.rda`
  Contains details of the **stacking ensemble configuration**, including selected submodels and their corresponding hyperparameters.

- `ensemble_roc_auc.rda`
  Stores the **ensemble model’s ROC-AUC** evaluation result on the validation data.

- `stacking_coefficients_plot.png`
  A bar plot of **stacking coefficients** showing the relative contributions of each base learner (e.g., MARS, elastic net) in the final ensemble model.

