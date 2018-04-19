function [geneList,geneCards,geneTotals] = collectGeneList(fn,expNeeded)
% [geneList, geneCards,geneTotals] = collectGeneList(fn,expNeeded) collects
% gene data for all genes in fn. fn can be a path to a text gene list, a cell
% array of gene names or a struct array of Allen gene data. If expNeeded is set
% to 1 (default = 0) then only genes with expression data are returned.

if ~exist('expNeeded','var')
    expNeeded = 0;
end

if ~exist('fn','var') || isempty(fn)
    [fn,fd] = uigetfile('.txt','Choose gene list');
elseif ischar(fn)
    [fd,fn] = fileparts(fn);
    fd = [fd filesep];
    fn = [fn '.txt'];
end
if ischar(fn)
    Genes = textread([fd fn],'%s');
    Genes = unique(upper(Genes));
elseif iscell(fn)
    Genes = upper(fn);
elseif isstruct(fn)
    Genes = fn;
end
geneTotals = [numel(Genes) 0 0 0]; % Gene totals [searched found_sans_duplicates found_expression notFound]

geneList = queryGeneCodex('');
geneCards = makeGeneCard([],[],[],[]);
notFound = {};
for i=1:numel(Genes),
    if isstruct(Genes)
        Gene = Genes(i);
        geneName = Gene.acronym;
    else
        Gene = Genes{i};
        geneName = Gene;
    end
    [gCard,codexEntry] = getGeneData(Gene);
    if isempty(gCard)
        % Skip gene and count genes not Found (in codex or online)
        fprintf('No Data found for %s\n',geneName)
        notFound{end+1} = Gene;
        continue;
    else
        fprintf('Obtained Data for %s\n',geneName);
        geneList(end+1,:) = codexEntry(2,:);
        geneCards(end+1) = gCard;
    end
end
geneCards = geneCards(2:end);
% Remove any duplicates that may have been hidden via aliases earlier
[~,b] = unique(geneList(2:end,1));
b = sort(b,'ascend');
geneCards = geneCards(b);
geneList = geneList([1;b+1],:);
geneTotals(2) = size(geneList,1)-1;

% Find genes with mouse expression data
B = cellfun(@(x) ~isempty(x),geneList(2:end,7));
geneTotals(3) = numel(find(B));
if expNeeded
    geneCards = geneCards(B);
    geneList = geneList([true;B],:);
end
geneTotals(4) = numel(notFound);
fprintf('Searched %i Genes\nFound %i Genes\n%i of these had expression data\nNo Data found for %i Genes\n',geneTotals(1),geneTotals(2),geneTotals(3),geneTotals(4));


% Some random comment
