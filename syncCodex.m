function [ removed ] = syncCodex( codexPath )
% syncCodex: Removes Genes from codex that are not in the Database
load('AllenAPI_Paths.mat')
if ~exist('codexPath','var')
    codexPath = [AtlasGeneDir 'geneCodex.mat'];
end

codex = load(codexPath);
gc = codex.geneCodex;
genes = gc(2:end,1);
empties = find(cellfun(@(x) isempty(x),genes));
if ~isempty(empties)
    gc(empties,:) = [];
end
genes = gc(2:end,1);


A = dir(AtlasGeneDir);
A = A([A.isdir]);
A = A(cellfun(@(x) ~strcmp(x(1),'.'),{A.name}));
geneDirs = {A.name};

rmv = [];
for j=1:numel(genes),
    if ~any(strcmp(geneDirs,genes{j}))
        rmv = [rmv j];
    end
end
removed = genes(rmv);
gc(rmv,:) = [];

codex.geneCodex = gc;
codex.TotalGenes = size(gc,1)-1;
codex.LastUpdate = date;

fn = fieldnames(codex);
for i=1:numel(fn),
    eval([fn{i} '= codex.(fn{i});']);
end
eval(['save(''' codexPath ''',''' strjoin(fn,''',''') ''');'])
