
# MANIPULATION TEST (McCrary)

density <- rddensity(data$score, c = 80)
summary(density)


#  PLACEBO TEST

placebo <- RDestimate(renewed ~ score, data = data, cutpoint = 85)
summary(placebo)
