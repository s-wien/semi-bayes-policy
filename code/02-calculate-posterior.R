# loading data
here::i_am("code/02-calculate-posterior.R")

# source the function 
source("code/01-create-function.R")

# study estimate, policy decreases prenatal care (harmful)
# RD = -5
# 95% LCI = -7
# 95% UCI = -3

# policymaker A prior, policy increases prenatal care (protective)
# RD = 5
# 95% LCI = 3 
# 95% UCI = 7

# policymaker B prior, policy decreases prenatal care (harmful)
# RD = -6.2
# 95% LCI = -7.75
# 95% UCI = -4.65

# policymaker C prior, policy has no effect (null)
# RD = 0
# 95% LCI = -1 
# 95% UCI = 1

# policymaker D prior, policy could have a large chilling effect (harmful, large variance)
# RD = -11.5
# 95% LCI = -20
# 95% UCI = -3

#enter data, prior(s) and their 95% confidence intervals
betas_a <- c(5, -5)    #estimates
ci_lower_a <- c(3, -7) #lower bounds of CIs
ci_upper_a <- c(7, -3) #upper bounds of CIs

betas_b <- c(-6.2, -5)    #estimates
ci_lower_b <- c(-7.75, -7) #lower bounds of CIs
ci_upper_b <- c(-4.65, -3) #upper bounds of CIs

betas_c <- c(0, -5)    #estimates
ci_lower_c <- c(-1, -7) #lower bounds of CIs
ci_upper_c <- c(1, -3) #upper bounds of CIs

betas_d <- c(-11.5, -5)    #estimates
ci_lower_d <- c(-20, -7) #lower bounds of CIs
ci_upper_d <- c(-3, -3) #upper bounds of CIs


#call the function
result_a <- pool_estimates_ci(betas_a, ci_lower_a, ci_upper_a)
result_b <- pool_estimates_ci(betas_b, ci_lower_b, ci_upper_b)
result_c <- pool_estimates_ci(betas_c, ci_lower_c, ci_upper_c)
result_d <- pool_estimates_ci(betas_d, ci_lower_d, ci_upper_d)

#create data frame of results
data <- list(prior = c("policy_a", "policy_b", "policy_c", "policy_d"),
             prior_mean = c(5, -6.2, 0,  -11.5),
             prior_LCL =  c(3, -7.75, -1, -20),
             prior_UCL =  c(7, -4.65, -1, -3),
             posterior_mean = c(result_a$pooled_beta, result_b$pooled_beta, result_c$pooled_beta, result_d$pooled_beta),
             posterior_LCL = c(result_a$pooled_ci_lower, result_b$pooled_ci_lower, result_c$pooled_ci_lower, result_d$pooled_ci_lower),
             posterior_UCL = c(result_a$pooled_ci_upper, result_b$pooled_ci_upper, result_c$pooled_ci_upper, result_d$pooled_ci_upper))

data<- as.data.frame(data)

#export data frame
write.csv(data, "data/posteriors.csv")
