This folder contains all relevant files, plots, and scripts used to **evaluate the final boosted tree model** for predicting patient survival based on clinical data. The model was selected after multi-stage tuning and refinement and finalized using optimal hyperparameters identified during earlier evaluation phases.

### Contents

| **File Name**               | **Description**                                                                       |
| --------------------------- | ------------------------------------------------------------------------------------- |
| `1_train_final_model.R`     | Script for fitting the final boosted tree using selected hyperparameters.             |
| `2_assess_final_model.R`    | Script for generating test-set predictions, computing metrics, and producing visuals. |
| `final_fit.rda`             | Serialized R object of the trained final boosted tree model.                          |
| `patient_final_metrics.rda` | RDA file storing final test set performance metrics (e.g., accuracy, ROC-AUC).        |
| `final_roc_auc_curve.png`   | ROC curve visualizing the model’s classification capability on the test set.          |
| `patient_conf_mat.png`      | Confusion matrix heatmap summarizing predicted vs. actual survival outcomes.          |
| `tbl_compile_reformat.png`  | Summary table showing comparative ROC-AUC results across model phases.                |
| `metrics_compile.R`         | Script for compiling and formatting final metric results for reporting.               |
