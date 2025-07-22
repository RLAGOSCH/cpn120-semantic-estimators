SIMULATION/ — SEMANTIC RICHNESS ESTIMATION SCRIPTS
---------------------------------------------------

This folder contains scripts for simulating semantic richness estimation from Conceptual Property Norm (CPN) data using two different sampling mechanisms. The simulations are optimized for macOS systems and intended for academic research purposes.

CONTENTS
--------

00-select_concepts.R
    Script for selecting the concepts to be simulated.
    Generates a list object (listConceptosSeleccionados) containing selected
    concrete and abstract concepts. This file must be run first.

01-simulate_methodA.R
    Main simulation script using Mechanism A (resampling real participants
    from the empirical incidence matrix).

02-simulate-mehodB.R
    Main simulation script using Mechanism B (generating synthetic participants
    based on property-level detectability, i.e., lambda parameters).


PARAMETERS
----------

Both simulation scripts use the same default test parameters:

    B = 10                # Number of Monte Carlo replicates per sample size
    vT = c(10, 50, 100)   # Vector of sample sizes to be tested

These values are intended for quick testing and can be modified directly
within each script.


OUTPUT
------

All simulation results are saved in the 'results/' directory in .RDS format:

    SimulacionA_test.RDS     -> Output from 01-simulate_methodA.R
    SimulacionB_test.RDS     -> Output from 02-simulate-mehodB.R


NOTES
-----

- The simulations rely on the following inputs:
    - A list of incidence matrices: data_input/listMiCPN120.RDS
    - A list of selected concepts: results/listConceptosSeleccionados.rds

- The scripts support parallel processing via the 'doParallel' and 'foreach' packages.

- Ensure the following folders exist and are properly populated:
    - fEstimadores/
    - data_input/
    - results/

