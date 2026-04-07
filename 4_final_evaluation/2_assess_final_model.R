# Final Project
# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

# handle common conflicts
tidymodels_prefer()


# load fitting/dataset
load(here("4_final_evaluation/final_fit.rda"))
load(here("1_model_building/data_splits/patient_survival_testing.rda"))
load(here("1_model_building/data_splits/my_metrics.rda"))


# Assess the model performance ----
## Prediction ----
patient_pred <- patient_survival_testing |>
  select(hospital_death)|>
  bind_cols(
    predict(final_fit, 
          new_data = patient_survival_testing),
    predict(final_fit, 
          new_data = patient_survival_testing, 
          type = "prob"))|>
  mutate(hospital_death = factor(hospital_death,
                                 levels = c(0, 1),
                                 labels  = c("Survived", "Death")),
          .pred_class = factor(.pred_class, 
                               levels = c(0, 1),
                               labels = c("Survived", "Death")))


##  Metrics ----
patient_final_metrics <- patient_pred |>
  ungroup()|>
  my_metrics(truth = hospital_death, 
             estimate = .pred_class, 
             .pred_0)|>
  filter(.metric %in% c("accuracy", "roc_auc")) |>
  mutate(.metric = case_when(
    .metric == "accuracy" ~ "Accuracy",
    .metric == "roc_auc" ~ "ROC-AUC"
  )) |>
  select(.metric, .estimate) |>
  rename(
    "Performance Metric" = .metric,
    "Estimate Value" = .estimate
  )

save(patient_final_metrics,
     file = here("4_final_evaluation/patient_final_metrics.rda")
)


## ROC_AUC curve ----
### High quality
final_roc_auc_curve <- roc_curve(patient_pred|>
                                   ungroup(), 
            hospital_death, 
            .pred_0)|> 
  ggplot(aes(x = (1- specificity), y = sensitivity))+ 
  geom_line(color = "#E41A1C", 
            linewidth = 1.2) +  
  geom_abline(linetype = "dashed", 
              color = "darkgray",
              linewidth = 1.2) + 
  theme_minimal() + 
  labs(
    title = "ROC Curve for Predicting Patient Survival",
    subtitle = "Boosted Tree Model \nTrees = 1000 | mtry = 10 | Min node size = 2 | Learning rate = 0.022",
    x = "False Positive Rate",
    y = "True Positive Rate"
  ) +
  theme(
    plot.title = element_text(face = "bold", 
                              size = 16,
                              hjust = 0.5),
    plot.subtitle = element_text(face = "italic", 
                                 size = 14, hjust = 0.5 ),
    axis.title = element_text(size = 12),
    axis.text.x = element_text(size = 10, hjust = 1),
    axis.text.y = element_text(size = 10)
  )



ggsave(final_roc_auc_curve,
       filename = "4_final_evaluation/final_roc_auc_curve.png")





## Confusion matrix ----
patient_conf_mat <- patient_pred|>
  ungroup()|>
  conf_mat(hospital_death, .pred_class)|>
  autoplot(type = "heatmap") +
  labs(
    title = "Confusion Matrix for Predicting Patient Status",
    subtitle = "Boosted Tree Model \nTrees = 1000 | mtry = 10 | Min node size = 2 | Learning rate = 0.022",
    x = "Actual Patient Status",
    y = "Predicted Patient Status"
  )+
    scale_fill_gradient2(
      low = "#FDEDEC",
      mid = "#AED6F1",
      high = "#2E86C1",
      midpoint = 1500  # customize based on your expected mid count
    )+
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 14, face = "italic", hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text.x = element_text(size = 10, hjust = 1),
    axis.text.y = element_text(size = 10)
  )

### Save the figure
ggsave(patient_conf_mat, 
       filename = "4_final_evaluation/patient_conf_mat.png")

