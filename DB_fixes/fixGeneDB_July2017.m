function fixGeneDB_July2017()

load('AllenAPI_Paths.mat')
A = dir(AtlasGeneDir);
A = A([A.isdir]);
A = A(cellfun(@(x) ~strcmp(x(1),'.'),{A.name}));
geneList = {A.name};
clear A;

cd(AtlasGeneDir)
requery = {};
for i=1:numel(geneList),
    toSave = 0;
    gfile = [geneList{i} filesep geneList{i} '.mat'];
    geneCard = load(gfile);
    if isfield(geneCard,'geneDat')
        requery = [requery geneCard.geneDat.name];
        rmdir(geneList{i},'s');
        continue;
    end
    geneCard = geneCard.geneCard;
    if isempty(geneCard.aliases)
        continue;
    end
    if ~strcmp(geneCard.aliases(1),' ')
        geneCard.aliases = [' ' geneCard.aliases];
        toSave = 1;
    end
    if ~strcmp(geneCard.aliases(end),' ')
        geneCard.aliases = [geneCard.aliases ' '];
        toSave = 1;
    end
    if toSave
        save(gfile,'geneCard');
    end
end

for i=1:numel(requery),
    gc = getGeneData(requery{i},1)
end
