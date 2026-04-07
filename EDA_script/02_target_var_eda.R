# Target Variable Analysis 
# STAT 301-3 Final Project 


# Load Packages ----
library(tidyverse)
library(tidymodels)
library(patchwork)
library(ggplot2)
library(corrplot)
library(here)


# load data ----
patient_survival_tidy <-read_rds(here("data/patient_survival_tidy.rds"))


# target variable: hospital_death 
# deaths: 7919 / alive: 83798 

death_count <- patient_survival_tidy |>
  group_by(hospital_death) |>
  summarize(count = n())
  
# count plot ----
death_count_plot <- death_count|>
  ggplot(aes(x = hospital_death, y = count, fill = hospital_death)) +
  geom_col() +
  geom_text(
    data = death_count, 
    aes(label = count),
    vjust = 2,
    color = "white"
  ) +
  labs(x = "Outcome", 
       y = "Count",
       title = " Distribution of Patient Outcomes \nin the Patient Survival Dataset") +
  scale_fill_manual(values = c("Death" = "steelblue", 
                               "Survived" = "firebrick"))  +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, face = "italic", hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    legend.position = "none"
  )

## Save the plot
ggsave(death_count_plot, 
       filename = here("data-check/death_count_plot.png"))

# proportion/ratio check ----
survival_ratio <- patient_survival_tidy |>
  count(hospital_death) |>
  mutate(prop = n / sum(n) * 100)|>
  rename(
    Outcome = hospital_death,
    Count = n,
    Percentage = prop
  )

save(survival_ratio, 
     file = here("data-check/survival_ratio.rda"))


# death analysis based on age range ----
survival_by_age <- patient_survival_tidy |>
  mutate(age_group = cut(age, breaks = c(0, 20, 40, 60, 80, 100), right = FALSE)) |> 
  group_by(age_group, hospital_death) |>
  summarize(
    count = n(),
    .groups = 'drop'
  ) |>
  pivot_wider(
    names_from = hospital_death, 
    values_from = count
  )|>
  rename(
    "Age range" = age_group
  )
## Save the table 
save(survival_by_age, 
     file = here("data-check/survival_by_age.rda"))

# death by gender -----
survival_by_gender <- patient_survival_tidy |>
  group_by(gender, hospital_death) |>
  summarize(count = n(), .groups = 'drop') |>
  pivot_wider(
    names_from = hospital_death, 
    values_from = count
  ) |>
  mutate(
    total = `Death` + `Survived`,
    percentage = (`Death` / total) * 100
  ) |>
  rename(
    Gender = gender, 
    Total = total, 
    Percentage = percentage
  )

## Save out the table 
save(survival_by_gender, 
     file = here("data-check/survival_by_gender.rda"))


# ethnicity and patient death----
survival_ethnicity <- patient_survival_tidy |>
  group_by(ethnicity, hospital_death) |>
  summarize(count = n(), .groups = 'drop') |>
  pivot_wider(
    names_from = hospital_death, 
    values_from = count
  ) |>
  mutate(
    total = `Survived` + `Death`,
    percentage = (`Death` / total) * 100
  )|>
  rename(
    Ethnicity = ethnicity,
    Total = total, 
    Percentage = percentage
  )

## save out tables
save(survival_ethnicity, 
     file = here("data-check/survival_ethnicity.rda"))













