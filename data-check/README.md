This folder contains exploratory visualizations and `.rda` summary objects that were used to assess **data quality**, **target class imbalance**, and **feature correlation** prior to model development.

#### Plots

- **`age_corr_plot.png`**: Visualizes the correlation between `age` and all numeric predictors to explore potential interaction effects.
- **`death_count_plot.png`**: Bar chart showing the severe class imbalance in the `hospital_death` target variable.
- **`na_overview.png`**: Heatmap or bar plot displaying missing value proportions across all features.
- **`death_count_plot.rda`**: Serialized version of the `death_count_plot` for use in R Markdown reports.

#### Summary Data Objects

- **`patient_summary.rda`**: General descriptive statistics (e.g., age, gender distribution, death rates).
- **`survival_by_age.rda`**: Tabulation of survival outcome broken down by age group.
- **`survival_by_gender.rda`**: Survival summary stratified by gender.
- **`survival_ethnicity.rda`**: Mortality rates across ethnic groups.
- **`survival_ratio.rda`**: Summary of proportions between death and survival in the dataset.

