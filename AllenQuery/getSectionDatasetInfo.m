function [sdsDat] = getSectionDatasetInfo(geneName,secPlane)

load('AllenAPI_Paths.mat')
prodID = 1;
secPlane = lower(secPlane);
sdsDat = [];

sdsDat = QueryAllenAPI(AllenAPI_GeneDataPath(geneName,secPlane,prodID));

% trim sdsDat to only have delegate or only sets with expression data
if numel(sdsDat)>1
    rmv = [];
    for j=1:numel(sdsDat),
        if sdsDat(j).delegate
            sdsDat = sdsDat(j);
            rmv = [];
            break;
        end
        if ~sdsDat(j).expression
            rmv = [rmv;j];
        end
    end
    if ~isempty(rmv)
        sdsDat(rmv) = [];
    end
end
if isempty(sdsDat)
    fprintf('Section Data Set not found for %s-%s\n',geneNamw,secPlane);
end
