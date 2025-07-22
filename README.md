# Semantic Richness Estimation in Free Generation Tasks (CPN120 Simulation)

This repository accompanies the analyses from the manuscript  
"You Can’t Just Count: A Statistical Rethinking of Semantic Richness in Free Generation Tasks and Semantic Norms".

## Overview

This version focuses exclusively on the CPN120 dataset, a large-scale set of Conceptual Property Norms (CPNs) collected in Chile using a free-generation task. However, the analysis pipeline and codebase are fully extensible to other datasets (e.g., CPN27, CSLB, Brazilian fluency norms).

The simulations evaluate the statistical properties of semantic richness estimators — Sobs, Scut, Schao2, and Schao2BC — under two generative mechanisms (Method A and Method B). Metrics include bias, mean squared error (MSE), confidence interval coverage, and variance estimation accuracy.

## Repository Structure

- `data_input/`: Raw and simulated data (not versioned due to file size)
- `fEstimadores/`: Core estimators (Schao2, Schao2BC, Scut, etc.)
- `funciones_miselaneas/`: Auxiliary functions (e.g., Q-vector processing)
- `scripts/`: Simulation scripts (Method A and B)
- `analisis_final/`: Modular Quarto pipeline for generating figures and statistics
- `informe_CPN120_V1.qmd`: Main analysis file (Quarto)
- `results/` and `figures/`: Output from simulation and visualization steps

## How to Use

1. Download the `.RDS` simulation files externally and place them in `data_input/`.
2. Source all required functions from the `fEstimadores/` and `funciones_miselaneas/` folders.
3. Run or render `informe_CPN120_V1.qmd` using Quarto.

> Note: Due to file size constraints, simulation data is not included in this repository. You may regenerate it via the scripts in `/scripts`, or request the original files.

## Requirements

- R (≥ 4.0.0)
- Suggested packages: `ggplot2`, `dplyr`, `patchwork`, `readr`, `tidyr`, `purrr`, `gtsummary`, `scales`, `tibble`

All required packages are loaded via `00-librerias_y_funciones.R`.

## License

This project is licensed under the MIT License. See the LICENSE file for details.


