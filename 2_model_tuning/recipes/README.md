This directory contains all **refined preprocessing recipe objects** (`.rda` files) used during the **model tuning phase**. Each recipe defines a structured transformation pipeline applied to the training data before model fitting, tailored to suit the specific needs of different model types.

#### Contents

- **`reg_complex_recipe.rda`**
  Recipe for **regression-based models** (e.g., elastic net), including normalization, filtering of near-zero variance predictors, and imputation for both numeric and categorical variables.

- **`tree_complex_recipe.rda`**
  Recipe used for **tree-based models** (e.g., random forest, boosted trees), which includes **one-hot encoding**, bagged tree imputation, and filtering steps suited to ensemble learners.

- **`nn_complex_recipe.rda`**
  Recipe customized for the **neural network model**, incorporating PCA for dimensionality reduction (`num_comp`), normalization, and regularization-friendly preprocessing.

