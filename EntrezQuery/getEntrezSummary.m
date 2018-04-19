function dat = getEntrezSummary(db,id)
id_str=num2str(id,'%d,');
id_str = id_str(1:end-1);

load('EntrezAPI_Paths.mat')
readOpts = weboptions;
readOpts.Timeout=80;

disp(['Querying Entrez database for summary: ' EntrezAPI_SummaryPath(db,id_str)])
dat = webread(EntrezAPI_SummaryPath(db,id_str),readOpts);
if isfield(dat,'error')
    fprintf('Error with query of %s database for id#: %s\n',db,id_str);
    return;
end
disp('Query Success!')
dat = dat.result;
uids = dat.uids;
if numel(uids)>1
    data = dat;
    clear dat;
    for i=1:numel(uids),
        k = str2double(uids{i});
        eval(['dat{i}=data.x' num2str(k)  ';'])
    end
else
    if str2double(uids{1})~=id
        fprintf('Summary query for id#: %s returned id#: %s.\n',id_str,uids{1});
        return;
    end
    eval(['dat=dat.x' num2str(id)  ';'])
end
        
