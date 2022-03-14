% Calculate overall p-value for multiple experiments
%
% Date: 09/04/2021
% Author: Magdalena Schneider
% Affiliation: Institute of Applied Physics, TU Wien, Austria

%% Load data
data = importdata('data/pvals_1SNAP.dat');
pvalues = data.data;

%% Get overall p-value
threshold = 0.05;
pOverall = pValueMultipleExperiments(pvalues,threshold);

%% Show results
fprintf('Overall p-value = %f\n',pOverall)
figure
histogram(pvalues-0.00001,0:0.01:1)
xlabel('p-value','FontSize',14)
ylabel('Number','FontSize',14)
title(['p* = ',num2str(pOverall)],'FontSize',14)

