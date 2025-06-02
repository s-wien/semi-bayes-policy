#function to pool n estimates with their variances, and confidence value of zp 

pacman::p_load(here) #easy file referencing

# loading data
here::i_am("code/01-create-function.R")


#function to pool n estimates with their 95% confidence intervals

pool_estimates_ci <- function(betas, ci_lower, ci_upper) {
  #check if the input vectors have the same length
  if (length(betas) != length(ci_lower) || length(betas) != length(ci_upper)) {
    stop("The lengths of the estimates, lower CI, and upper CI vectors must be equal.")
  }
  
  #step 1: calculate the standard errors from the confidence intervals
  Z_alpha <- 1.96  # 95% confidence limits
  
  #calculate standard errors from the CIs
  standard_errors <- (ci_upper - ci_lower) / (2 * Z_alpha)
  
  #step 2: calculate the variances from the standard errors
  variances <- standard_errors^2
  
  #step 3: calculate the pooled estimate using inverse variance weighting
  weighted_betas <- sum(betas / variances)
  weights_sum <- sum(1 / variances)
  pooled_beta <- weighted_betas / weights_sum
  
  #step 4: calculate the pooled variance
  pooled_variance <- 1 / weights_sum
  
  #calculate the pooled standard error (square root of the pooled variance)
  pooled_se <- sqrt(pooled_variance)
  
  #step 5: calculate the pooled 95% Confidence Interval
  pooled_ci_lower <- pooled_beta - Z_alpha * pooled_se
  pooled_ci_upper <- pooled_beta + Z_alpha * pooled_se
  
  #return the pooled estimate, pooled variance, and pooled standard error
  return(list(pooled_beta = pooled_beta, pooled_variance = pooled_variance, 
              pooled_se = pooled_se, pooled_ci_lower = pooled_ci_lower, 
              pooled_ci_upper = pooled_ci_upper))
  
}


