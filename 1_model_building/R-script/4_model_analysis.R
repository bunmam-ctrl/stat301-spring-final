# Final Project 
# Model selection/comparison & analysis

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
# load fitting model
list.files (
  here("1_model_building/tune-model/"),
  pattern = ".rda",
  full.names = TRUE
)|>
  map(load, envir = .GlobalEnv)

# visual inspection using autoplot----
autoplot(knn_tune, metric = "roc_auc")

## Random Forest
autoplot(rf_tune, metric = "roc_auc")

## Neural Network
autoplot(nn_tune, metric = "roc_auc")

## SVM_radial
autoplot(svm_radial_tune, metric = "roc_auc")

## SVM_poly
autoplot(svm_poly_tune, metric = "roc_auc")

## BT
autoplot(bt_tune, metric = "roc_auc")


### ROC and accuracy has the same best model----------------------------------------------------------
# Compile table 
model_tune <- as_workflow_set(
  null = null_fit,
  nb = nb_tune,
  lg = lg_fit, 
  en = en_tune, 
  knn = knn_tune,
  rf = rf_tune,
  bt = bt_tune,
  svm_poly = svm_poly_tune,
  svm_radial = svm_radial_tune,
  mars = mars_tune,
  nn = nn_tune 
)

## Create time table
time_tbl <- tictoc_null|> #1st: null
  bind_rows(tictoc_nb)|> #2nd: nb
  bind_rows(tictoc_lg)|>  #3rd: lg
  bind_rows(tictoc_en)|> #4th: en
  bind_rows(tictoc_knn)|>#5th: knn
  bind_rows(tictoc_rf)|> #6th: rf
  bind_rows(tictoc_bt)|> #7th: bt
  bind_rows(tictoc_svm_radial)|> #7th: svm_radial
  bind_rows(tictoc_svm_poly)|> #7th: svm_poly
  bind_rows(tictoc_mars)|> #9th: mars
  bind_rows(tictoc_nn)|> #10th: nn
  mutate(
    runtime = round(runtime/60, digits = 0) # in minutes
  )|>
  select(model, runtime)


# Create Evaluation table----
## Select top model based on ROC-AUC
top_models <- model_tune |> 
  collect_metrics() |>
  filter(.metric == "roc_auc") |>  
  slice_max(mean, by = wflow_id)|>
  select(wflow_id, .config)

## Retrieve  ROC AUC for these models  
tune_roc_tbl <-  model_tune|>
  collect_metrics() |>
  inner_join(top_models, by = c("wflow_id",".config") )|> 
  filter(.metric == "roc_auc") |> 
  bind_cols(time_tbl)|>
  select(wflow_id, mean, std_err, runtime)|>
  mutate(
    wflow_id = case_when(
      wflow_id %in%  "null"~ "Null",
      wflow_id %in%  "nb"~ "Naive Bayes",
      wflow_id %in%  "lg"~ "Logistic regession",
      wflow_id %in%  "en"~ "Elastic net",
      wflow_id %in%  "knn"~ "K-nearest neighbors",
      wflow_id %in%  "rf"~ "Random forest",
      wflow_id %in%  "bt"~ "Boosted tree",
      wflow_id %in%  "svm_radial"~ "SVM radial",
      wflow_id %in%  "svm_poly"~ "SVM polynomial",
      wflow_id %in%  "mars"~ "MARs",
      wflow_id %in%  "nn"~ "Neural network"
    )
  )|>
  rename(
    "Model" = wflow_id,  
    "Mean" = mean, 
    "Standard Error" = std_err,
    "Runtime (minutes)" = runtime
  )

## Save table 
save(tune_roc_tbl,
  file = here("1_model_building/results/tune_roc_tbl.rda")
)


### Best model are neural network, RF, BT
# collect metrics
## SVM poly
nn_param <- select_best(nn_tune, metric = "roc_auc")|>
  select(hidden_units, penalty)

save(nn_param,
     file = here("1_model_building/results/nn_param.rda")
)


## Random Forest
rf_param <- select_best(rf_tune, metric = "roc_auc")|>
  mutate(
    trees = 1000
  )|>
  select(trees,mtry, min_n)

save(rf_param,
     file = here("1_model_building/results/rf_param.rda")
)

## Boosted tree
bt_param <- select_best(bt_tune, metric = "roc_auc")|>
  select(trees, mtry, min_n, learn_rate)

save(bt_param,
     file = here("1_model_building/results/bt_param.rda")
)
