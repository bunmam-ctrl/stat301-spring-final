This folder contains all **R scripts** used for tuning and evaluating machine learning models during the **model tuning** phase of the project.

#### Script Descriptions

- **`1_initial_setup.R`**
  Initializes the environment by loading required packages, setting random seeds, and loading previously split data for training and validation.

- **`2_recipes.R`**
  Constructs advanced preprocessing pipelines tailored for different model types (e.g., regression, tree-based, neural network). Includes updated imputation techniques and encoding strategies.

- **`3_tune_bt.R`**
  Performs grid search tuning for the boosted tree model using cross-validation and refined hyperparameter space.

- **`3_tune_rf.R`**
  Conducts tuning of the random forest model by adjusting tree depth and number of variables sampled at each split.

- **`3_tune_nn.R`**
  Tunes the neural network model by exploring combinations of hidden units, penalty terms, and number of components.

- **`4_model_analysis.R`**
  Aggregates tuning results, compares model performance based on ROC-AUC, and prepares outputs for visualization.

- **`4a_tune_visualization.R`**
  Generates visualizations of tuning grid results, including line and scatter plots to show relationships between hyperparameters and model performance.

