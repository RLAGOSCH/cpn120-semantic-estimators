# fShat.R
# ---------------------------------------------------------
# Author: Rodrigo Lagos
# Created: 2024-06-27
# Major update: 2024-09-09
#
# Purpose:
#   Estimate the total number of semantic features (S) using the Schao2 formula,
#   originally developed for species richness estimation. This version includes
#   point estimation, variance, and a log-normal confidence interval.
#
# Input:
#   vQ: A numeric vector where vQ[i] is the number of features mentioned by exactly i participants.
#
# Output:
#   A named list with the following elements:
#     - Shat:      Schao2 estimate of S
#     - varShat:   Estimated variance of Shat
#     - ClowShat:  Lower bound of the 95% confidence interval
#     - CupShat:   Upper bound of the 95% confidence interval

fShat <- function(vQ) {
  # Observed richness: number of unique features
  S0 <- sum(vQ)
  
  # Total number of participants (maximum possible detection count)
  nT <- length(vQ)
  
  # Correction factor A = (T - 1) / T
  A <- (nT - 1) / nT
  
  # Estimate Q0 (unseen richness) and variance depending on Q2 > 0
  if (vQ[2] > 0) {
    # Case 1: Standard Chao2 formula when Q2 > 0
    Q0hat <- A * (vQ[1]^2) / (2 * vQ[2])
    Shat <- S0 + Q0hat
    
    # Intermediate ratio Q1/Q2
    Q1_2 <- vQ[1] / vQ[2]
    
    # Variance estimator (Chao 1987 formula)
    varShat <- vQ[2] * (
      (A / 2)    * Q1_2^2 +
        A^2       * Q1_2^3 +
        (A^2 / 4) * Q1_2^4
    )
    
  } else {
    # Case 2: Adjusted formula when Q2 = 0 (rare-event correction)
    Q0hat <- A * vQ[1] * (vQ[1] - 1) / 2
    Shat  <- S0 + Q0hat
    
    varShat <- A    * vQ[1] * (vQ[1] - 1) / 2 +
      A^2  * vQ[1] * (2 * vQ[1] - 1)^2 / 4 -
      A^2  * vQ[1]^4 / (4 * Shat)
  }
  
  # Remove any names (safety)
  varShat <- unname(varShat)
  Shat    <- unname(Shat)
  
  # Confidence Interval using log-normal approximation (Canessa et al., 2020)
  # D is the log-normal scaling factor
  D <- exp(1.96 * sqrt(log(1 + varShat / (Shat - S0)^2)))
  
  # Lower and upper limits
  Clow <- S0 + (Shat - S0) / D
  Cup  <- S0 + (Shat - S0) * D
  
  # Handle degenerate cases: if variance or Q0hat is zero
  if (varShat == 0 || (Shat - S0) == 0) {
    Clow <- S0
    Cup  <- S0
  }
  
  # Return results as a named list
  return(list(
    Shat     = Shat,
    varShat  = varShat,
    ClowShat = Clow,
    CupShat  = Cup
  ))
}
