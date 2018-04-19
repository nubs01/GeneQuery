function structArr = QueryAllenAPI(webpath,multiattempt)
%structArr = QueryAllenAPI(webpath) attempts to query the api at webpath
%for json data. If the output data has more rows than is returned in the
%first query this will step up the start row until all rows of query data
%are returned in structArr. Error is thrown if the webpath is bad and does
%not query properly and returns an empty structArr if the search went fine
%but no data was returned.
if nargin==1
    multiattempt=4;
end
start_row = 0;
num_rows = 2000;
total_rows = -1;
done = 0;
structArr = [];
readOpts = weboptions;
readOpts.Timeout=80;

while ~done
    attempt=1;
    apiURL = sprintf('%s&start_row=%d&num_rows=%d',webpath,start_row,num_rows);
    disp(['Querying: ' apiURL])
    response = [];
    while isempty(response) && attempt<=multiattempt
        try
            response = webread(apiURL,readOpts);
        catch ME
            response=[];
            attempt = attempt+1;
        end
    end
    if isempty(response)
        error('timeout problems')
    elseif ~response.success
        error('Query Failed...bad query path')
    elseif response.total_rows==0
        disp('404: Query matching criteria not found');
        return;
    end
    structArr = [structArr;response.msg];
    if total_rows<0
        total_rows = response.total_rows;
    end
    start_row = start_row+response.num_rows;
    
    if start_row>=total_rows
        done = 1;
        disp('Query Success!')
    end
end