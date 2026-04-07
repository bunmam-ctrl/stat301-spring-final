This folder contains **compiled results and visual diagnostics** generated during the model tuning and evaluation stages. 

#### Contents

- **`rf_param_compile.rda`**, **`bt_param_compile.rda`**, **`nn_param_compile.rda`**
  Serialized `.rda` files containing the **best-performing hyperparameter combinations** for the random forest, boosted tree, and neural network models, respectively.

- **`rf_tune_plot.png`**, **`bt_tune_plot.png`**, **`nn_tune_plot.png`**
  Visualization outputs summarizing **tuning grid performance**, including ROC-AUC values across hyperparameter combinations. 

- **`tune_roc_tbl.rda`**
  A summary R object consolidating ROC-AUC metrics across all tuned models, used to **compare model effectiveness** and guide decisions for further refinement or ensemble modeling.

