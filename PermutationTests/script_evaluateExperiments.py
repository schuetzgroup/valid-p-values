"""Script for evaluating experimental data with permutation tests"""
# Author: Magdalena Schneider
# Affiliation: Institute of Applied Physics, TU Wien
# Date: 15/10/2021

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from ModulePermutationTest import *


## Load data
type = 'fluid-phase' # 'gel-phase' or 'fluid-phase'
data_cells = pd.read_excel('data/'+type+'_synapse.xlsx')
data_noCells = pd.read_excel('data/'+type+'_noTcells.xlsx')

## Plot data
plt.figure()
plt.hist(data_cells['FRET eff'], bins = np.linspace(-0.5, 1.5, 51), label='inside synapse')
plt.hist(data_noCells['FRET eff'], bins = np.linspace(-0.5, 1.5, 51), label='no T-cells')
plt.xlabel('FRET efficiency')
plt.ylabel('Number')
plt.legend(frameon=False)

## Conduct permutation tests

# Standard permutation test
# (without considering trajectory IDs)
dataPoints_A = data_cells['FRET eff']
dataPoints_B = data_noCells['FRET eff']
testResultStandard = PermutationTest(dataPoints_A, dataPoints_B, nPermutations=1000, side='both', modus='standard', alpha=0.05)
print('Standard permutation test:\np-value = '+str(testResultStandard.pvalue)+'\n')

# Block permutation test
# (permute trajectories between the two different groups)
traj_A = data_cells.groupby('trajectory ID').agg({'FRET eff':lambda x: list(x)})
traj_A = traj_A['FRET eff'].tolist()
traj_B = data_noCells.groupby('trajectory ID').agg({'FRET eff':lambda x: list(x)})
traj_B = traj_B['FRET eff'].tolist()
testResultBlock = PermutationTest(traj_A, traj_B, nPermutations=1000, side='both', modus='block', alpha=0.05)
print('Block permutation test:\np-value = '+str(testResultBlock.pvalue))
