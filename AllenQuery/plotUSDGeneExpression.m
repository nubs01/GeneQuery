function [EE,zEE,structIDX,h] = plotUSDGeneExpression(USD,structs,animal)
if ~exist('animal','var')
    animal = 'mouse';
end

switch USD.plane_of_section_id
    case 1
        secPlane = 'coronal';
    case 2
        secPlane = 'sagittal';
end
geneName = USD.genes.acronym;
SUS = USD.structure_unionizes;
SUS_structAbvs = arrayfun(@(x) x.structure.acronym,SUS,'UniformOutput',false);
SUS_structColors = arrayfun(@(x) x.structure.color_hex_triplet,SUS,'UniformOutput',false);
structIDX = findCellStrIdx(SUS_structAbvs,structs);
EE = [SUS(structIDX(structIDX>0)).expression_energy];
zEE = zscore(EE);

%% Plot expression
set(0,'defaultaxesfontsize',14,'defaultaxesfontname','default')
h = figure();
hold on
k=0;
for i=1:numel(structIDX),
    if structIDX(i)>0
        k=k+1;
        bar(k,zEE(i),'FaceColor',hex2rgb(SUS_structColors{structIDX(i)}))
    end
end

set(gca,'XTick',1:sum(structIDX>0),'XTickLabel',...
    structs(structIDX>0),'XTickLabelRotation',30)
title({...
    sprintf('%s expression in %s brain- %s slices',...
    geneName,animal,secPlane),...
    ['Allen Section Data Set #' num2str(USD.id)],...
    'Z-Score across shown structures'})
ylabel('Z-scored Expression Energy')
