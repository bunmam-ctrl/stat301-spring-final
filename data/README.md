## Dataset Description

This folder contains all raw and cleaned versions of the **Patient Survival Dataset** used to train and evaluate classification models predicting in-hospital mortality.

The dataset was sourced from Kaggle:
**[Patient Survival Dataset](https://www.kaggle.com/datasets/mitishaagarwal/patient/dat)**

This dataset includes vital signs, lab values, comorbidities, and demographic information collected during ICU admissions, providing a comprehensive foundation for clinical risk modeling.


### Files

- **`patient_survival.csv`**: Raw dataset as downloaded from Kaggle (CSV format).
- **`patient_survival.rda`**: Serialized `.rda` version of the raw data for faster loading in R.
- **`patient_survival_tidy.rds`**: Cleaned and preprocessed version of the dataset, used throughout model building and evaluation.

### Codebook 

| **Variable**                                            | **Type**    | **Description**                                  |
| ------------------------------------------------------- | ----------- | ------------------------------------------------ |
| `age`                                                   | Numeric     | Age at admission (years)                         |
| `gender`                                                | Categorical | Patient’s biological sex                         |
| `ethnicity`                                             | Categorical | Self-identified ethnicity                        |
| `icu_admit_source`                                      | Categorical | ICU admission source                             |
| `bmi`                                                   | Numeric     | Body mass index                                  |
| `temp_apache`                                           | Numeric     | Admission temperature for APACHE                 |
| `d1_temp_min`, `d1_temp_max`                            | Numeric     | Day 1 temperature range                          |
| `heart_rate_apache`                                     | Numeric     | Avg heart rate (APACHE)                          |
| `h1_heart_rate_min`, `h1_heart_rate_max`                | Numeric     | 1st hour heart rate range                        |
| `resprate_apache`, `h1_resprate_min`, `h1_resprate_max` | Numeric     | Respiratory rates                                |
| `gcs_*_apache`                                          | Numeric     | Glasgow Coma Scale subscores                     |
| `d1_sysbp_*`, `h1_sysbp_*`                              | Numeric     | Systolic BP ranges                               |
| `d1_diabp_*`, `h1_diabp_*`                              | Numeric     | Diastolic BP ranges                              |
| `d1_mbp_*`, `h1_mbp_*`                                  | Numeric     | Mean arterial pressure                           |
| `d1_glucose_*`                                          | Numeric     | Glucose levels                                   |
| `d1_potassium_*`                                        | Numeric     | Potassium levels                                 |
| `h1_spo2_*`                                             | Numeric     | Oxygen saturation                                |
| `apache_*`                                              | Mixed       | APACHE scores and predictions                    |
| `apsiii_score`                                          | Numeric     | APACHE Physiology Score III                      |
| `aids`, `diabetes_mellitus`, etc.                       | Binary      | Presence of comorbidities                        |
| `ventilated_apache`, `intubated_apache`                 | Binary      | Intubation/ventilation status                    |
| **`hospital_death`**                                    | Binary      | **Target variable** – death (1) vs. survival (0) |


**Note**: Variables with total missingness (e.g., `...84`) were removed before modeling. Missing values in clinical fields were handled using appropriate imputation techniques during preprocessing.

