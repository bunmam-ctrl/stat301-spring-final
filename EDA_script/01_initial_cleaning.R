## Initial Cleaning

# load packages ----
library(tidyverse)
library(patchwork)
library(tidymodels)
library(naniar)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
patient_survival <- read_csv(here("data/patient_survival.csv"))

patient_survival_tidy <- patient_survival|>
  mutate(
    hospital_death = factor(hospital_death, levels = c("1", "0"),
                            labels = c("Death", "Survived")),
    across(where(is.character), as.factor)
  )

## Save out data 
write_rds(patient_survival_tidy,
          file = here("data/patient_survival_tidy.rds"))

# check for missing data
## Graphic na 
na_overview <- patient_survival |>
  select(where(~ any(is.na(.)))) |>
  gg_miss_var() +
  labs(title = "Missing Values in Patient Survivial dataset",
       subtitle = "(only variables with missing values)",
       x = NULL) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, face = "italic", hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12)
  )
  
### Save the graph
ggsave(na_overview, 
       filename = here("data-check/na_overview.png"),
       height = 20,
       width = 10
)

## summary table----
patient_summary <- patient_survival|>
  summarize(
    observations_number = nrow(patient_survival),
    variables_number = ncol(patient_survival),
    numerical_variables_number = sum(
      sapply(patient_survival, is.numeric)
    ),
    categorical_variables_number = sum(
      sapply(patient_survival, is.character)
    ),
    missing_values_total_number = sum(
      is.na(patient_survival)
    ),
    percentage_missing_number = round(
      sum(
        is.na(patient_survival)) / (nrow(patient_survival) * ncol(patient_survival))
      * 100)
  )|>
  rename(
    "Observation" = observations_number,
    "Variables" = variables_number,
    "Numerical variables" =  numerical_variables_number,
    "Categorical variables" =  categorical_variables_number,
    "Missing values" =  missing_values_total_number,
    "Missing values percentage" = percentage_missing_number
  )|>
  pivot_longer(
    cols = everything(),
    names_to = "Metric",
    values_to = "Number"
  )|>
  mutate(
    Number = as.integer(Number)
  )

### Save the table 
save(patient_summary,
     file = here("data-check/patient_summary.rda"))

