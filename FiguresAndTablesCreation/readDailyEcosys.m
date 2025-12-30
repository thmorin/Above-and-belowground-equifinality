function status = readDailyEcosys(filename, startRow, endRow)
status=false;
%% Initialize variables.
if nargin<=2
    startRow = 2;
    endRow = inf;
end

fid=fopen(filename);
Heads=fgetl(fid);
fclose(fid);
Heads(Heads=='.' | Heads=='[' | Heads==']' | Heads=='/')=[];
H=strsplit(Heads);
H=H(2:end-1);

formatSpec = '%8f%12f';
for i=3:length(H)
    if strcmp(H{i},'GROWTH_STG')
        formatSpec=[formatSpec '%16C'];
    else
        formatSpec=[formatSpec '%16f'];
    end
end
%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n','TreatAsEmpty','NaN');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
% Conditional formatting to catch bad input files with nan's
badOut=cell2mat(cellfun(@isnan,dataArray,'UniformOutput',false));
if any(badOut==1,'all')
    warning('ecosys outputs contain nan''s');
    for i=3:size(dataArray,2)
    	dataArray{i}=nan(size(dataArray{1}));
    end
end

if length(dataArray{1})>366
    dd=dataArray{2}(1);
    yy=mod(dd,10000);
    ly=ly_vec(yy);
    warning('ecosys lengths are not correct');
    dataArray{1}=(1:365+ly)';
    [mo,day]=DOYtoMoDay(dataArray{1},yy*ones(size(dataArray{1})));
    
    dataArray{2}=mo*1000000+day*10000+yy;
    for i=3:size(dataArray,2)
        dataArray{i}=nan(size(dataArray{1}));
        
    end
end


%% Close the text file.
fclose(fileID);
yy=mod(dataArray{2},10000);
mm=mod(floor(dataArray{2}/10000),100);
dd=floor(dataArray{2}/1000000);
TIME=datenum(yy,mm,dd);
save([filename '.mat'],'TIME');

%% Post processing for unimportable data.
for i=1:length(H)
    eval([H{i} '=dataArray{i};']);
    save([filename '.mat'],H{i},'-append'); 
end
status=true;