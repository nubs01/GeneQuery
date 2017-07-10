function [geneList,geneCards,geneTotals] = collectGeneList(fn)
if ~exist('fn','var')
    [fn,fd] = uigetfile('.txt','Choose gene list');
else
    [fd,fn] = fileparts(fn);
    fd = [fd filesep];
    fn = [fn '.txt'];
end
Genes = textread([fd fn],'%s');
Genes = unique(upper(Genes));
geneTotals = [numel(Genes) 0 0]; % Gene totals [searched sans_duplicates]

geneList = [];
geneCards = [];
for i=1:numel(Genes),
    gc = queryGeneCodex(Genes{i});
    if iscell(gc)
        disp(['Found gene: ' Genes{i}])
       if isempty(geneList)
           geneList = gc;
           gCard = load(gc{2,9});
           gCard = gCard.geneCard;
           geneCards = gCard;
       else
           geneList(end+1,:) = gc(2,:);
           gCard = load(gc{2,9});
           gCard = gCard.geneCard;
           geneCards(end+1) = gCard;
       end
    else
        geneCard = getGeneData(Genes{i});
        gc = queryGeneCodex(Genes{i});
        if isempty(geneList)
            geneList = gc;
            geneCards = geneCard;
        else
            geneList(end+1,:) = gc(2,:);
            geneCards(end+1) = geneCard;
        end
    end
end

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
