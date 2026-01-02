%% Read in the run file that you'll read the options and the weather files from
DataDir='../UMB_base/';
skipNum=5;
% Go grab shit fuck face
fid=fopen([DataDir 'run_usumb_short_proj']);
for i=1:skipNum
    fgetl(fid);
end
     
% Initialize storage
names = {}; % cell array to hold your strings
blockSize = 15;
blockNum = 1;
exitLoop=0;
while ~feof(fid)
    % Read 15 lines (or until EOF)
    block = cell(blockSize,1);
    for i = 1:blockSize
        line=fgetl(fid);
        if strcmp(line,'eor')==1
            exitLoop=1;
            break
        end
        block{i} = line;
    end
    if exitLoop==1
        break
    end
    % Grab lines 3 and 4 of the block (if they exist)
    if length(block) >= 4
        name1 = strtrim(block{2});
        name2 = strtrim(block{3});
        names{blockNum,1} = name1;
        names{blockNum,2} = name2;
        blockNum = blockNum + 1;
    end
end

TimeStamp=[];
MaxT=[];
Rad=[];
CO2=[];
Precip=[];
for i=1:size(names,1)
    WDat=csvread([DataDir names{i,1}],4);
    Opts=csvread([DataDir names{i,2}],6,0,[6,0,9,9]);
    
    doy=1:(size(WDat,1)/24);
    
    yy=str2double(names{i,2}(4:7))*ones(length(doy),1);
    [mm,dd]=DOYtoMoDay(doy,yy);

    TimeStamp=[TimeStamp;datetime(yy,mm,dd)];
    
    ind1=1:90;
    ind2=91:180;
    ind3=181:270;
    ind4=271:length(doy);

    BaseT=(max(reshape(WDat(:,5),24,size(WDat,1)/24)))';
    TShift=zeros(length(doy),1);
    TShift(ind1)=Opts(1,2);
    TShift(ind2)=Opts(2,2);
    TShift(ind3)=Opts(3,2);
    TShift(ind4)=Opts(4,2);
    MaxT=[MaxT;(BaseT+TShift)];

    BaseRad=(max(reshape(WDat(:,9),24,size(WDat,1)/24)))';
    RadMult=ones(length(doy),1);
    RadMult(ind1)=Opts(1,1);
    RadMult(ind2)=Opts(2,1);
    RadMult(ind3)=Opts(3,1);
    RadMult(ind4)=Opts(4,1);
    Rad=[Rad;(BaseRad.*RadMult)];
    
    BaseCO2=330*ones(length(doy),1); %330 is the value from the site file used
    CO2Mult=ones(length(doy),1);
    CO2Mult(ind1)=Opts(1,8);
    CO2Mult(ind2)=Opts(2,8);
    CO2Mult(ind3)=Opts(3,8);
    CO2Mult(ind4)=Opts(4,8);
    CO2=[CO2;(BaseCO2.*CO2Mult)];
    
    BasePrecip=(sum(reshape(WDat(:,8),24,size(WDat,1)/24)))';
    PrecipMult=ones(length(doy),1);
    PrecipMult(ind1)=Opts(1,8);
    PrecipMult(ind2)=Opts(2,8);
    PrecipMult(ind3)=Opts(3,8);
    PrecipMult(ind4)=Opts(4,8);

    %fprintf('Annual precip %03f mm\n',sum(BasePrecip.*PrecipMult));

    Precip=[Precip;(BasePrecip.*PrecipMult)];
end

fA3=figure();
fA3.Units="Inches";
fA3.Position=[2 2 4 4];

tPlot=tiledlayout(2,2);
tPlot.TileSpacing='compact';

nexttile
hold on;
plot(TimeStamp,CO2);
set(gca,'FontSize',10)
ylabel('CO_2 concentration (ppm)','FontSize',10)

nexttile
hold on;
plot(TimeStamp,Rad)
set(gca,'FontSize',10)
ylabel('Daily max radiation (W m^{-2})','FontSize',10)


nexttile
hold on;
plot(TimeStamp,MaxT)
set(gca,'FontSize',10)
ylabel('Daily max air temp (C)','FontSize',10)

nexttile
hold on;
plot(TimeStamp,Precip)
set(gca,'FontSize',10)
ylabel('Daily precip (mm)','FontSize',10)

saveas(fA3,'./Figures/FA3_ClimateForcing.png');
print -dmeta;
print( fA3,'./Figures/FA3_ClimateForcing.emf','-dmeta')