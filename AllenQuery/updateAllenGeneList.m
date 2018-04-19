function out = updateAllenGeneList()

outPath = which('AllenAtlasGenes.mat');

query = 'http://api.brain-map.org/api/v2/data/Gene/query.json?criteria=products%5Bid$eq1%5D';
AllGenes = QueryAllenAPI(query);
AllGeneList = cell(numel(AllGenes),1);
AllGeneAliases = cell(numel(AllGenes),1);

for i=1:numel(AllGenes),
    AllGeneList{i} = AllGenes(i).acronym;
    AllGeneAliases{i}= upper([' ' AllGenes(i).acronym ' ' AllGenes(i).alias_tags ' ']);
    if isempty(AllGenes(i).alias_tags)
        AllGeneAliases{i} = AllGeneAliases{i}(1:end-1);
    end
end

save(outPath,'AllGenes','AllGeneList','AllGeneAliases');
