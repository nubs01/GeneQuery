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
    disp('Gene not found in codex.')
    return;
end
gd = [AtlasGeneDir geneCodex{search1,8}];

disp(['Removing gene from codex: ' gene])
geneCodex(search1,:) = [];
LastUpdate = date;
save(codexPath,'geneCodex','LastUpdate','LastAddition');

% Delete gene data

disp(['Deleting Gene Directory: ' gene])

if ~exist(gd,'dir')
    out = -1;
    disp('Gene Directory not found')
    return;
end
rmdir(gd,'s');
out = 1;
