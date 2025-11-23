
# ESTIMATE WITH RDestimate

rd_model <- RDestimate(renewed ~ score, data = data, cutpoint = 80)
summary(rd_model)

# STEP 5  ESTIMATE WITH rdrobust

robust_model <- rdrobust(y = data$renewed, x = data$score, c = 80)
summary(robust_model)

# STEP 5  VISUALIZATION WITH rdplot
rdplot(y = data$renewed, x = data$score, c = 80,
       x.label = "Engagement Score", y.label = "Renewal Rate",
       title = "RDD: Effect of Discount on Renewal")
