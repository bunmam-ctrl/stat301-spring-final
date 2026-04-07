This directory contains **individual scripts** for fitting and tuning all classification models explored in the `model_building` stage. Each script defines the model specification, preprocessing workflow, tuning grid, and evaluation pipeline using cross-validation.

#### Scripts

- **`3_fit_null.R`** — Implements the null model (majority class predictor).
- **`3_fit_logistic.R`** — Fits a logistic regression model without tuning.
- **`3_tune_nbayes.R`** — Baseline naive Bayes classifier.
- **`3_tune_en.R`** — Elastic net: tunes `penalty` and `mixture`.
- **`3_tune_knn.R`** — K-nearest neighbors: tunes `neighbors`.
- **`3_tune_rf.R`** — Random forest: tunes `mtry`, `min_n`, `trees`.
- **`3_tune_bt.R`** — Boosted tree: tunes `mtry`, `min_n`, `trees`, `learn_rate`.
- **`3_tune_mars.R`** — Multivariate Adaptive Regression Splines (MARS): tunes interaction degree and retained terms.
- **`3_tune_nn.R`** — Neural network: tunes `hidden_units`, `penalty`, `epochs`.
- **`3_tune_svm_radial.R`** — SVM with radial basis function kernel: tunes `cost` and `rbf_sigma`.
- **`3_tune_svm_poly.R`** — SVM with polynomial kernel: tunes `cost`, `degree`, `scale_factor`.
