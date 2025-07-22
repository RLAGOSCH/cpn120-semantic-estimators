# Optimized for macOS systems
# Main simulation script for estimating semantic richness
# Author: Rodrigo Lagos

# ========== Setup ==========
rm(list = ls())  # Clear environment
set.seed(1808265)  # For reproducibility

# Load required libraries
library(doParallel)
library(foreach)
library(iterators)
library(tidyr)
library(dplyr)

# Detect available cores and setup parallel backend (keep 1 free)
numCores <- detectCores() - 1
cl <- makeCluster(numCores)
registerDoParallel(cl)

# ========== Parameters (editable by user) ==========
B <- 10                      # Number of resamples per condition
vT <- c(10, 50, 100)         # Sample sizes to test

# ========== Load data and functions ==========
source("fEstimadores/fEstimadores.R")
source("fEstimadores/fGetQ.R")

listMtI <- readRDS(file = "data_input/listMiCPN120.RDS")

# Load selected concepts and categories from output of previous script
listConceptosSeleccionados <- readRDS("results/listConceptosSelecionados.RDS")

# Convert to a data.frame for easier processing
dfCategorias <- bind_rows(
  data.frame(Concepto = listConceptosSeleccionados$concrete, Categoria = "Concretos"),
  data.frame(Concepto = listConceptosSeleccionados$abstract, Categoria = "Abstractos")
)

# ========== Input validation ==========
conceptos_disponibles <- names(listMtI)
for (i in seq_len(nrow(dfCategorias))) {
  concepto <- dfCategorias$Concepto[i]
  categoria <- dfCategorias$Categoria[i]
  if (!(concepto %in% conceptos_disponibles)) stop(paste("Concept not found:", concepto))
  if (!(categoria %in% c("Concretos", "Abstractos"))) stop(paste("Invalid category:", categoria))
}

# ========== Helper functions ==========
select_concept_matrix <- function(concepto) {
  matrix <- listMtI[[concepto]]
  if (is.null(matrix)) stop("Matrix not found for concept: ", concepto)
  return(matrix)
}

# Modified fResample for Model A: resampling 
fResample <- function(n, mtI, nTpobla) {
  mtSample <- mtI[, sample(x = 1:nTpobla, size = n, replace = TRUE)]
  mtSample <- mtSample[rowSums(mtSample) > 0, , drop = FALSE]
  return(list2DF(fEstimadores(mtSample)))
}

# ========== Export to workers ==========
clusterExport(cl, varlist = c("listMtI", "select_concept_matrix", "fResample", "fEstimadores", "fGetQ"))

# ========== Simulation loop ==========
df_final <- data.frame()

for (i in seq_len(nrow(dfCategorias))) {
  concepto <- dfCategorias$Concepto[i]
  categoria <- dfCategorias$Categoria[i]
  mtI <- select_concept_matrix(concepto)
  nTpobla <- ncol(mtI)
  vQpobla <- fGetQ(mtI)
  Upobla <- sum(mtI)
  
  df_concepto <- foreach(n = rep(vT, each = B), .combine = rbind,
                         .packages = c("dplyr", "tidyr")) %dopar% {
                           res <- fResample(n, mtI, nTpobla)
                           res$Tamaño <- n
                           res$Concepto <- concepto
                           res$Categoria <- categoria
                           res
                         }
  
  df_final <- bind_rows(df_final, df_concepto)
}

# ========== Output ==========
stopCluster(cl)


saveRDS(df_final, file = "results/SimulacionA_test.RDS")
