This directory contains all **refined preprocessing recipe objects** (`.rda` files) developed for the **model refinement phase**. These recipes apply tailored transformation pipelines to the training data, ensuring each model type receives appropriate preprocessing for optimal performance.

### Contents

- **`reg_complex_recipe.rda`**
  Used for **regression-based models** (e.g., elastic net). Includes normalization, removal of highly correlated predictors, near-zero variance filtering, and robust imputation strategies for numeric and categorical variables.

- **`tree_complex_recipe.rda`**
  Designed for **tree-based models** (e.g., random forest, boosted tree). Applies one-hot encoding, bagged tree imputation, and structure-preserving transformations suitable for ensemble learners.

- **`nn_complex_recipe.rda`**
  Tailored for the **neural network model**, incorporating principal component analysis (PCA) for dimensionality reduction (`num_comp`), along with normalization and strategies conducive to regularized training.

