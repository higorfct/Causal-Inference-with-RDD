
# STEP 3 - VISUAL EXPLORATION
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
