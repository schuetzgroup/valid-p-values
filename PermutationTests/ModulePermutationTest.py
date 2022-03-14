"""Module for permutation tests"""
# Author: Magdalena Schneider
# Affiliation: Institute of Applied Physics, TU Wien
# Date: 15/10/2021

import numpy as np
import random
import matplotlib.pyplot as plt

class PermutationTest:
    def __init__(self, data1, data2, nPermutations=1000, side='both', modus='normal', alpha=0.05):
        self._nPermutations = nPermutations
        self._side = side
        self._modus = modus # 'standard' or 'block'
        self._alpha = alpha
        self.pvalue, self.testDecision = self._performPermutationTest(data1, data2)
        
    def _performPermutationTest(self, data1, data2, doPlot=False):
        testStats = np.zeros(self._nPermutations)
        n1, n2, n = getDataSizes(data1, data2)
        
        if self._modus=='standard':
            testStats[0] = testStatistics(data1, data2)
            dataCombined = np.concatenate([data1, data2])
            for k in range(1,self._nPermutations):
                permutedSample = np.random.permutation(dataCombined)
                testStats[k] = testStatistics(permutedSample[:n1], permutedSample[n1:])
        
        if self._modus=='block':
            testStats[0] = testStatistics(np.concatenate(data1), np.concatenate(data2))
            dataCombined = data1 + data2
            for k in range(1,self._nPermutations):
                permutedSample = random.sample(dataCombined, n)
                testStats[k] = testStatistics(np.concatenate(permutedSample[:n1]), np.concatenate(permutedSample[n1:]))
        
        pvalue = self.getPvalue(testStats)
        testDecision = self.getTestDecision(pvalue)
        if doPlot:
            plotTestStatistics(testStats)
        return pvalue, testDecision
    
    def getPvalue(self, testStats, originalDataIndex=0):
        if self._side=='left':
            pvalue = sum(testStats[originalDataIndex] >= testStats) / len(testStats)
        if self._side=='right':
            pvalue = sum(testStats[originalDataIndex] <= testStats) / len(testStats)
        if self._side=='both':
            pvalue = sum(abs(testStats[0]) <= abs(testStats)) / len(testStats)
        return pvalue
    
    def getTestDecision(self, pvalue, alpha=0.05):
        return (pvalue <= alpha)

def getDataSizes(data1, data2):
        n1 = len(data1)
        n2 = len(data2)
        n = n1 + n2
        return n1, n2, n

def testStatistics(data1, data2, method='mean'):
    if method=='mean':
        testStat = data2.mean() - data1.mean()
    return testStat

def plotTestStatistics(testStats, originalDataIndex=0):
    plt.figure()
    plt.hist(testStats[0:originalDataIndex, originalDataIndex+1:])
    plt.vlines(testStats[originalDataIndex],0,10)
