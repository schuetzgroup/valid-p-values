% 2-CLASTA
%
% Date: 19/10/2021
% Author: Magdalena Schneider
% Affiliation: Institute of Applied Physics, TU Wien, Austria

%% Load data
type = 'monomers'; % 'monomers' or 'tetramers'
locs1 = readmatrix(['data/',type,'_channel1.csv']);
locs2 = readmatrix(['data/',type,'_channel2.csv']);

%% Set parameters
roi = 10000.*[1 1];
nControls = 99;
rmax = Inf;

%% Run 2-CLASTA
% Calculate p-value for null hypothesis of random distribution of molecules
[pvalue, cdfs] = pvalue2CLASTA(locs1, locs2, roi, 'nControls', nControls, 'rmax', rmax);

%% Plots
figure
plotLocalizationMap(locs1,locs2,roi)

figure
plotCdfs(cdfs)
plotRmax(rmax)

fprintf('p-value = %.2f\n',pvalue)

%% Functions for plotting
function plotLocalizationMap(locs1,locs2,roi)
    hold on
    plot(locs1(:,1),locs1(:,2),'r.','Markersize',4)
    plot(locs2(:,1),locs2(:,2),'b.','Markersize',4)
    axis equal; box on;
    xlim([0 roi(1)]); ylim([0 roi(2)]);
    xlabel('x'); ylabel('y');
    title('Localization map')
    legend('Channel 1', 'Channel 2')
    set(gca,'FontSize',12)
end

function plotCdfs(cdfs)
    hold on
    n = size(cdfs.x,1);
    for k = 2:n
        h2 = plot(cdfs.x{k}, cdfs.f{k}, 'Color',0.8.*[1 1 1]); % cdfs controls
    end
    h1 = plot(cdfs.x{1}, cdfs.f{1}, 'Color',[90 219 46]./256,'LineWidth',3); % cdf original
    xlabel('Cross-nearest neighbour distance','FontSize',14)
    ylabel('Cumulative probability','FontSize',14);
    leg = legend([h1,h2],'Original data','Toroidal shifts','AutoUpdate','off');
    legend boxoff
    set(leg,'FontSize',12,'Location','SouthEast')
    yticks(0:0.2:1)
end

function plotRmax(rmax)
    if rmax ~= Inf
        xline(rmax,'--','r_{max}','Color',0.3.*[1 1 1],'FontSize',12);
    end
end
