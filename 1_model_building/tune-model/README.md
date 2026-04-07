This directory contains the **serialized tuning results** for each model evaluated during the model building phase. These `.rda` files store the output of cross-validation and hyperparameter tuning using the `tune_grid()` function from the `tidymodels` framework.

#### Contents

| **File**              | **Model Type**          | **Description**                                                   |
| --------------------- | ----------------------- | ----------------------------------------------------------------- |
| `bt_tune.rda`         | Boosted Tree            | Results from grid tuning (`mtry`, `min_n`, `trees`, `learn_rate`) |
| `rf_tune.rda`         | Random Forest           | Grid search over `mtry`, `min_n`, and `trees`                     |
| `nn_tune.rda`         | Neural Network          | Results for tuned `hidden_units`, `penalty`, and `epochs`         |
| `en_tune.rda`         | Elastic Net             | Tuning of `penalty` and `mixture` values                          |
| `knn_tune.rda`        | K-Nearest Neighbors     | Tuning results for `neighbors`                                    |
| `mars_tune.rda`       | MARS                    | Tuning of interaction degree and retained terms                   |
| `nb_tune.rda`         | Naive Bayes             | Results using basic preprocessing and no tuning                   |
| `lg_fit.rda`          | Logistic Regression     | Fitted without tuning (benchmark interpretable model)             |
| `null_fit.rda`        | Null Model              | Majority class baseline                                           |
| `svm_poly_tune.rda`   | SVM (Polynomial Kernel) | Tuning over `cost`, `degree`, `scale_factor`                      |
| `svm_radial_tune.rda` | SVM (Radial Kernel)     | Tuning over `cost` and `rbf_sigma`                                |

