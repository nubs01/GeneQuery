function out = addGeneToCodex(CodexDir,geneCard,geneDir)

load([CodexDir 'geneCodex.mat']);

idx = find(strcmp(geneCodex(:,1),geneCard.name));

codexEntry = {geneCard.name,geneCard.aliases,geneCard.full_name,...
                geneCard.human_locus,geneCard.human_entrez_id,...
                geneCard.mouse_entrez_id,[geneCard.section_datasets.id]',...
                geneDir,[geneDir geneCard.name '.mat'],date};

if isempty(idx)
    geneCodex(end+1,:) = codexEntry;
elseif numel(idx)>1
    error(['Multiple enteries for gene: ' geneCard.name]);
else
    geneCodex(idx,:) = codexEntry;
end

LastAdditon = date;
save([CodexDir 'geneCodex.mat'],'geneCodex','LastAddition','LastUpdate');
