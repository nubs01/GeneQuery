function [plotHandle,metadata] = multiGeneExpressionGrid(geneCards,metadata)
% [plotHandle,metadata] = multiGeneExpressionGrid(geneCards,metadata)
% geneCards is a structure array of GeneCards gathered with collectGeneList
% metadata is a structure made with multiGeneMetaGUI and contains all input
% parameters for this plotting as well as source data. This function will add
% to metadata as it runs and return the complete metadata as an output.

saveIt = 0;
skipAnalysis = 0;
load('AllenAPI_Paths.mat');
if ~exist('metadata','var')
    metadata = multiGeneMetaGUI;
    if isempty(metadata)
        plotHandle = [];
        return;
    end
end
if ischar(metadata) % if its a path to a saved data file
    datFile = metadata;
    load(dataFile);
    skipAnalysis = 1;
    N = numel(metadata.genes_plotted);
    geneCards = metadata.Genes;
end

if isnan(metadata.expression_thresh)
    thresh = 0.1; % only normalizedexpression > thresh is added to the total
    metadata.expression_thresh = thresh;
else
    thresh = metadata.expression_thresh;
end

metadata.Genes = geneCards;
metadata.size_grid = [67 41 58]; % grid size for reshaping energy.raw data
metadata.creation_date = date;
sec_plane = metadata.Section_Plane;

if ~isempty(metadata.save_directory)
    saveIt = 1;
    saveDir = metadata.save_directory;
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
end

if saveIt
    datFile = [saveDir filesep metadata.Title '_multiGeneExpressionData-' sec_plane '.mat'];
end


if ~skipAnalysis
    N = 0;
    sizeGrid = metadata.size_grid;
    totNormEnergy = zeros(prod(sizeGrid),1);
    allEnergies = cell(1,numel(geneCards));
    rmv = [];
    for i=1:numel(geneCards),
        geneCard = geneCards(i);
        if isempty(geneCard.section_datasets) || ~any(strcmp({geneCard.section_datasets.section_plane},sec_plane))
            rmv = [rmv i];
            continue;
        end

        % Get first section_dataset of correct plane
        sds = geneCard.section_datasets(find(strcmp({geneCard.section_datasets.section_plane},sec_plane)));
        if numel(sds)>1
            fprintf('Too many %s section datasets. Choosing %i...\n',sec_plane,sds(1).id);
            sds = sds(1);
        end

        % Load and add expression energy data
        fid = fopen([AtlasGeneDir sds.grid_data_path filesep 'energy.raw'],'r','l');
        allEnergies{i} = fread(fid,prod(sizeGrid),'float');
        fclose(fid);
        eng = allEnergies{i};
        engOrg = eng;
        % if all expression points are -1 skip
        if all(eng==-1)
            rmv = [rmv i];
            allEnergies{i} = [];
            continue;
        end

        metadata.genes_plotted{end+1} = geneCard.name;
        normE = eng./max(eng);

        idx = normE>thresh;
        totNormEnergy(idx) = totNormEnergy(idx) + normE(idx);
        N = N+1;
    end
    if saveIt
        save(datFile,'allEnergies','totNormEnergy','metadata');
        disp(['Expression data consolidated and saved to: ' datFile])
    end
end

clearvars -except saveDir geneCards totNormEnergy sizeGrid sec_plane datFile N metadata saveIt

disp('Plotting...')
figH = figure();
engGrid = reshape(totNormEnergy,sizeGrid);
engScat = GQ_make3DPlottable(engGrid);
EDS = engScat;
EDS = EDS(EDS(:,4)>0,:);
zEDS = zscore (EDS(:,4));
EDS(zEDS<=0,:) = [];
zEDS(zEDS<=0) = [];
plotHandle = scatter3(EDS(:,2),EDS(:,3),-EDS(:,1),4,zEDS,'filled');
colormap('jet');
c = colorbar;
whitebg(figH,[0 0 0])
ylabel('Medial-Lateral')
xlabel('Anterior-Posterior')
zlabel('Dorsal-Ventral')
ylabel(c,'Z-Scored Total Normalized Gene Expression Energy')
title({[metadata.Title ' Multi-Gene Expression'],...
    sprintf('Summed %s expression for %g/%g genes',sec_plane,N,numel(geneCards))})
if saveIt
    saveas(plotHandle,[saveDir filesep metadata.Title '_multiGeneExpressionGrid-' sec_plane '.fig']);
end
