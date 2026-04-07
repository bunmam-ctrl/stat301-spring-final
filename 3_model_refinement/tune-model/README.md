This folder contains the **saved tuning results (`.rda`)** for the top-performing models from the model building phase.

#### Contents

| **File**      | **Model Type** | **Description**                                                                |
| ------------- | -------------- | ------------------------------------------------------------------------------ |
| `bt_tune.rda` | Boosted Tree   | Grid tuning results for `mtry`, `min_n`, `trees`, and `learn_rate`.            |
| `rf_tune.rda` | Random Forest  | Results from grid search over `mtry`, `min_n`, and fixed `trees = 2000`.       |
| `nn_tune.rda` | Neural Network | Tuning of `hidden_units`, `penalty`, and `num_comp`. |

