function out = deleteGene(gene,codexPath)
% Deletes a gene's data folder and codex entry
% returns -1 if gene is not found

load('AllenAPI_Paths.mat')
out = 0;
if ~exist('codexPath','var')
    codexPath = [AtlasGeneDir 'geneCodex.mat'];
end
load(codexPath)

% Basic Search in codex
search = strcmp(upper(gene),geneCodex(:,1));
search1 = find(search);
if isempty(search1)
    search1 = find(cellfun(@(x) ~isempty(strfind([' ' x ' '],[' ' upper(gene) ' '])),geneCodex(:,2)));
end
if isempty(search1)
    out = -1;
    return;
end

% Delete gene data
gd = [AtlasGeneDir geneCodex{search1,8}];
disp(['Deleting Gene Directory: ' geneCodex{search1,8})
rmdir(gd,'s');
disp(['Removing gene from codex: ' gene])
geneCodex(search1,:) = [];
TotalGenes = TotalGenes - 1;
LastUpdate = date;
save(codexPath,'geneCodex','TotalGenes','LastUpdate','LastAddition');
out = 1;
