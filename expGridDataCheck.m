function out = expGridDataCheck()
% Temp fix for the problem where gene data is saved but grid data download fails. Probably due to Internet timeouts at the wrong time.

load('AllenAPI_Paths.mat')
currDir = pwd;
cd(AtlasGeneDir)
load('geneCodex.mat')
out = 0;
for i=2:size(geneCodex,1),
    gc = load(geneCodex{i,9});
    gc = gc.geneCard;
    if ~isempty(gc.section_datasets)
        for j=1:numel(gc.section_datasets)
            if ~exist(gc.section_datasets(j).grid_data_path,'dir')
                disp(['Fixing Grid Data for ' gc.name]);
                try
                    a=unzip(AllenAPI_GridDownloadPath(gc.section_datasets(j).id),...
                    gc.section_datasets(j).grid_data_path);
                catch
                    error('Couldn''t download expression grid');
                end
            end
        end
    end
end

cd(currDir)
out = 1;
end
