%Contains script for:
%Figure 1. Daily average carbon flux of model (red) compared to those measured by the eddy covariance tower (blue). Model compares well in the summer but underestimates wintertime ecosystem respiration in our base case run.
%Figure 2. July diurnal flux dynamics for observed and modeled. Blue line is the daily observed average in July through the training period. Red line is ecosys daily average flux in July through the training period. As much of our cost function was based on summertime observations, the match during this period was the most important and we prioritized realistic results for this time of year above others.clear;close;clc
%Nothing else, as of 8/11/2023
%cd("C:/Users/thmorin/OneDrive - SUNY ESF/Documents/Publications/2022_Equifinality/CodesAndFigs_03092023/CodesToMakeFigures/")
cd("C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\CodesToMakeFigures");


% Load Ameriflux data - CO2
AMF = ImportUMBSAmeriflux('C:/Users/thmor/OneDrive - SUNY ESF/Documents/Publications/2022_Equifinality/CodesAndFigs_03092023/AMF_US-UMB_BASE_HH_16-5.csv');
AMF=standardizeMissing(AMF,-9999);
yy=floor(AMF.TIMESTAMP_END/100000000);
mm=mod(floor(AMF.TIMESTAMP_END/1000000),100);
dd=mod(floor(AMF.TIMESTAMP_END/10000),100);
hh=mod(floor(AMF.TIMESTAMP_END/100),100);
minut=mod(floor(AMF.TIMESTAMP_END/1),100);
zip=zeros(size(minut));
AMF.TIME=datenum(yy,mm,dd,hh,minut,zip);
% Load Ecosys data - CO2
dataDir='C:/Users/thmor/OneDrive - SUNY ESF/Documents/Publications/2022_Equifinality/CodesAndFigs_03092023/UMB_base/outputs/';
%dataDir='./SpinupTests/p1.0/s1900/';
files=dir([dataDir '0101020*hc']);
files2=dir([dataDir '0101020*hw']);
T=[];CO2=[];H2O=[];
for i=1:length(files)
    readHourlyEcosys([files(i).folder '/' files(i).name]);
    load([files(i).folder '/' files(i).name '.mat'],'TIME','ECO_CO2_FLUX');
    T=[T;TIME];
    CO2=[CO2;ECO_CO2_FLUX];
end

%compare July 2018

f2=figure();
f2.Units='centimeters';
f2.Position=[10 5 9.5 10];
tiledlayout(1,3,'TileSpacing','none');
for i=1:3
    nexttile
    if i==1
        ind = yy==2018 & mm==7;
        mm_ind=7;
        ndays=31;
        txtPan='a)';
        tltTxt='July';
    elseif i==2
        ind = yy==2018 & mm==8;
        ndays=31;
        mm_ind=8;
        txtPan='b)';
        tltTxt='Aug.';
    else
        ind = yy==2018 & mm==9;
        ndays=30;
        mm_ind=9;
        txtPan='c)';
        tltTxt='Sep.';
    end
sect=-AMF.NEE_PI(ind);
co2_diurn_obs=mean(reshape(sect,48,ndays),2,"omitnan");
co2_diurn_obs_95=prctile(reshape(sect,48,ndays),[2.5 97.5],2);

ind = T>datenum(2018,mm_ind,0) & T<=datenum(2018,mm_ind+1,0);
co2_diurn_mod=mean(reshape(CO2(ind),24,ndays),2,"omitnan");
co2_diurn_mod_95=prctile(reshape(CO2(ind),24,ndays),[2.5 97.5],2);

% subplot(1,3,i);
hold on;

x_obs=0.5:0.5:24;
x_mod=0:23;

h_gry=fill([x_obs fliplr(x_obs)]',-[co2_diurn_obs_95(:,1);flipud(co2_diurn_obs_95(:,2))],'k','FaceAlpha',.2,'LineStyle','none');
h_red=fill([x_mod fliplr(x_mod)]',-[co2_diurn_mod_95(:,1);flipud(co2_diurn_mod_95(:,2))],'r','FaceAlpha',.2,'LineStyle','none');

h1=plot(x_obs,-co2_diurn_obs,'k','LineWidth',2);
h2=plot(x_mod,-co2_diurn_mod,'col','r','LineWidth',2);

ylim([-45 20]);


title(tltTxt);
text(3,18,txtPan,'FontSize',10);

if i==1
    ylabel({'Monthly averaged hourly','NEE (μmol m^{-2} s^{-1})'},'FontSize',10)
else
    yticklabels({});
end
set(gca,'FontSize',10);
box on;
grid on;
if i==2
    xlabel('Time of day (h)');
end
if i==3
    lgd=legend([h1 h2 h_gry h_red],...
        'EC observed',...
        'Benchmark',...
        'EC 95^{th} perc.',...
        'Benchmark 95^{th} perc.',...
        'Location','South');
    lgd.NumColumns=2;
    lgd.Layout.Tile='south';
    set(lgd, 'Interpreter', 'tex')
    set(lgd,'Box','off')
end
if i==3
    uistack(lgd,'top')
end
xticks([0,6,12,18])
end

datDir='./Figures/';
saveas(f2,[datDir 'F1_DiurnalComparision.png']);
print -dmeta;
print(f2,[datDir 'F1_DiurnalComparision.emf'],'-dmeta')