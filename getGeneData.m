function geneCard = getGeneData(gene,reQuery)
load('AllenAPI_Paths.mat')
if ~exist('reQuery,'var')
    reQuery = 0; % Variable to bypass geneCodex lookup and reQuery & save gene data from online
end

% TODO: queryGeneCodex
if ~reQuery
    codexEntry = queryGeneCodex(gene);
    if ~isempty(codexEntry)
        geneCard = load([AtlasGeneDir codexEntry{2,9}]);
        return;
    end
end

% Get Allen Data
[geneDat,sdsDat,usdDat,expPlots] = getAllenGeneData(gene);

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
        saveas(plot_file,expPlots(i),'pdf');
        usdDat(i).plot_file = plot_file;
        geneCard.section_datasets(i).plot_file = plot_file;

        % Download grid data
        try
            grid_data_path = [geneDir filesep geneName '_' num2str(sdsDat(i).id) '_ExpressionGrid'];
            a = unzip(AllenAPI_GridDownloadPath(sdsDat(i).id),...
                [AtlasGeneDir grid_data_path]);
            geneCard.section_datasets(i).grid_data_path = grid_data_path;
        catch
            disp(['Failed to retrieve grid data from ' AllenAPI_GridDownloadPath(sdsDat(i).id)])
        end
    end
    USD = usdDat;
    save([AtlasGeneDir usd_file],'USD')
    geneCard.USD_file = usd_file;
    clear USD
end

gcPath = [geneDir geneName '.mat']
save([AtlasGeneDir gcPath],'geneCard')
out = addGeneToCodex(AtlasGeneDir,geneCard,geneDir);
