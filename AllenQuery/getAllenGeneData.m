function [geneDat,sdsDat,usdDat,expPlots] = getAllenGeneData(gene,StructuresOfInterest)
geneDat = [];
sdsDat = [];
usdDat = [];
expPlots = [];

% Find gene data in saved list of AllenAtlasGenes
if ischar(gene)
load('AllenAtlasGenes.mat')
idx = find(cellfun(@(x) ~isempty(strfind(x,...
    [' ' upper(gene) ' '])),AllGeneAliases));
if isempty(idx)
    fprintf('Gene %s not found in Allen Mouse Database. Please update gene list and try again.\n',gene);
    return;
end
if numel(idx)>1
    error(sprintf('Too many genes found to match %s:\n\t%s',...
        gene,strjoin(AllGeneList(idx),'\n\t')))
end

geneDat = AllGenes(idx);
fprintf('Found gene %s listed as %s in Allen Database.\nGetting Expression Data...\n',gene,geneDat.acronym);
elseif isstruct(gene) % So function can be passed geneDat instead of a geneName
    geneDat = gene;
end
geneName = geneDat.acronym;

% Get Section Dataset Info from Allen Atlas
if nargout < 2
    return;
end
sds{1} = getSectionDatasetInfo(geneName,'sagittal');
sds{2} = getSectionDatasetInfo(geneName,'coronal');
sdsDat = [];
for i=1:numel(sds)
    if ~isempty(sds{i})
        if ~isrow(sds{i})
            sds{i} = sds{i}';
        end
        sdsDat = [sdsDat sds{i}];
    end
end
if isempty(sdsDat)
    fprintf('No Section Data found for %s.',geneName);
    return;
end

% Get USD data from Allen Atlas
if nargout < 3
    return;
end
load('AllenAPI_Paths.mat')
if ~exist('StructuresOfInterest','var')
    StructuresOfInterest = {'Isocortex','OLF','HPF','CTXsp','STR','PAL','HY'...
        ,'MB','P','MY','CB','TH','RT','RE'};
end
usdDat = struct('gene',repmat({geneName},1,numel(sdsDat)),'date_retrieved',date,...
            'id',{sdsDat.id},'section_plane_id',{sdsDat.plane_of_section_id},...
            'section_plane','','qc_date',{sdsDat.qc_date},...
            'delegate',{sdsDat.delegate},'expression',{sdsDat.expression},...
            'failed',{sdsDat.failed},'reference_space_id',...
            {sdsDat.reference_space_id},'section_thickness',...
            {sdsDat.section_thickness},'specimen_id',...
            {sdsDat.specimen_id},'sphinx_id',{sdsDat.sphinx_id},...
            'plot_file','','expression_energy',[],...
            'structures_of_interest',{StructuresOfInterest},'structIDX',[],...
            'structure_unionizes',[],'zEE',[]);

for i=1:numel(sdsDat),
    fprintf('Obtaining Expression Data for %s: %i...\n',geneName,sdsDat(i).id);
    USD = QueryAllenAPI(AllenAPI_StructUnionizedPath(sdsDat(i).id));
    if isempty(USD.structure_unionizes)
        fprintf('USD data empty for %s : %i\n',geneName,sdsDat(i).id);
        continue;
    end
    switch USD.plane_of_section_id
        case 1
            secPlane = 'coronal';
        case 2
            secPlane = 'sagittal'
    end
    warning off
    [EE,zEE,structIDX,expPlots(i)] = plotUSDGeneExpression(USD,StructuresOfInterest);
    warning on
    set(expPlots(i),'Visible','off')
    drawnow;
    usdDat(i).expression_energy = EE;
    usdDat(i).zEE = zEE;
    usdDat(i).structIDX = structIDX;
    usdDat(i).section_plane = secPlane;
end
