function dat = getEntrezGeneData(gene,org)
if ~exist('org','var')
    org = 'human';
end

load('EntrezAPI_Paths.mat');
queryTerm = sprintf('%s[sym],%s[organism]',gene,org);
geneSearch = searchEntrez('gene',queryTerm);
if str2double(geneSearch.count)==0
    dat = [];
    return;
end
idList = cellfun(@(x) str2double(x),geneSearch.idlist);
keep = [];
for i=1:numel(idList)
    id = idList(i);
    A = getEntrezSummary('gene',id);
    geneData{i}=A;
    if strcmp(lower(geneData{i}.name),lower(gene))
        keep = [keep;i];
    end
end
keep2 =[];
if numel(keep)>1
    for i=1:numel(keep)
        if ~isempty(geneData{keep(i)}.maplocation)
            keep2 = [keep2;keep(i)];
        end
    end
    if ~isempty(keep2)
        keep = keep2;
    end
    if numel(keep)>1
        N = numEmptyFields(geneData(keep));
        [~,idx] = min(N);
        keep = keep(idx);
    end
end
if numel(keep)>1
%     error('Too many Entrez Data Sets')
end
dat = [geneData{keep}];
