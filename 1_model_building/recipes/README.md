This directory contains all preprocessing **recipe objects** (`.rda` files) used for model training during the initial model building phase. Each recipe defines the transformation pipeline applied to the dataset before model fitting, including steps such as imputation, normalization, encoding, and feature filtering.

#### Contents

- `bt_recipe.rda`
  Preprocessing recipe tailored for the **boosted tree** model, with one-hot encoding and custom imputation.

- `rf_recipe.rda`
  Recipe for the **random forest** model, including tree-compatible preprocessing such as one-hot encoding and bagged tree imputation.

- `mars_recipe.rda`
  Recipe used for the **MARS** (Multivariate Adaptive Regression Splines) model with normalization and spline-compatible feature prep.

- `nb_recipe.rda`
  Simple recipe used for the **naive Bayes** baseline, applying minimal preprocessing to benchmark other models.

- `patient_recipe.rda`
  General-purpose recipe object for the full patient dataset, used during EDA and initial model trials.

