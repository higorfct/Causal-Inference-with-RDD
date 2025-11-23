
#  COVARIATE BALANCE (AGE)

# If the age column does not exist, create it
if(!"age" %in% colnames(data)) {
  data$age <- round(runif(nrow(data), 18, 60))
}

data_rdd_age <- rdd_data(y = data$age, x = data$score, cutpoint = 80)
age_model <- rdd_reg_lm(rdd_object = data_rdd_age)
summary(age_model)
