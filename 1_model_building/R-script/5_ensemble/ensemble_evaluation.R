# Final Project
# Assess final model (Ensemble)-----

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(stacks)

# handle common conflicts
tidymodels_prefer()

# load testing/fitting/metrics data
load(here("1_model_building/data_splits/patient_survival_training.rda"))
load(here("1_model_building/tune-model/ensemble_tune/ensemble_fit.rda"))
load(here("1_model_building/tune-model/ensemble_tune/stack_blend.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))

# Assess the model performance ----
## Prediction ----
patient_pred_mem <-  patient_survival_training|>
  select(hospital_death)|>
  bind_cols(
    predict(ensemble_fit, 
            new_data = patient_survival_training,
            members =  TRUE,
            type = "prob"))

## ROC-AUC table by model----
ensemble_roc_auc<- patient_pred_mem|>
  pivot_longer(
    cols = -c(hospital_death), 
    names_to = "members",
    values_to = "pred"
  )|>
  group_by(members)|>
  summarize(roc_auc = roc_auc_vec(hospital_death, pred))|>
  arrange(desc(roc_auc))|>
  mutate(members = case_when(
    members == ".pred_0" 
    ~ "Ensemble",
    str_starts(members, ".pred_0_en_tune") 
    ~ str_c("Elastic net (", str_extract(members, "\\d+_\\d+"), ")"),
    str_starts(members, ".pred_0_mars_tune") 
    ~ str_c("MARs (", str_extract(members, "\\d+_\\d+"), ")"),
  ))|>
  drop_na()|>
  rename(
    "Model name" = members, 
    "ROC-AUC" = roc_auc
  )

save(ensemble_roc_auc, 
     file = here("1_model_building/results/ensemble_roc_auc.rda"))

### Boosted Tree
en_ensemble_param <- collect_parameters(stack_blend, "en_tune")|>
  filter(coef !=0)|>
  mutate(
    penalty = round(penalty, 4),
    mixture = round(mixture, 4),
    parameters = paste0("penalty = ", penalty,
                        "; mixture = ", mixture),
    member = case_when(
      str_starts(member, "en") 
      ~ str_c("Elastic net (", str_extract(member, "\\d+_\\d+"), ")")
    ))|>
  select(member, coef,  parameters)|>
  rename(
    "Model name" = member, 
    "Parameters" = parameters,
    "Coefficient" = coef
  )

### Random forest
mars_ensemble_param <- collect_parameters(stack_blend, "mars_tune")|>
  filter(coef !=0)|>
  mutate(
    parameters = paste0("num_terms of = ", num_terms,
                        "; prod_degree = ", prod_degree),
    member = case_when(
      str_starts(member, "mars") 
      ~ str_c("MARs (", str_extract(member, "\\d+_\\d+"), ")")
    ))|>
  select(member, coef,  parameters)|>
  rename(
    "Model name" = member, 
    "Parameters" = parameters,
    "Coefficient" = coef
  )


ensemble_param <- en_ensemble_param|>
  bind_rows(mars_ensemble_param)|>
  arrange(desc(Coefficient))

save(ensemble_param,
     file = here("1_model_building/results/ensemble_param.rda"))


