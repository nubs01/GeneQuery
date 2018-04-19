function dat = searchEntrez(db,term)

load('EntrezAPI_Paths.mat')
readOpts = weboptions;
readOpts.Timeout=80;

disp(['Querying entrez API: ' EntrezAPI_SearchPath(db,term)])
dat = webread(EntrezAPI_SearchPath(db,term),readOpts);
dat = dat.esearchresult;

if str2double(dat.count)==0
    fprintf('No query results for %s in %s database\n',term,db)
    return;
elseif str2double(dat.count)>str2double(dat.retmax)
    disp('Re-querying with higher max return')
    dat = webread([EntrezAPI_SearchPath(db,term) '&retmax=' num2str(dat.count)],readOpts);
    dat = dat.esearchresult;
end

disp('Query Success!')