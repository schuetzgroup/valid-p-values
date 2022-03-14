function pOverall = pValueMultipleExperiments(pvalues,threshold)
    
    numberExperiments = numel(pvalues);
    numberBelowThreshold = sum(pvalues<=threshold);
    
    % Binomial test
    pOverall = 1 - binocdf(numberBelowThreshold-1, numberExperiments, threshold);
end