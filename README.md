# valid-p-values
Obtain valid p-values for single molecule microscopy.

This repository contains code implementing methods described in the following publication:
"Don’t Be Fooled by Randomness: Valid p-Values for Single Molecule Microscopy" [1]. Please cite the corresponding paper if you use code from this repository.

The repository contains the following folders:
- 2CLASTA: MATLAB implementation of the 2-CLASTA method [2], which allows to calculate a p-value based on 2-color SMLM localization maps. The null hypothesis is a random distribution of biomolecules.
- MultiplePvalues: Code to calculate an overall p-value for multiple experiments. Example data is taken from [2].
- PermutationTests: Code to perform a standard and block permutation test. The block permutation test allows to account for the correlation present in single molecule trajectory data. Example data is taken from [4].


Further software
----------------
- An implementation of the 2-CLASTA method [2] as an ImageJ plugin can be found in the following repository: https://github.com/schuetzgroup/2-CLASTA
- The software package for simulation of FRET trajectories [3] can be found in the following repository: https://github.com/schuetzgroup/fret-tester


References
----------
<a name="Schneider2022"></a>[1] Schneider, Magdalena C.; Schütz, Gerhard J. (2022):
  “Don’t Be Fooled by Randomness: Valid p-Values for Single Molecule Microscopy.”
  In: Frontiers in Bioinformatics, 2 (2022).
  Available at: [DOI: 10.3389/fbinf.2022.811053](https://doi.org/10.3389/fbinf.2022.811053)
  
<a name="Arnold2020"></a>[2] Arnold, Andreas M.; Schneider, Magdalena C.; et al. (2020):
  “Verifying Molecular Clusters by 2-color Localization Microscopy and Significance Testing.”
  In: Scientific Reports, 10:4230 (2020).
  Available at: [DOI: 10.1038/s41598-020-60976-6](https://doi.org/10.1038/s41598-020-60976-6)

<a name="Schrangl2018"></a>[3] Schrangl, Lukas; Göhring, Janett; Schütz, Gerhard J. (2018):
  “Kinetic analysis of single molecule FRET transitions without trajectories.”
  In: The Journal of Chemical Physics, 148 (2018), H. 12, p. 123328.
  Available at: [DOI: 10.1063/1.5006038](https://doi.org/10.1063/1.5006038)

<a name="Goehring2021"></a>[4] Göhring, Janett; et al. (2021):
  “Temporal Analysis of T-Cell Receptor-Imposed Forces via Quantitative Single Molecule FRET Measurements.”
  In: Nature Communications, 12:2502 (2021).
  Available at: [DOI: 10.1038/s41467-021-22775-z](https://doi.org/10.1038/s41467-021-22775-z)
