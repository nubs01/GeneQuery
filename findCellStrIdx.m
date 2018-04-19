function cellIdx = findCellStrIdx(MainList,targets)
%cellIdx = findCellStrIdx(MainList,targets) attempts to find the index of 
%each member of cell array targets in MainList and returns an array with 
%those values. Index will be -1 if the string was not found MainList. 
%
%targets - cell array of strings or single string
%MainList - cell array of strings

if ~ischar(targets)
    cellIdx = cellfun(@(t) findCellStrIdx(MainList,t),targets);
    if isrow(cellIdx)
        cellIdx = cellIdx';
    end
    return;
end

sidx = find(strcmp(MainList,targets));
if isempty(sidx)
    cellIdx = -1;
    fprintf('Cannot find target string %s.\n',targets);
    return;
end
cellIdx = sidx;