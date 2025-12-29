SaveLocForUnc='/home/thmorin/Equifinality_MCMC/';
BaseResultsLoc='/home/thmorin/Equifinality_MCMC/UMB_base/outputs/';
fnames=dir([BaseResultsLoc '01010201*hc']);
T=[];CO2=[];RE=[];
for i=1:length(fnames)
    readHourlyEcosys([fnames(i).folder '/' fnames(i).name]);
    load([fnames(i).folder '/' fnames(i).name '.mat'],'ECO_CO2_FLUX','SOIL_CO2_FLUX','TIME');
    T=[T;TIME];
    CO2=[CO2;ECO_CO2_FLUX];
    RE=[RE;SOIL_CO2_FLUX];
end
RE=smoothdata(RE);


GPP=[];
fnames=dir([BaseResultsLoc '01011201*hc']);
for i=1:length(fnames)
    readHourlyEcosys([fnames(i).folder '/' fnames(i).name]);
    load([fnames(i).folder '/' fnames(i).name '.mat'],'CAN_GPP');
    %T=[T;TIME];
    
    GPP=[GPP;0;diff(CAN_GPP)];%gC/m2/h
end
GPP=GPP/12/60/60*1000000; %Conversion to umol/m2/s

CO2=DeSpike(CO2,100,6,-9,100,1);
CO2=fillgaps(CO2);

GPP_SD=abs(GPP*.2);
GPP_SD(abs(GPP_SD)<1)=1;

RE_SD=abs(RE*.2);
%RE_SD(abs(RE_SD)<1)=1;

CO2_SD=abs(CO2*.2);
CO2_SD(abs(CO2_SD)<1)=1;

subplot(3,1,1);
plot(T,CO2-CO2_SD,'--','Color',[.5 .5 .5]);
hold on;
plot(T,CO2+CO2_SD,'--','Color',[.5 .5 .5]);
plot(T,CO2,'-r','LineWidth',2);
datetick('x');

subplot(3,1,2);
plot(T,GPP-GPP_SD,'--','Color',[.5 .5 .5]);
hold on;
plot(T,GPP+GPP_SD,'--','Color',[.5 .5 .5]);
plot(T,GPP,'-r','LineWidth',2);
datetick('x');

subplot(3,1,3);
plot(T,RE-RE_SD,'--','Color',[.5 .5 .5]);
hold on;
plot(T,RE+RE_SD,'--','Color',[.5 .5 .5]);
plot(T,RE,'-r','LineWidth',2);
datetick('x');

for i=1:length(CO2)
    if ~isnan(CO2(i))
        pd_CO2{i}=makedist('Normal','mu',CO2(i),'sigma',CO2_SD(i));
        pd_GPP{i}=makedist('Normal','mu',GPP(i),'sigma',GPP_SD(i));
        pd_RE {i}=makedist('Normal','mu',RE (i),'sigma',RE_SD (i));
    end
end

save([SaveLocForUnc 'UMB_UNC.mat'],'T',...
    'CO2','CO2_SD','pd_CO2',...
    'GPP','GPP_SD','pd_GPP',...
    'RE' ,'RE_SD' ,'pd_RE' );
