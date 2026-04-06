## Description

This project, developed as the **final project for STAT 301-3**, builds a **predictive model** to classify patients as `Survived` or `Died` during hospitalization using clinical admission data. Leveraging the [Patient Survival Dataset](https://www.kaggle.com/datasets/mitishaagarwal/patient/dat) from Kaggle, the project applies **supervised machine learning techniques** to analyze patient vitals, lab results, comorbidities, and demographic information.

The overall goal is to support clinical decision-making by identifying high-risk patients early in their hospital stay. A variety of models—including **boosted trees**, **random forests**, and **neural networks**—were developed, tuned, and evaluated using **ROC-AUC** to handle the severe class imbalance in the dataset. The pipeline culminates in an **ensemble model** designed to combine the strengths of the best-performing classifiers.

### Directories

- [`1_model_building/`](1_model_building/): Contains all scripts and objects related to the initial model development, including baseline classifiers (null, naive Bayes), general preprocessing recipes, cross-validation setup, and model selection based on ROC-AUC.
- [`2_model_tuning/`](2_model_tuning/):  Includes scripts and saved objects for hyperparameter tuning, such as tuning grids, tuning results, model metrics, and performance visualizations for top-performing models.
- [`3_model_refinement/`](3_model_refinement/): Stores scripts and outputs for the final tuning phase, including enhanced preprocessing (e.g., bagged tree and KNN imputation), narrowed hyperparameter ranges, and preparation steps for ensemble modeling.
- [`4_final_evaluation/`](4_final_evaluation/): Contains scripts and outputs used for final evaluation on the holdout test set, including performance comparisons, confusion matrices, and final ROC-AUC plots.
- [`data/`](data/): Contains raw and processed datasets used for training and testing the classification models.
- [`data-check/`](data-check/): Provides data diagnostics such as missing value summaries and variable distributions.
- [`EDA_script/`](EDA_script/): Exploratory data analysis scripts used to guide feature selection and transformation decisions.
- [`memos/`](memos/): Includes `.qmd` and `.html` files for the progress memos submitted during the course.

### Project Reports & Summaries

- `women_in_stem_final_report.qmd` & `women_in_stem_final_report.html`
  Full technical report outlining project motivation, data cleaning, modeling strategy, evaluation results, and conclusions.

- `women_in_stem_executive_summary.qmd` & `women_in_stem_executive_summary.html`
  Concise summary of the project for non-technical audiences, highlighting objectives, findings, and potential impact.


