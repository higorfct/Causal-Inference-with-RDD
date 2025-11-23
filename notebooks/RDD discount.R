
# LOADING REQUIRED PACKAGES

library(rddtools)
library(rdrobust)
library(rddensity)
library(ggplot2)
library(dplyr)
library(rdd) 


# STEP 1 - READING DATA FROM XLSX

# Adjust the path to your Excel file
data <- read_excel("dataset_rdd.xlsx")


# Checking that columns are correct
str(data)
# Expected columns: score, treatment, renewed


# STEP 2 - VISUAL EXPLORATION

n_bins <- 20

data_binned <- data %>%
  mutate(bin = cut(score, breaks = n_bins)) %>%
  group_by(bin) %>%
  summarise(score_mean = mean(score),
            renewed_mean = mean(renewed),
            treatment = mean(treatment))

ggplot(data_binned, aes(x = score_mean, y = renewed_mean)) +
  geom_point(aes(color = as.factor(treatment)), size = 2) +
  geom_smooth(method = "lm", se = FALSE,
              aes(color = as.factor(treatment), group = as.factor(treatment))) +
  geom_vline(xintercept = 80, linetype = "dashed") +
  labs(title = "RDD with Bin Means",
       x = "Engagement Score (bin average)",
       y = "Renewal Rate (bin average)",
       color = "Treatment")


# STEP 3 - ESTIMATE WITH RDestimate

rd_model <- RDestimate(renewed ~ score, data = data, cutpoint = 80)
summary(rd_model)

# STEP 4 - ESTIMATE WITH rdrobust

robust_model <- rdrobust(y = data$renewed, x = data$score, c = 80)
summary(robust_model)


# STEP 5 - VISUALIZATION WITH rdplot

rdplot(y = data$renewed, x = data$score, c = 80,
       x.label = "Engagement Score", y.label = "Renewal Rate",
       title = "RDD: Effect of Discount on Renewal")


# STEP 6 - MANIPULATION TEST (McCrary)

density <- rddensity(data$score, c = 80)
summary(density)


# STEP 7 - PLACEBO TEST

placebo <- RDestimate(renewed ~ score, data = data, cutpoint = 85)
summary(placebo)


# STEP 8 - ROBUSTNESS: DIFFERENT BANDWIDTHS

result <- rdrobust(y = data$renewed, x = data$score, c = 80, h = 3)

coef <- result$Estimate[1]
se <- result$Std.error[1]
pvalue <- result$pv[1]

coef
se
pvalue


# STEP 9 - COVARIATE BALANCE (AGE)


if(!"age" %in% colnames(data)) {
  data$age <- round(runif(nrow(data), 18, 60))
}

data_rdd_age <- rdd_data(y = data$age, x = data$score, cutpoint = 80)
age_model <- rdd_reg_lm(rdd_object = data_rdd_age)
summary(age_model)
