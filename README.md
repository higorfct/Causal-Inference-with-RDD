
#  RDD Analysis to Evaluate the Effect of a Discount on Renewal Rate

## Context
An automotive parts and insurance sales company wants to understand whether offering an automatic discount to customers with an engagement score equal to or greater than 80 increases the probability of renewing the contract/service.

## Business Problem
Does granting a discount, offered only to customers with an engagement score above a certain threshold (80), positively impact the renewal rate?

## Analysis Objective
Evaluate whether there is a jump (discontinuity) in the renewal rate at the score cutoff (80), suggesting a causal effect of the discount on renewal, using the Regression Discontinuity Design (RDD) methodology.

## Methodological Justification
The company did not randomize who received the discount but used an objective eligibility rule (score ≥ 80). This allows applying RDD to estimate the local treatment effect by comparing individuals just above and below the cutoff, attempting to simulate a randomized controlled trial with treated and untreated groups.

---

## Analysis Steps

### 1. Definition of the cutoff and data simulation
- Cutoff point set at an engagement score of 80.  
- 1000 observations simulated with a binary treatment (received discount if score ≥ 80).  
- Response variable `renewed` generated probabilistically as a function of treatment and score, simulating a baseline rate and a treatment effect.

### 2. Visual Exploration
- Data grouped into bins for visualization.  
- Plot created showing average renewal rate per bin, separating treated and untreated groups.  
- Possible discontinuity around cutoff 80 observed, suggesting a discount effect.

<img width="862" height="420" alt="image" src="https://github.com/user-attachments/assets/f3bb1e8b-8243-4940-a4c0-07bbcd6b7225" />


### 3. Effect Estimation via `RDestimate`
- `rdd` package used to estimate the local treatment effect.  
- Average increase in renewal rate between 19% to 31%, depending on the selected bandwidth.  
- P-values above 0.10 indicate inability to reject the null hypothesis at 5% significance.

### 4. Estimation with `rdrobust` (more robust method)
- Local polynomial adjustment with heteroskedasticity correction performed.  
- Estimated coefficient: ~18.6% increase in renewal rate.  
- Associated p-value (0.22) confirms lack of statistical significance at 5%.

### 5. Detailed Visualization with `rdplot`
- Visual confirmation of jump in outcome variable at cutoff.  
- Pattern consistent with hypothesis of a positive treatment effect (considering economic significance over statistical significance).

<img width="862" height="420" alt="image" src="https://github.com/user-attachments/assets/59ec36fc-e315-4b63-bc03-a6952337aede" />


### 6. Manipulation Test (McCrary)
- Density test around cutoff shows no score manipulation.  
- Supports validity of RDD design.

### 7. Placebo Test
- Fictitious cutoff at 85 tested; no effect expected.  
- No significant discontinuity observed, supporting original design validity.

### 8. Robustness with Different Bandwidths
- Adjustments with smaller bandwidths performed.  
- Estimated effects remained positive, without strong statistical significance.

### 9. Covariate Balancing (e.g., age)
- Checked other covariates for discontinuity at cutoff.  
- No significant difference observed, indicating balance and reinforcing RDD validity.

---

## Insights and Interpretation

- **Estimated effect:** Discount at cutoff 80 increases renewal rate by ~18–30%, relevant economically.  
- **Statistical significance:** Effect not significant at 5%, p-values generally >0.10.  
- **Economic significance:** Despite lack of statistical significance, effect size is practically relevant and may justify policy continuation or further data collection.  
- **Design validity:** Manipulation and placebo tests confirm RDD is appropriate and reliable.

---

## Conclusion
RDD methodology applied to evaluate treatment impact at cutoff. Results show relevant economic effect despite lack of strong statistical significance. Design is valid; for real-world studies, larger samples or complementary approaches recommended for firmer conclusions.

---

## Packages Used
- `rdd` and `rddtools` – classical RDD analysis  
- `rdrobust` – robust estimation and inference  
- `rddensity` – manipulation tests  
- `ggplot2` and `dplyr` – data visualization and manipulation

---

## Reference Code
[Full code for simulation, estimation, visualization, and tests is available in the project script.]

---

## THE END

---

