function [corruptGeneCards,missingGenes] = fixGeneDB_June2017(codexPath)

load('AllenAPI_Paths.mat')
if ~exist('codexPath','var')
    codexPath = [AtlasGeneDir 'geneCodex.mat'];
end
codex = load(codexPath);
geneCodex = codex.geneCodex;

A = dir(AtlasGeneDir);
A = A([A.isdir]);
A = A(cellfun(@(x) ~strcmp(x(1),'.'),{A.name}));
geneList = {A.name};
clear A;


cd(AtlasGeneDir)

% Codex Setup
% Codex: [Gene,Aliases,Full_Name,Human_Locus,
%     Human_Entrez_ID,Mouse_Entrez_ID,Section_Dataset_IDs,geneDir,
%     geneCard,date_added,codexStat]
% Codex DataTypes: [str,str,str,str,int,int,intArr,path,path,date,intArr]
nGC = cell(size(geneCodex,1),11);
nGC(1,:) = {'Gene','Aliases','Full_Name','Human_Locus',...
    'Human_Entrez_ID','Mouse_Entrez_ID','Section_Dataset_IDs',...
    'geneDir','geneCard','date_added','codexStat'};
GC_datTypes = {'str','str','str','str','int','int','intArr','path',...
    'path','date','intArr'};
cardFields = {'name';'mouse_entrez_id';'section_datasets';'human_locus';...
    'full_name';'summary';'human_entrez_id';'aliases';'date_retrieved'};

gcMapping = 1:size(geneCodex,2);
gcMapping(end) = gcMapping(end)+1;
rmv = [];
corrupt = [];
for i=2:size(geneCodex,1),
    
    line1 = geneCodex(i,:);
    line2 = cell(1,size(nGC,2));
    line2(1:end-2) = line1(1:end-1);
    line2(end) = line1(end);
    
    gene = line1{1};
    
    % Check data types correct strings to ints
    
    
    % Check if folder exists and fix codex paths
    if exist(gene,'dir')==7 && exist([gene filesep gene '.mat'],'file')==2
        line2{8} = [gene filesep];
        line2{9} = [gene filesep gene '.mat'];
        gCard = load(line2{9});
        gCard = gCard.geneCard;
    else
        rmv = [rmv i];
        if exist(gene,'dir')==7
            rmdir(gene,'s');
        end
        continue;
    end
    
    
    if isfield(gCard,'retrieved_date')
        geneCard = gCard;
        if ~isempty(geneCard.retrieved_date)
            geneCard.date_retrieved = geneCard.retrieved_date;
        end
        geneCard = rmfield(geneCard,'retrieved_date');
        gCard = geneCard;
    end
    gFields = fieldnames(gCard);
    if numel(gFields)~=numel(cardFields) || ~all(strcmp(gFields,cardFields))
        corrupt = [corrupt i];
        continue;
    end
    
    line2{end-1} = gCard.date_retrieved;
    
    % Check Gene Folder contents & match with codex
    if ~isempty(gCard.section_datasets)
        SDS = gCard.section_datasets;
        for j=1:numel(SDS),
            if ~isempty(SDS(j).USD_file)
                SDS(j).USD_file = [gene filesep gene '_USD_data.mat'];
                SDS(j).plot_file = [gene filesep gene '_' SDS(j).section_plane '_id' num2str(SDS(j).id) '_expressionPlot.pdf'];
                load(SDS(j).USD_file)
                USD(j).plot_file = SDS(j).plot_file;
                save(SDS(j).USD_file,'USD');
                clear USD;
            end
            if ~isempty(SDS(j).grid_data_path)
                SDS(j).grid_data_path = [gene filesep gene '_' num2str(SDS(j).id) '_ExpressionGrid' filesep];
            end
            
        end
        gCard.section_datasets = SDS;
    end
    
    if ischar(gCard.mouse_entrez_id)
        gCard.mouse_entrez_id = str2num(gCard.mouse_entrez_id);
    end
    if ischar(gCard.human_entrez_id)
        gCard.human_entrez_id = str2num(gCard.human_entrez_id);
    end
    
    
    geneCard = gCard;
    save(line2{9},'geneCard');
    clear geneCard;
    
    if ischar(line2{5})
        line2{5} = str2num(line2{5});
    end
    if ischar(line2{6})
        line2{6} = str2num(line2{6});
    end

    nGC(i,:) = line2;
end

% Display broken genes & ask user to delte and save List or re-download now
corruptGeneCards = nGC(corrupt,1);
missingGenes = nGC(rmv,1);
disp('Corrupt GeneCards:')
disp(corruptGeneCards)
disp('\n')
disp('Missing Genes:')
disp(missingGenes)

nGC(rmv,:) = [];

codex.TotalGenes = size(nGC,1)-1;
codex.LastUpdate = date;
codex.geneCodex = nGC;

% Save fixed codex
clearvars -except codex codexPath corruptGeneCards missingGenes
fn = fieldnames(codex);
for i=1:numel(fn),
    eval([fn{i} '= codex.(fn{i});']);
end
eval(['save(''' codexPath ''',''' strjoin(fn,''',''') ''');'])