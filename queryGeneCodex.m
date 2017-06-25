function out = queryGeneCodex(gene,codexPath)
% Searches the local geneCodex to see if data for a gene is already
% available and returns -1 is gene is not in codex otherwise returns the
% codex entry for the desired gene, row 1 is the column headings and row 2
% is the codex information. Accepts a string indicating a singel gene.

%codexStat [Entrez, Allen_SDS, Allen_USD, Allen_GridData, USD_plots,
%geneCard] to be used as a quick reference as to whether data is missing
%or just wasn't found. 0 - not looked for, 1 - found and saved to device,
%-1 - data not found on DB, 2 - data save format is outdated (to be used
%during upgrades to database organization)

% geneCodex [Gene,Aliases,Full_Name,Human_Locus,
%     Human_Entrez_ID,Mouse_Entrez_ID,Section_Dataset_IDs,geneDir,
%     geneCard,codexStat]
load('AllenAPI_Paths.mat')
if ~exist('codexPath','var')
    codexPath = [AtlasGeneDir 'geneCodex.mat'];
end
load(codexPath)
search = strcmp(upper(gene),geneCodex(:,1));
search1 = find(search);
if isempty(search1)
    search1 = find(cellfun(@(x) ~isempty(strfind([' ' x ' '],[' ' upper(gene) ' '])),geneCodex(:,2)));
end
if isempty(search1)
    out = -1;
else
    out = [geneCodex(1,:); geneCodex(search1,:)];
end
