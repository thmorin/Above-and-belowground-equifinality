% Contains script for:
%Figure 3. Effects of reducing phloem conductance (perturbed scenario) and then parameter optimization of the perturbed scenario (optimized parameter scenario) on (a) NEENet ecosystem carbonexchange of , (b) RE, and (c) Gross primary productivity. The perturbed scenario showed strong reductions in GPP and RE,  with both estimates substantially outside of the 95th percentile envelope of the baseline case. After parametrization, the OP Scenario reproduces the median and 95th percentile bounds of the Baseline Scenario.
%No others - note up to date as of 8/11/2023
cd("C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\CodesToMakeFigures\");
addpath("C:\Users\thmor\OneDrive - SUNY ESF\Documents\MATLAB");
needToLoad=1; %Toggle this if you're doing quick iterations on this to tweak graphics. It will save significant time.
if needToLoad==1
    clear;close;clc
    needToLoad=1;
else
    clearvars -except CO2_start GPP_start RE_start data_co2 data_gpp data_re
    close;clc
    needToLoad=0;
end
addOns={'../Equifinality_MCMC/','../Equifinality_MCMC_10PER/'};

for jj=2:2
% jj=1;
dataLoc=addOns{jj};

if needToLoad==1
    data_st=importdata([dataLoc 'CO2_start.txt']);
    CO2_start=data_st;

    data_st=importdata([dataLoc 'GPP_start.txt']);
    GPP_start=data_st;

    data_st=importdata([dataLoc 'RE_start.txt']);
    RE_start=data_st;
end
%data_st=importdata([dataLoc 'LE_start.txt']);
%LE_start=data_st;

load('C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\Equifinality_MCMC\UMB_UNC.mat');

t=(datetime(2010,01,01,1,0,0):hours(1):datetime(2018,12,31,24,0,0))';
[yy,mm,dd,hh]=datevec(t);

if needToLoad==1
    data_co2=importdata([dataLoc 'best_co2.dat']);
    data_gpp=importdata([dataLoc 'best_gpp.dat']);
    data_re=importdata([dataLoc 'best_re.dat']);
end

CO2_med_plot=nan(1,24);
CO2_95_bds_plot=nan(2,24);
CO2_mean_plot=nan(1,24);
CO2_std_2_plot=nan(1,24);

GPP_med_plot=nan(1,24);
GPP_95_bds_plot=nan(2,24);
GPP_mean_plot=nan(1,24);
GPP_std_2_plot=nan(1,24);

RE_med_plot=nan(1,24);
RE_95_bds_plot=nan(2,24);
RE_mean_plot=nan(1,24);
RE_std_2_plot=nan(1,24);



load('C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\BootstrappedTrainingPeriod.mat',...
    'EVAP_full','LE_full');

% LE_full in units W/m2
% EVAP_full in units mm h-1

HeatOfVap=2257; %J/g
densWat=1000*1000; %g/m3

convFact=1/HeatOfVap/densWat*1000*60*60;
ET_full=LE_full*convFact; %mm/h
T_full=ET_full-EVAP_full;

EVAP_full_base=EVAP_full;

EVAP_start_base=ET_full(:,1);
T_full_base=T_full(:,1);

load('C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\BootstrappedTrainingPeriod_10PER.mat',...
    'EVAP_full','LE_full');

ET_full=LE_full*convFact; %mm/h
T_full=ET_full-EVAP_full;

EVAP_full_low=EVAP_full;

EVAP_start=EVAP_full';
ET_full_low=ET_full;
T_full_low=T_full;


T_start=T_full(:,1)';
E_start=EVAP_start(1,:);

for mmm=1:3
    if mmm==1
        mm_ind=7;
    elseif mmm==2
        mm_ind=8;
    elseif mmm==3
        mm_ind=9;
    end
for i=0:23
    ind =yy==2018 & mm==mm_ind & hh==i;
    ind2=yy==2018 & mm==mm_ind & hh==i &dd==11;
    ind3=yy==2018 & mm==mm_ind & hh==i;
    
    tmp_co2=reshape(data_co2(:,ind==1),sum(ind)*size(data_co2,1),1);
    CO2_med_plot(:,i+1)=median(tmp_co2,"omitnan");
    CO2_95_bds_plot(:,i+1)=prctile(tmp_co2,[2.5 97.5]);
    CO2_mean_plot(:,i+1)=mean(tmp_co2,"omitnan");
    CO2_std_2_plot(:,i+1)=std(tmp_co2,"omitnan");    
    
    tmp_gpp=reshape(data_gpp(:,ind==1),sum(ind)*size(data_gpp,1),1);
    GPP_med_plot(:,i+1)=median(tmp_gpp,"omitnan");
    GPP_95_bds_plot(:,i+1)=prctile(tmp_gpp,[2.5 97.5]);
    GPP_mean_plot(:,i+1)=mean(tmp_gpp,"omitnan");
    GPP_std_2_plot(:,i+1)=std(tmp_gpp,"omitnan");

    tmp_re=reshape(data_re(:,ind==1),sum(ind)*size(data_re,1),1);
    RE_med_plot(:,i+1)=median(tmp_re,"omitnan");
    RE_95_bds_plot(:,i+1)=prctile(tmp_re,[2.5 97.5]);
    RE_mean_plot(:,i+1)=mean(tmp_re,"omitnan");
    RE_std_2_plot(:,i+1)=std(tmp_re,"omitnan");    
    
    
    tmp_EVAP=reshape(EVAP_full_base(ind2==1,:),sum(ind2)*size(EVAP_full_base,2),1);
    EVAP_med_plot_base(:,i+1)=median(tmp_EVAP,"omitnan");
    EVAP_SD_plot_base(:,i+1)=std(tmp_EVAP,"omitnan");
    
    tmp_T=reshape(T_full_base(ind3==1,:),sum(ind3)*size(T_full_base,2),1);
    T_med_plot_base(:,i+1)=median(tmp_T,"omitnan");
    T_SD_plot_base(:,i+1)=std(tmp_T,"omitnan");
    
    CO2_start_tmp(i+1)=mean(CO2_start(:,ind==1),"omitnan");
    GPP_start_tmp(i+1)=mean(GPP_start(:,ind==1),"omitnan");
    RE_start_tmp(i+1)=mean(RE_start(:,ind==1),"omitnan");
    T_start_tmp(i+1)=mean(T_start(:,ind==1),"omitnan");
    EVAP_start_tmp(i+1)=mean(E_start(:,ind==1),"omitnan");


    CO2_tmp(i+1)=mean(CO2(ind==1),"omitnan");
    CO2_SD_tmp(i+1)=mean(CO2_SD(ind==1),"omitnan");
    
    GPP_tmp(i+1)=mean(GPP(ind==1),"omitnan");
    GPP_SD_tmp(i+1)=mean(GPP_SD(ind==1),"omitnan");
    
    RE_tmp(i+1)=mean(RE(ind==1),"omitnan");
    RE_SD_tmp(i+1)=mean(RE_SD(ind==1),"omitnan");
    
    
    tmp_EVAP=reshape(EVAP_full_low(ind2==1,:),sum(ind2)*size(EVAP_full_low,2),1);
    EVAP_med_plot_low(:,i+1)=median(tmp_EVAP,"omitnan");
    EVAP_SD_plot_low(:,i+1)=std(tmp_EVAP,"omitnan");
    
    tmp_T=reshape(T_full_low(ind3==1,:),sum(ind3)*size(T_full_low,2),1);
    T_med_plot_low(:,i+1)=median(tmp_T,"omitnan");
    T_SD_plot_low(:,i+1)=std(tmp_T,"omitnan");
end

CO2_start_plot=CO2_start_tmp;
GPP_start_plot=GPP_start_tmp;
RE_start_plot=RE_start_tmp;
EVAP_start_plot=EVAP_start_tmp;
T_start_plot=T_start_tmp;

CO2_plot=CO2_tmp;
CO2_SD_plot=CO2_SD_tmp;

RE_plot=RE_tmp;
RE_SD_plot=RE_SD_tmp;

GPP_plot=GPP_tmp;
GPP_SD_plot=GPP_SD_tmp;

T2=datetime(T,'ConvertFrom','datenum');

if mmm==1
    f1=figure();
    f1.Units='centimeters';
    f1.Position=[5 5 13 18];
    
    t=tiledlayout(5,3,'TileSpacing','none');
%     t.TileIndexing = 'columnmajor';
end

if mmm==1
    nexttile(7)
elseif mmm==2
    nexttile(8);
elseif mmm==3
    nexttile(9);
end
hold on;




T2=0:23;
T_out2=0:23;
    
h_blue=fill([T2 fliplr(T2)],-[(CO2_plot+CO2_SD_plot) fliplr(CO2_plot-CO2_SD_plot)],'b','FaceAlpha',0.2,'LineStyle','none');
h_red=fill([T_out2 fliplr(T_out2)],-[CO2_med_plot+CO2_std_2_plot fliplr(CO2_med_plot-CO2_std_2_plot)],'r','FaceAlpha',0.2,'LineStyle','none');
h1=plot(T2,-CO2_plot,'-b','LineWidth',2);
h3=plot(T_out2,-CO2_start_plot,'-k','LineWidth',2);
h4=plot(T_out2,-CO2_med_plot,'-r','LineWidth',2);hold on;

% h5=plot(T_out2,CO2_95_bds(1,:),'--r');
% plot(T_out2,CO2_95_bds(2,:),'--r');
box on;
grid on;
set(gca,'FontSize',10);
xlim([0 24]);
xticks([0 10 20]);
xticklabels('');
ylim([-28 8]);




if mmm==1
    ylabel({'NEE','(μmol m^{-2} s^{-1})'},'FontSize',10);
else
    yticklabels('');
end
if mmm==1
    text(2,-3,'g)','FontSize',10);
elseif mmm==2
    text(2,-3,'h)','FontSize',10);
else
    text(2,-3,'i)','FontSize',10);
end

%% Respiration subplot
% subplot(3,2,mmm+2);
if mmm==1
    nexttile(4)
elseif mmm==2
    nexttile(5);
else
    nexttile(6)
end

% subplot_tight(3,2,mmm+2,[0.1]);
hold on;

fill([T2 fliplr(T2)],-[(RE_plot+RE_SD_plot) fliplr(RE_plot-RE_SD_plot)],'b','FaceAlpha',0.2,'LineStyle','none');
fill([T_out2 fliplr(T_out2)],-[RE_med_plot+RE_std_2_plot fliplr(RE_med_plot-RE_std_2_plot)],'r','FaceAlpha',0.2,'LineStyle','none');

h1=plot(T2,-RE_plot,'-b','LineWidth',2);
h3=plot(T_out2,-RE_start_plot,'-k','LineWidth',2);
h4=plot(T_out2,-RE_med_plot,'-r','LineWidth',2);hold on;

ylim([0 4.5])
box on;
grid on;
set(gca,'FontSize',10);
xlim([0 24]);
xticks([0 10 20]);
xticklabels('');

if mmm==1
    ylabel({'R_E','(μmol m^{-2} s^{-1})'},'FontSize',10);
else
    yticklabels('');
end

set(gca,'FontSize',10);
% xticks('');

if mmm==1
    text(2,4,'d)','FontSize',10);
elseif mmm==2
    text(2,4,'e)','FontSize',10);
else
    text(2,4,'f)','FontSize',10);
end


% subplot(3,2,mmm);
% subplot_tight(3,2,mmm+4,[0.1]);
% nexttile(mmm+4) %Needs to be 1 and 4
if mmm==1
    nexttile(1)
elseif mmm==2
    nexttile(2);
else
    nexttile(3);
end
hold on;


fill([T2 fliplr(T2)],[(GPP_plot+GPP_SD_plot) fliplr(GPP_plot-GPP_SD_plot)],'b','FaceAlpha',0.2,'LineStyle','none');
fill([T_out2 fliplr(T_out2)],[GPP_med_plot+GPP_std_2_plot fliplr(GPP_med_plot-GPP_std_2_plot)],'r','FaceAlpha',0.2,'LineStyle','none');

h1=plot(T2,GPP_plot,'-b','LineWidth',2);
h3=plot(T_out2,GPP_start_plot,'-k','LineWidth',2);
h4=plot(T_out2,GPP_med_plot,'-r','LineWidth',2);hold on;

set(gca,'FontSize',10);
box on;
grid on;
xlim([0 24]);
ylim([0 35]);
if mmm==1
    ylabel({'GPP','(μmol m^{-2} s^{-1})'},'FontSize',10);
    title('July');
elseif mmm==2
    yticklabels('');
    title('Aug.');
else
    yticklabels('');
    title('Sept.');
end
xticks([0 10 20]);
xticklabels('');

if mmm==1
    text(2,25,'a)','FontSize',10);
elseif mmm==2
    text(2,25,'b)','FontSize',10);
else
    text(2,25,'c)','FontSize',10);
end


%% Evaporation plots
if mmm==1
    nexttile(10)
elseif mmm==2
    nexttile(11);
else
    nexttile(12);
end
hold on;
fill([T2 fliplr(T2)],[(EVAP_med_plot_base+EVAP_SD_plot_base) fliplr(EVAP_med_plot_base-EVAP_SD_plot_base)],'b','FaceAlpha',0.2,'LineStyle','none');
fill([T2 fliplr(T2)],[(EVAP_med_plot_low +EVAP_SD_plot_low ) fliplr(EVAP_med_plot_low -EVAP_SD_plot_low )],'r','FaceAlpha',0.2,'LineStyle','none');
h1=plot(T_out2,EVAP_med_plot_base,'-b','LineWidth',2);
h3=plot(T_out2,EVAP_start_plot,'-k','LineWidth',2);
h4=plot(T_out2,EVAP_med_plot_low,'-r','LineWidth',2);

set(gca,'FontSize',10);
box on;
grid on;
xlim([0 24]);
ylim([-0.03 0.06]);
if mmm==1
    ylabel({'E','(mm h^{-1})'},'FontSize',10);
%     title('July');
else
    yticklabels('');
%     title('Sept.');
end
% xticks([0 10 20]);
xticklabels('');
% xlabel('Hrs of day','FontSize',11);

if mmm==1
    text(2,.015,'j)','FontSize',10);
elseif mmm==2
    text(2,.015,'k)','FontSize',10);
else
    text(2,.015,'l)','FontSize',10);
end




%% Transpiration plots
if mmm==1
    nexttile(13)
elseif mmm==2
    nexttile(14);
else
    nexttile(15);
end
hold on;
fill([T2 fliplr(T2)],[(T_med_plot_base+T_SD_plot_base) fliplr(T_med_plot_base-T_SD_plot_base)],'b','FaceAlpha',0.2,'LineStyle','none');
fill([T2 fliplr(T2)],[(T_med_plot_low +T_SD_plot_low ) fliplr(T_med_plot_low -T_SD_plot_low )],'r','FaceAlpha',0.2,'LineStyle','none');
h1=plot(T_out2,T_med_plot_base,'-b','LineWidth',2);
h3=plot(T_out2,T_start_plot,'-k','LineWidth',2);
h4=plot(T_out2,T_med_plot_low,'-r','LineWidth',2);

set(gca,'FontSize',10);
box on;
grid on;
xlim([0 24]);
ylim([-0.7 0.2]);
if mmm==1
    ylabel({'T','(mm h^{-1})'},'FontSize',10);
%     title('July');
else
    yticklabels('');
%     title('Sept.');
end
xticks([0 10 20]);
% xticklabels('');
xlabel('Hour of day','FontSize',10);

if mmm==1
    text(2,-.4,'m)','FontSize',10);
elseif mmm==2
    text(2,-.4,'n)','FontSize',10);
else
    text(2,-.4,'o)','FontSize',10);
end





%% Add the legend. Should always be for the bottom plots
if mmm==1
    lgd=legend([h1 h3 h4 h_blue h_red], ...
                          'Baseline S.R.',...
                          'Degraded S.R. ',...
                          'Optimized degraded S.R.',...
                          'Baseline ensemble 95^{th} perc.',...
                          'Degraded ensemble 95^{th} perc.',...
                          'Location','SouthOutside');
    lgd.NumColumns=2;
    lgd.Layout.Tile = 'south';  % anchor it properly to full layout
    lgd.Box = 'off';
    lgd.FontSize=10;
    set(lgd, 'Interpreter', 'tex')
end

end
figDir='./Figures/';
saveas(f1,[figDir 'F2_CO2_before_and_after_10PER.png'])
print -dmeta;
print(f1,[figDir 'F2_CO2_before_and_after_10PER.emf'],'-dmeta')
end