function [pvalue, cdfs] = pvalue2CLASTA(locs1, locs2, roi, par)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2-CLASTA method for calculating a p-value for the null hypothesis of a
    % random distribution of biomolecules
    %
    % Author: Magdalena Schneider
    % Affiliation: Institute of Applied Physics, TU Wien, Austria
    % Date: 19/01/2020
    %
    % Input:  locs1, locs2   ... positions of localizations for channel 1 and 2
    %         roi            ... x and y side lengths of region of interest
    %
    % Optional input: nControls      ... number of generated controls
    %                 rmax           ... for the test statistics the CDFs are integrated
    %                                    over the interval [0,rmax]
    %
    %
    % Output: pvalue ... p-value
    %         cdfs   ... cumulative distribution functions of cross-nearest
    %                    neighbor distances
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    arguments
        locs1 (:,2) double
        locs2 (:,2) double
        roi (1,2) double {mustBePositive}
        par.nControls (1,1) double {mustBeInteger} = 99;
        par.rmax (1,1) double {mustBePositive} = Inf;
    end
    
    shiftedLocs2 = toroidalShift(locs2, roi, par.nControls);
    nnDists = crossNearestNeighborDistances(locs1,shiftedLocs2);
    cdfs = createCdfs(nnDists);
    
    rmax = getRmax(nnDists, par.rmax);
    integrals = integrateCdfs(cdfs,rmax);
    pvalue = getPvalue(integrals);
end


%% Subfunctions 2-CLASTA
function shiftedLocs = toroidalShift(locs, roi, n)
    shiftVectors = [0 0; roi.*rand(n,2)];
    shiftedLocs = mod(repmat(locs,n+1,1) + repelem(shiftVectors,size(locs,1),1), roi);
    shiftedLocs = reshape(shiftedLocs,size(locs,1),2,n+1);
end

function nnDists = crossNearestNeighborDistances(locs1,locs2)
    [nLocs,~,nShifts] = size(locs2);
    [~,nnDists] = knnsearch(locs1,reshape(locs2,[],2));
    nnDists = reshape(nnDists, [nLocs, nShifts]);
end

function cdfs = createCdfs(data)
    n = size(data,2);
    cdfs.f = cell(n,1);
    cdfs.x = cell(n,1);
    for k = 1:n
        [cdfs.f{k},cdfs.x{k}] = ecdf(data(:,k));
        cdfs.x{k} = [0; cdfs.x{k}(2:end)];
        cdfs.f{k} = [0; cdfs.f{k}(2:end)];
    end
end

function rmax = getRmax(nnDists, rmax)
    maxDist = max(nnDists,[],'all');
    if rmax == Inf || rmax > maxDist
        rmax = maxDist;
    end
end

function integrals = integrateCdfs(cdfs,rmax)
    n = size(cdfs.x,1);
    integrals = NaN(n,1);
    for k = 1:n
        X = [cdfs.x{k}; rmax+1];
        Y = [cdfs.f{k}; 1];
        ymax = interp1(X,Y,rmax);
        X = [X(X<rmax); rmax];
        Y = [Y(X<rmax); ymax];
        integrals(k) = trapz(X,Y);
    end
end

function pvalue = getPvalue(integrals)
    pvalue = sum( integrals>=integrals(1))/size(integrals, 1 );
end
