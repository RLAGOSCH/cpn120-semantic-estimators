# data_input/

This folder contains lightweight input data necessary to reproduce the simulation and analysis of semantic richness estimators in CPN120.

## Included files

- `listMiCPN120.RDS`: A list of empirical incidence matrices (`λ`) for each concept in the CPN120 dataset. Used for theoretical calculations and simulations.
- `df30CPN120_A.RDS`: Subset of simulation results for T = 30 using **Simulation Method A**. Useful for generating figures and summaries without re-running the full simulation.
- `df30CPN120_B.RDS`: Subset of simulation results for T = 30 using **Simulation Method B**.
- `dataFrameCPN120.RDS`: A long-format dataframe containing the raw CPN120 property norms. Each row corresponds to a concept–feature pair with the following columns:

  | Column      | Description                                 |
  |-------------|---------------------------------------------|
  | `Concepto`  | Target concept name                         |
  | `lamnda`    | Detection probability (feature prevalence)  |
  | `Order`     | Order/rank of the feature within the concept|
  | `feature`   | Semantic property listed by participants    |
  | `Frecuencia`| Number of times the feature was mentioned   |
  | `S`         | Number of unique properties per concept     |
  | `Sujetos`   | Number of participants per concept          |
  | `Categoria` | Category label for stratification purposes  |

## Not included

- Full simulation outputs (e.g., `Simulacion_A.RDS`, `Simulacion_B.RDS`) due to file size.  
  These can be regenerated using the scripts in `/scripts/` or requested via email.
