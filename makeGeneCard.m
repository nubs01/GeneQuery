function [geneCard] = makeGeneCard(geneDat,sdsDat,usdDat,enzDat)
geneCard = struct('name','','mouse_entrez_id',[],...
    'section_datasets',struct('id', [], 'section_plane_id', [], ...
    'delegate', [], 'section_plane', '', 'expression_energy', [],...
    'structures_of_interest', {}, 'USD_file', '', 'zEE', [],...
    'plot_file', '', 'grid_data_path', ''),'human_locus','','full_name',...
    '','summary','','human_entrez_id',[],'aliases','','date_retrieved','');
if isempty(geneDat) && isempty(enzDat)
    return;
end

aliases = '';
alias = {};
if ~isempty(geneDat)
    geneCard.name = upper(geneDat.acronym);
    geneCard.mouse_entrez_id = geneDat.entrez_id;
    geneCard.full_name = geneDat.original_name;
    alias = upper(strsplit(char(geneDat.alias_tags)));
else
    % Preference Allen acronym over entrez name
    geneCard.name = upper(enzDat.name);
end

if ~isempty(enzDat)
    % Preference entrez full name over Allen full name
    alias = [alias upper(strsplit(strrep(enzDat.otheraliases,', ',' ')))];
    A = {'full_name','human_locus','summary','human_entrez_id'};
    B = {'nomenclaturename','maplocation','summary','uid'};
    for i=1:numel(A),
        if isfield(enzDat,B{i})
            if i==numel(A)
                geneCard.(A{i}) = str2num(enzDat.(B{i}));
            else
                geneCard.(A{i}) = enzDat.(B{i});
            end
        end
    end
end

alias = unique(alias);
geneCard.aliases = [' ' strjoin(alias,' ') ' '];
secPlanes = {'coronal','sagittal'};
if ~isempty(sdsDat)
    for i=1:numel(sdsDat),
        geneCard.section_datasets(i).id = sdsDat(i).id;
        geneCard.section_datasets(i).section_plane_id = sdsDat(i).plane_of_section_id;
        geneCard.section_datasets(i).delegate = sdsDat(i).delegate;
        
        if ~isempty(usdDat) && numel(usdDat)>=i
            if ~strcmp(secPlanes{sdsDat(i).plane_of_section_id},usdDat(i).section_plane)
                error('USD and SDS plane do not match!');
            end
            geneCard.section_datasets(i).section_plane = usdDat(i).section_plane;
            geneCard.section_datasets(i).expression_energy = usdDat(i).expression_energy;
            geneCard.section_datasets(i).zEE = usdDat(i).zEE;
            geneCard.section_datasets(i).structures_of_interest = usdDat(i).structures_of_interest;
        end
    end
end

geneCard.date_retrieved = date;
