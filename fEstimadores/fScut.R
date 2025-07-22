# fScut.R
# ---------------------------------------------------------
# Author: Rodrigo Lagos
# Date: 2024-09-09
#
# Purpose:
#   Computes a truncated-tail richness estimator (Scut) from a vector
#   of detection frequencies (vQ). Only properties mentioned by ≥5 participants
#   are included, excluding low-frequency features (Q1–Q4).
#
# Input:
#   vQ: A numeric vector where vQ[i] represents the number of features
#       mentioned by exactly i participants.
#
# Output:
#   Scut: Truncated richness estimate (sum of frequencies from Q5 onward)

fScut <- function(vQ) {
  # Remove missing values (just in case)
  vQ <- vQ[!is.na(vQ)]
  
  # Select values starting from index 5 (i.e., Q5 and beyond)
  vQcut <- vQ[5:length(vQ)]
  
  # Sum the frequencies of features mentioned by ≥5 participants
  Scut <- sum(vQcut)
  
  return(Scut)
}
