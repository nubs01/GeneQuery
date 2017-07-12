function [geneList,geneCards,geneTotals] = collectGeneList(fn)
if ~exist('fn','var')
    [fn,fd] = uigetfile('.txt','Choose gene list');
elseif ischar(fn)
    [fd,fn] = fileparts(fn);
    fd = [fd filesep];
    fn = [fn '.txt'];
end
if ischar(fn)
    Genes = textread([fd fn],'%s');
    Genes = unique(upper(Genes));
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
    else
        Gene = Genes{i};
    end
    [gCard,codexEntry] = getGeneData(Gene);
    if isempty(gCard)
        % Skip gene and count genes not Found (in codex or online)
        fprintf('No Data found for %s\n',Gene)
        notFound{end+1} = Gene;
        continue;
    else
        fprintf('Obtained Data for %s\n',Gene);
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
expCards = geneCards(B);
expList = geneList([true;B],:);
geneTotals(3) = numel(geneCards);
geneTotals(4) = numel(notFound);
fprintf('Searched %i Genes\nFound %i Genes\n%i of these had expression data\nNo Data found for %i Genes\n',geneTotals(1),geneTotals(2),geneTotals(3),geneTotals(4));
