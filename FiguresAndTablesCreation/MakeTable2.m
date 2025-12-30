%% Point it towards the right spot
clear;close;clc
cd("C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023");

dataBaseline = './Equifinality_MCMC/';
dataDegOpt   = './Equifinality_MCMC_10PER/';

%% Load up the baseline and the optimized degraded
% load([dataBaseline 'UMB_UNC.mat'],'T','CO2');
AMF_data=importdata('AMF_US-UMB_BASE_HH_16-5.csv');

ts =strcmp(AMF_data.colheaders,'TIMESTAMP_END');
ust=strcmp(AMF_data.colheaders,'USTAR');
FC=strcmp(AMF_data.colheaders,'FC');
ind=(AMF_data.data(:,ts) < 201900000000 & AMF_data.data(:,ts) > 201000000000);

AMF_data.data=AMF_data.data(ind,:);
AMF_data.data(AMF_data.data==-9999)=nan;
AMF_data.data(AMF_data.data(:,ust)<0.15,FC)=nan;

T=reshape(AMF_data.data(:,ts),2,size(AMF_data.data,1)/2);
T=T(2,:)';
TS=datetime(floor(T/100000000),mod(floor(T/1000000),100),mod(floor(T/10000),100),mod(floor(T/100),100),mod(floor(T/1),100),zeros(78888,1));
CO2=mean(reshape(AMF_data.data(:,FC),2,size(AMF_data.data,1)/2),'omitnan')';

obs.CO2=-CO2; %Storing the variables form the observed set that I'm going to compare to.
obs.T=TS;

baselineModel=importdata([dataBaseline 'CO2_start.txt']);
base.CO2=baselineModel';

degradedOptimized=importdata([dataDegOpt 'CO2_start.txt']);
deg.CO2=degradedOptimized';

%Load up the optimized degraded
data_co2=importdata([dataDegOpt 'best_co2.dat']);
optD.CO2=median(data_co2)';

biasModVsReality  = mean(base.CO2 - obs.CO2 ,'omitnan');
biasDegVsBaseline = mean(deg.CO2  - base.CO2);
biasOptVsBaseline = mean(optD.CO2 - base.CO2);

rmseModVsReality  = sqrt(mean((base.CO2 - obs.CO2 ).^2,'omitnan'));
rmseDegVsBaseline = sqrt(mean((deg.CO2  - base.CO2).^2));
rmseOptVsBaseline = sqrt(mean((optD.CO2 - base.CO2).^2));

%R2 = (corr(obs.CO2, base.CO2))^2;
SSres = sum((obs.CO2 - base.CO2).^2,'omitnan');                % Residual sum of squares
SStot = sum((obs.CO2 - mean(base.CO2)).^2,'omitnan');          % Total sum of squares
R2_ModVsReality = 1 - SSres / SStot;

SSres = sum((base.CO2 - deg.CO2).^2);                % Residual sum of squares
SStot = sum((base.CO2 - mean(deg.CO2)).^2);          % Total sum of squares
R2_DegVsBaseline = 1 - SSres / SStot;

SSres = sum((base.CO2 - optD.CO2).^2);                % Residual sum of squares
SStot = sum((base.CO2 - mean(optD.CO2)).^2);          % Total sum of squares
R2_OptVsBaseline = 1 - SSres / SStot;

% Slope using polyfit (alternative to regress)
good=~isnan(obs.CO2)
p_ModVsReality = polyfit(obs.CO2(good), base.CO2(good), 1);
slope_ModVsReality  = p_ModVsReality(1);

p_DegVsBaseline = polyfit(base.CO2, deg.CO2, 1);
slope_DegVsBaseline  = p_DegVsBaseline(1);

p_OptVsBaseline = polyfit(base.CO2, optD.CO2, 1);
slope_OptVsBaseline  = p_OptVsBaseline(1);
minVal=-30;
maxVal= 50;

figure();
hold on;
plot(obs.T,obs.CO2,'LineWidth',0.01);
plot(obs.T,base.CO2,'LineWidth',0.01);
plot(obs.T,optD.CO2,'LineWidth',0.01);
plot(obs.T,deg.CO2,'LineWidth',0.01);
legend('Observation','Baseline','Optimized degraded','Degraded')

f1=figure();
f1.Units='Inches';
f1.Position=[5 5 6 3];
tiledlayout(1,3,'TileSpacing','Compact');

nexttile(1);
hold on;
scatter(obs.CO2,base.CO2,'k','filled')
plot([minVal maxVal],[minVal maxVal],'--','Color',[.5 .5 .5])

yhat=[minVal maxVal]*p_ModVsReality(1)+p_ModVsReality(2);
plot([minVal maxVal],yhat,'--','Color','r')

xlim([minVal maxVal]);
ylim([minVal maxVal]);

xlabel({'EC observations','(μmol m^{-2} s^{-1})'});
ylabel('Baseline model (μmol m^{-2} s^{-1})');

nexttile(2);
hold on;
scatter(base.CO2,deg.CO2,'k','filled')
plot([minVal maxVal],[minVal maxVal],'--','Color',[.5 .5 .5])

yhat=[minVal maxVal]*p_DegVsBaseline(1)+p_DegVsBaseline(2);
plot([minVal maxVal],yhat,'--','Color','r')

xlim([minVal maxVal]);
ylim([minVal maxVal]);

xlabel({'Baseline model','(μmol m^{-2} s^{-1})'});
ylabel('Degraded model (μmol m^{-2} s^{-1})');

nexttile(3);
hold on;
scatter(base.CO2,optD.CO2,'k','filled')
plot([minVal maxVal],[minVal maxVal],'--','Color',[.5 .5 .5])

yhat=[minVal maxVal]*p_OptVsBaseline(1)+p_OptVsBaseline(2);
plot([minVal maxVal],yhat,'--','Color','r')

xlim([minVal maxVal]);
ylim([minVal maxVal]);

xlabel({'Baseline model','(μmol m^{-2} s^{-1})'});
ylabel('Optimized degraded model (μmol m^{-2} s^{-1})');

fid=fopen('ModelMetrics','w');
fprintf(fid,'Pair1,Pair2,r2,RMSE,slope,bias\n');
fprintf(fid,'--,--,--,μmol m-2 s-1,--,μmol m-2 s-1\n');

fprintf(fid,'%s,%s,%0.05f,%0.03f,%0.05f,%0.03f\n','EC obs','Baseline'     ,R2_ModVsReality ,rmseModVsReality ,slope_ModVsReality ,biasModVsReality);
fprintf(fid,'%s,%s,%0.05f,%0.03f,%0.05f,%0.03f\n','Baseline','Degraded'   ,R2_DegVsBaseline,rmseDegVsBaseline,slope_DegVsBaseline,biasDegVsBaseline);
fprintf(fid,'%s,%s,%0.05f,%0.03f,%0.05f,%0.03f\n','Baseline','OptDegraded',R2_OptVsBaseline,rmseOptVsBaseline,slope_OptVsBaseline,biasOptVsBaseline);
fclose(fid);

