# Install the packages (if not already installed)
install.packages(c("rdd", "rdrobust", "rddensity", "ggplot2"))

# Load the packages
library(rdd)
library(rddtools)
library(rdrobust)
library(rddensity)
library(ggplot2)
library(dplyr)

# ----------------------------------------------------
# STEP 1 - DEFINE CUTOFF AND SIMULATE DATA
# ----------------------------------------------------

set.seed(123)

n <- 1000
cutoff <- 80

score <- runif(n, 50, 100)
treatment <- ifelse(score >= cutoff, 1, 0)

renewal_prob <- 0.2 + 0.25 * treatment + 0.01 * (score - cutoff)
renewed <- rbinom(n, 1, plogis(renewal_prob))

data <- data.frame(score, treatment, renewed)

# -----------------------------
# STEP 2 - VISUAL EXPLORATION
# -----------------------------

# Number of bins
n_bins <- 20

# Create manual bins
data_binned <- data %>%
  mutate(bin = cut(score, breaks = n_bins)) %>%
  group_by(bin) %>%
  summarise(score_mean = mean(score),
            renewed_mean = mean(renewed),
            treatment = mean(treatment))

# Plot with midpoints and separate regressions
ggplot(data_binned, aes(x = score_mean, y = renewed_mean)) +
  geom_point(aes(color = as.factor(treatment)), size = 2) +
  geom_smooth(method = "lm", se = FALSE,
              aes(color = as.factor(treatment), group = as.factor(treatment))) +
  geom_vline(xintercept = cutoff, linetype = "dashed") +
  labs(title = "RDD with Bin Means",
       x = "Engagement Score (bin average)",
       y = "Renewal Rate (bin average)",
       color = "Treatment")

# Ensure narrower bins or aligned with the cutoff
cut(score, breaks = seq(50, 100, by = 2))  # example: bins of width 2


# -----------------------------
# STEP 3 - ESTIMATE WITH RDestimate
# -----------------------------
rd_model <- RDestimate(renewed ~ score, data = data, cutpoint = cutoff)
summary(rd_model)

# -----------------------------
# STEP 4 - ESTIMATE WITH rdrobust (more robust)
# -----------------------------
robust_model <- rdrobust(y = data$renewed, x = data$score, c = cutoff)
summary(robust_model)

# -----------------------------
# STEP 5 - VISUALIZATION WITH rdplot
# -----------------------------
rdplot(y = data$renewed, x = data$score, c = cutoff,
       x.label = "Engagement Score", y.label = "Renewal Rate",
       title = "RDD: Effect of Discount on Renewal")

# -----------------------------
# STEP 6 - MANIPULATION TEST (McCrary)
# -----------------------------
density <- rddensity(data$score, c = cutoff)
summary(density)

# -----------------------------
# STEP 7 - PLACEBO TEST
# -----------------------------
placebo <- RDestimate(renewed ~ score, data = data, cutpoint = 85)
summary(placebo)

# -----------------------------
# STEP 8 - ROBUSTNESS: DIFFERENT BANDWIDTHS
# -----------------------------
result <- rdrobust(y = data$renewed, x = data$score, c = cutoff, h = 3)

# Treatment effect estimate
coef <- result$Estimate[1]

# Standard error
se <- result$Std.error[1]

# p-value
pvalue <- result$pv[1]

coef
se
pvalue

# -----------------------------
# STEP 9 - COVARIATE BALANCE (AGE)
# -----------------------------
data$age <- round(runif(n, 18, 60))

# Create RDD object for age variable
data_rdd_age <- rdd_data(y = data$age, x = data$score, cutpoint = cutoff)

# Estimate linear RDD model for age
age_model <- rdd_reg_lm(rdd_object = data_rdd_age)

# Show model summary
summary(age_model)


