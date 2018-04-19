function geneList = makeRandomGeneList(N,fn)
% geneList = makeRandomGeneList(N,fn) returns a struct array of N random genes
% from the Allen Database. fn is the text file save path for the list. If empty 
% list is not saved, if omitted save file is requested.
if ~exist('fn','var')
    [fn,fd] = uiputfile('*.txt','Save List As...');
    if ~isempty(fn)
        fn = [fd fn];
    end
end

load('AllenAPI_Paths.mat')
load([GeneListDir filesep 'AllenAtlasGenes.mat'])

M = numel(AllGeneList);
idx = randsample(M,N);
outList = AllGeneList(idx);
while any(cellfun(@(x) any(isstrprop(x,'punct')),outList))
    idx2 = find((cellfun(@(x) any(isstrprop(x,'punct')),outList)));
    fprintf('Replacing %i genes due to punctuation\n',numel(idx2));
    idx(idx2) = randsample(setdiff(1:M,idx2),numel(idx2),false);
    outList = AllGeneList(idx);
end
geneList = AllGenes(idx);

if ~isempty(fn)
    fid = fopen(fn,'w');
    for i=1:N,
        fprintf(fid,'%s\n',upper(outList{i}));
    end
    fclose(fid);
end
