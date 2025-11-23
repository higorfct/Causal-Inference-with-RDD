
#  ROBUSTNESS: DIFFERENT BANDWIDTHS

result <- rdrobust(y = data$renewed, x = data$score, c = 80, h = 3)

coef <- result$Estimate[1]
se <- result$Std.error[1]
pvalue <- result$pv[1]

coef
se
pvalue
