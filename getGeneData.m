function [geneCard,codexEntry] = getGeneData(gene,reQuery)
% [geneCard,codexEntry] = getGeneData(gene,reQuery) returns the geneCards and
% codexEntries for a gene. Gene will first be looked for the offline gene
% database, and if not found will be queried from the Allen and Entrez
% databases to get Mouse and Human data about the gene. If reQuery is set to 1
% (default = 0), then the geneData will be reQueried from the online databses
% even if found in the local database. Local database info will be replaced. If
% gene data is not found in Allen Database, you may need to update the the
% offline list of all Allen DB genes.

load('AllenAPI_Paths.mat')
if ~exist('reQuery','var')
    reQuery = 0; % Variable to bypass geneCodex lookup and reQuery & save gene data from online
end

if ~reQuery
    if isstruct(gene)
        codexEntry = queryGeneCodex(gene.acronym);
    else
        codexEntry = queryGeneCodex(gene);
    end
    if ~isempty(codexEntry)
        geneCard = load([AtlasGeneDir codexEntry{2,9}]);
        geneCard = geneCard.geneCard;
        return;
    end
end

% Get Allen Data
[geneDat,sdsDat,usdDat,expPlots] = getAllenGeneData(gene);
if isstruct(gene)
    gene = gene.acronym;
end
if isempty(geneDat)
    geneName = gene;
else
    geneName = geneDat.acronym;
end
geneName = upper(geneName);

% get entrez data
enzDat = getEntrezGeneData(geneName);

% Make geneCard
geneCard = makeGeneCard(geneDat,sdsDat,usdDat,enzDat);
if isempty(geneCard.name)
    geneCard = [];
    return;
else
    geneName = geneCard.name;
end

% Make Gene directory
geneDir = [geneName filesep];
if exist([AtlasGeneDir geneDir],'dir')~=7
    mkdir([AtlasGeneDir geneDir])
else
    % TODO: what to do if the gene directory already exists
end
if ~isempty(usdDat)
    % Save USD data
    usd_file = [geneDir geneName '_USD_data.mat'];

    for i=1:numel(usdDat),
        % Save plots
        plot_file = sprintf('%s%s_%s_id%i_expressionPlot.pdf',...
            geneDir,geneName,usdDat(i).section_plane,sdsDat(i).id);
        saveas(expPlots(i),[AtlasGeneDir plot_file],'pdf');
        usdDat(i).plot_file = plot_file;
        geneCard.section_datasets(i).plot_file = plot_file;
        close(expPlots(i));
        % Download grid data
        try
            grid_data_path = [geneDir filesep geneName '_' num2str(sdsDat(i).id) '_ExpressionGrid'];
            currDir = pwd;
            cd(AtlasGeneDir);
            a = unzip(AllenAPI_GridDownloadPath(sdsDat(i).id),...
                grid_data_path);
            cd(currDir);

            geneCard.section_datasets(i).grid_data_path = grid_data_path;
        catch
            disp(['Failed to retrieve grid data from ' AllenAPI_GridDownloadPath(sdsDat(i).id)])
        end
        geneCard.section_datasets(i).USD_file = usd_file;
    end
    USD = usdDat;
    save([AtlasGeneDir usd_file],'USD')
    clear USD
end

gcPath = [geneDir geneName '.mat'];
save([AtlasGeneDir gcPath],'geneCard')
codexEntry = addGeneToCodex(AtlasGeneDir,geneCard,geneDir);
