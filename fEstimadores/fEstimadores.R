# fEstimadores.R
# ---------------------------------------------------------
# Main wrapper function to compute semantic richness estimators
# from a detection frequency vector (vQ) in a free-generation task.
#
# Estimators:
#   - Sobs: Observed richness (number of non-zero features)
#   - Scut: Truncated richness (sum of features mentioned by ≥5 participants)
#   - Schao2: Nonparametric estimator based on Q1 and Q2
#   - Schao2BC: Bias-corrected version of Schao2
#
# Outputs:
#   - Q1 to Q4: Rare-feature counts
#   - nT: Number of participants (max value in vQ)
#   - U: Total number of responses (sum of vQ)
#   - Point estimates, variances, and confidence intervals
#
# Dependencies:
#   - fGetQ()
#   - fShat()
#   - fShat_bc()
#   - fScut()

## Function fEstimadores
#' Author: Rodrigo Lagos
# Date: 08-09-2024
#
# Computes several richness estimators (Scut, Shat, Shat_BC) based on a detection frequency vector (vQ)
# or an incidence matrix. Also returns variances and confidence intervals for the estimators,
# as well as basic properties of the input data.
#
# Input:
#   X : Either a detection frequency vector (vQ) or an incidence matrix (mtI)
#
# Output:
#   A list containing:
#     - S0: Observed richness
#     - Scut: Cutoff richness estimator
#     - Q1–Q4: First four values of the Q vector
#     - nT: Total number of traps / participants
#     - U: Total number of detected features
#     - Shat: Chao2 richness estimator
#     - varShat: Variance of Shat
#     - ClowShat, CupShat: Confidence interval bounds for Shat
#     - Shat_BC: Bias-corrected Chao2 estimator
#     - varShat_BC: Variance of Shat_BC
#     - ClowShat_BC, CupShat_BC: Confidence interval bounds for Shat_BC
#     - Largo: Dimensions of the incidence matrix (only if X is a matrix)

fEstimadores <- function(X) {
  # Load required functions
  source("fEstimadores/fScut.R")
  source("fEstimadores/fShat.R")
  source("fEstimadores/fShat_bc.R")
  source("fEstimadores/fGetQ.R")

  
  # Determine input type and extract Q vector
  if (is.matrix(X)) {
    mtI <- X
    vQ  <- fGetQ(mtI)
    nT  <- dim(mtI)[2]
  }
  
  if (is.vector(X)) {
    vQ <- X
    nT <- length(vQ)
  }
  
  # Compute observed richness and total number of detections
  S0 <- sum(vQ)
  U  <- sum(vQ * 1:nT)
  
  # Compute estimators
  Scut        <- fScut(vQ)           # Cutoff richness estimator
  lstShat     <- fShat(vQ)           # Chao2 estimator and its variance / CI
  lstShat_BC  <- fShat_bc(vQ)        # Bias-corrected Chao2 and its variance / CI
  
  # Build result list
  lstEstimadores <- list(
    S0        = S0,
    Scut      = Scut,
    Q1        = vQ[1],
    Q2        = vQ[2],
    Q3        = vQ[3],
    Q4        = vQ[4],
    nT        = nT,
    U         = U,
    Shat      = lstShat$Shat,
    varShat   = lstShat$varShat,
    ClowShat  = lstShat$ClowShat,
    CupShat   = lstShat$CupShat,
    Shat_BC     = lstShat_BC$Shat_BC,
    varShat_BC  = lstShat_BC$varShat_BC,
    ClowShat_BC = lstShat_BC$Clow_BC,
    CupShat_BC  = lstShat_BC$Cup_BC
  )
  

  return(lstEstimadores)
}
