# 00-select_concepts.R
# -------------------------------------------------------
# Author: Rodrigo Lagos
# Date: 2024-09-10
#
# Description:
# Selects representative concepts (1 low, 1 central, 1 high)
# from CPN120 using multidimensional scaling on 
# Wasserstein distances between feature distributions.
#
# Categories: Concrete (C) and Abstract (A)
#
# Output:
#   vConcretos   - vector of 3 concrete concepts
#   vAbstractos  - vector of 3 abstract concepts
#
# Requires:
#   - "dataFrameCPN120.RDS" in data_input/
#   - transport package (for wasserstein1d)

# -------------------------------------------------------
# Load libraries and data
# -------------------------------------------------------
library(transport)
library(readxl)

# Clean environment
rm(list = ls())

# Load the full CPN120 data
dfCPN120 <- readRDS(file = "data_input/dataFrameCPN120.RDS")

# -------------------------------------------------------
# Split by category
# -------------------------------------------------------
dfConcretos  <- dfCPN120[dfCPN120$Categoria == "C", ]
dfAbstractos <- dfCPN120[dfCPN120$Categoria == "A", ]

# Reset row indices
row.names(dfConcretos)  <- NULL
row.names(dfAbstractos) <- NULL

# Remove full object
rm(dfCPN120)

# -------------------------------------------------------
# Identify unique concepts
# -------------------------------------------------------
vCon_concreto  <- unique(dfConcretos$Concepto)
vCon_abstracto <- unique(dfAbstractos$Concepto)

# Create empty distance matrices
mtDis_concreto  <- matrix(NA, nrow = length(vCon_concreto),  ncol = length(vCon_concreto))
mtDis_abstracto <- matrix(NA, nrow = length(vCon_abstracto), ncol = length(vCon_abstracto))

rownames(mtDis_concreto)  <- vCon_concreto
colnames(mtDis_concreto)  <- vCon_concreto
rownames(mtDis_abstracto) <- vCon_abstracto
colnames(mtDis_abstracto) <- vCon_abstracto

# -------------------------------------------------------
# Compute pairwise Wasserstein distances
# -------------------------------------------------------

# Concrete
for (r in 1:length(vCon_concreto)) {
  for (c in r:length(vCon_concreto)) {
    dfR <- dfConcretos[dfConcretos$Concepto == vCon_concreto[r], ]
    dfC <- dfConcretos[dfConcretos$Concepto == vCon_concreto[c], ]
    mtDis_concreto[r, c] <- wasserstein1d(a = dfR$Order, b = dfC$Order, wa = dfR$lamnda, wb = dfC$lamnda)
  }
}

# Abstract
for (r in 1:length(vCon_abstracto)) {
  for (c in r:length(vCon_abstracto)) {
    dfR <- dfAbstractos[dfAbstractos$Concepto == vCon_abstracto[r], ]
    dfC <- dfAbstractos[dfAbstractos$Concepto == vCon_abstracto[c], ]
    mtDis_abstracto[r, c] <- wasserstein1d(a = dfR$Order, b = dfC$Order, wa = dfR$lamnda, wb = dfC$lamnda)
  }
}

# Clean temporary variables
rm(dfR, dfC)

# Make matrices symmetric
mtDis_concreto[is.na(mtDis_concreto)]   <- 0
mtDis_abstracto[is.na(mtDis_abstracto)] <- 0

mtDis_concreto  <- mtDis_concreto + t(mtDis_concreto)
mtDis_abstracto <- mtDis_abstracto + t(mtDis_abstracto)

# -------------------------------------------------------
# Multidimensional scaling (1D projection)
# -------------------------------------------------------
cmd_concreto  <- cmdscale(mtDis_concreto,  eig = TRUE, k = 1)
cmd_abstracto <- cmdscale(mtDis_abstracto, eig = TRUE, k = 1)

dfConcretoInfo  <- as.data.frame(cmd_concreto[["points"]])
dfAbstractoInfo <- as.data.frame(cmd_abstracto[["points"]])

dfConcretoInfo$Concepto  <- rownames(dfConcretoInfo)
dfAbstractoInfo$Concepto <- rownames(dfAbstractoInfo)

colnames(dfConcretoInfo)  <- c("X", "Concepto")
colnames(dfAbstractoInfo) <- c("X", "Concepto")

rownames(dfConcretoInfo)  <- NULL
rownames(dfAbstractoInfo) <- NULL

# -------------------------------------------------------
# Merge with observed richness S
# -------------------------------------------------------
dfConcretoInfo <- merge(dfConcretoInfo,  unique(dfConcretos[, c("Concepto", "S")]),  by = "Concepto")
dfAbstractoInfo <- merge(dfAbstractoInfo, unique(dfAbstractos[, c("Concepto", "S")]), by = "Concepto")

# -------------------------------------------------------
# Select representative concepts: max, median, min
# -------------------------------------------------------

# Utility: find closest value to median
valor_centro <- function(vector) {
  med <- median(vector)
  return(vector[which.min(abs(vector - med))])
}

# Select 3 concrete concepts
vConcretos <- c(
  dfConcretoInfo$Concepto[dfConcretoInfo$X == max(dfConcretoInfo$X)],
  dfConcretoInfo$Concepto[dfConcretoInfo$X == valor_centro(dfConcretoInfo$X)],
  dfConcretoInfo$Concepto[dfConcretoInfo$X == min(dfConcretoInfo$X)]
)

# Select 3 abstract concepts
vAbstractos <- c(
  dfAbstractoInfo$Concepto[dfAbstractoInfo$X == max(dfAbstractoInfo$X)],
  dfAbstractoInfo$Concepto[dfAbstractoInfo$X == valor_centro(dfAbstractoInfo$X)],
  dfAbstractoInfo$Concepto[dfAbstractoInfo$X == min(dfAbstractoInfo$X)]
)

# -------------------------------------------------------
# Output
# -------------------------------------------------------
cat("Concrete concepts:\n");   print(vConcretos)
cat("\nAbstract concepts:\n"); print(vAbstractos)

# Optionally save
saveRDS(object = list(concrete = vConcretos, abstract = vAbstractos),
        file   = "results/listConceptosSelecionados.RDS")
