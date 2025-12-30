function status = readHourlyEcosys(filename, startRow, endRow)
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

% For more information, see the TEXTSCAN documentation.
formatSpec = '%8f%12f%8f';
for i=4:length(H)
    formatSpec=[formatSpec '%16f'];
end

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n','TreatAsEmpty','NaN');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

yy=mod(dataArray{2},10000);
mm=mod(floor(dataArray{2}/10000),100);
dd=floor(dataArray{2}/1000000);
hh=dataArray{3};
zip=zeros(size(hh));
TIME=datenum(yy,mm,dd,hh,zip,zip);
save([filename '.mat'],'TIME');

%% Post processing for unimportable data.
for i=1:length(H)
    eval([H{i} '=dataArray{i};']);
    save([filename '.mat'],H{i},'-append');
end
status=true;
