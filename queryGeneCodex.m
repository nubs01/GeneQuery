function codexEntry = queryGeneCodex(Query,queryField,codexPath)
% Searches the local geneCodex to see if data for a Query is
% available and returns [] if Query is not in codex otherwise returns the
% codex entry for the desired gene or genes, row 1 is the column headings and
% row 2+ is the codex information. Accepts a string search Query.
% codexPath is an optional input indicating which codex to search, otherwise it searches the codex in the AtlasGeneDir
% queryField is an optional string input indicating which column of the codex to search for your query. If not included the search will look through the Genes and Aliases

% geneCodex: [Gene,Aliases,Full_Name,Human_Locus,
%     Human_Entrez_ID,Mouse_Entrez_ID,Section_Dataset_IDs,geneDir,
%     geneCard,date_retreived]

load('AllenAPI_Paths.mat')
if ~exist('codexPath','var')
    codexPath = [AtlasGeneDir 'geneCodex.mat'];
end
load(codexPath)
codexEntry = [];

if ~exist('queryField','var')
    search1 = queryGeneCodex(Query,'Gene');
    search2 = queryGeneCodex(Query,'Aliases');
    if isempty(search1) && isempty(search2)
        return;
    elseif isempty(search1)
        codexEntry = search2;
    elseif isempty(search2)
        codexEntry = search1;
    else
        codexEntry = [search1;search2(2:end,:)];
        % keep unique entries
        [~,b] = unique(codexEntry(2:end,1));
        codexEntry = codexEntry([1 b+1],:);
    end
    return;
end
searchCol = find(strcmp(geneCodex(1,:),queryField));
if isempty(searchCol)
    error('Please search valid field of codex');
end

if strcmp(queryField,'Aliases')
    search = find(cellfun(@(x) any(strcmp(upper(strsplit(x,' ')),upper(Query))),geneCodex(:,searchCol)));
elseif strcmp(queryField,'Section_Dataset_IDs')
    search = find(cellfun(@(x) any(x==Query),geneCodex(:,searchCol)));
else
    if ischar(geneCodex{2,searchCol})
    search = find(strcmp(upper(geneCodex(:,searchCol)),upper(Query)));
else
    search = find([geneCodex{:,searchCol}]==Query);
end
if isempty(search)
    return;
end
codexEntry = geneCodex([1 search],:);

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
