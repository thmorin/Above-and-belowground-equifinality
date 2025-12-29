%AGB and LAI figures made for the paper
clear;close;clc;
DataPath='C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\';
AddOns={'Equifinality_MCMC\','Equifinality_MCMC_10PER\'};


text_y_perc=90; %from bottom
text_x_perc=10;  %from left

for i=1:length(AddOns)
    FullPath=[DataPath AddOns{i} 'BootstrappedTrainingPeriod.mat'];
    
    load(FullPath);
    
    t=10:10:360;
    
    if i==1
        ECO_AGB_base=ECO_AGB_med;
        ECO_AGB_base_unc=ECO_AGB_95_bds;

        LAI_base=LAI_med;
        LAI_base_unc=LAI_95_bds;
    else
        ECO_AGB_low=ECO_AGB_med;
        ECO_AGB_low_unc=ECO_AGB_95_bds;
        
        LAI_low=LAI_med;
        LAI_low_unc=LAI_95_bds;
    end
end

x=linspace(datetime(2010,01,10),datetime(2018,12,31),length(ECO_AGB_base));

f1=figure();
f1.Units='centimeters';
f1.Position=[5 5 12.5 6.5];

t1=tiledlayout(1,2,'TileSpacing','tight');
nexttile
hold on;
h1=plot(x,ECO_AGB_base,'-b','LineWidth',2);
h_blue=fill([x fliplr(x)],[ECO_AGB_base_unc(:,1);flipud(ECO_AGB_base_unc(:,2))]','b','FaceAlpha',0.2,'LineStyle','none');

h2=plot(x,ECO_AGB_low,'-r','LineWidth',2);
h_red=fill([x fliplr(x)],[ECO_AGB_low_unc(:,1);flipud(ECO_AGB_low_unc(:,2))]','r','FaceAlpha',0.2,'Linestyle','none');
set(gca,'FontSize',11);
xticks([datetime(2011,1,1) datetime(2014,1,1) datetime(2017,1,1)]);

grid on;
box on;
ylabel('AGB (g m^{-2})','FontSize',11);
xlabel('Year','FontSize',11);
lgd=legend([h1 h2 h_blue h_red],...
    'Baseline',...
    'Optimized degraded',...
    'Baseline ensemble 95^{th} percentile',...
    'Degraded ensemble 95^{th} percentile',...
                          'Location','NorthOutside','box','off');
lgd.Layout.Tile='North';
lgd.NumColumns=2;
set(lgd, 'Interpreter', 'tex')

[ylims1]=get(gca,'ylim');
y1_min=ylims1(1);
y1_max=ylims1(2);
[xlims1]=get(gca,'xlim');
x1_min=xlims1(1);
x1_max=xlims1(2);

text_x=(x1_max-x1_min)*text_x_perc/100+x1_min;
text_y=(y1_max-y1_min)*text_y_perc/100+y1_min;

text(text_x,text_y,'a)','FontSize',11);

nexttile

hold on;

t=x;

plot(t,LAI_base,'-b','LineWidth',2);
fill([t fliplr(t)],[LAI_base_unc(:,1);flipud(LAI_base_unc(:,2))]','b','FaceAlpha',0.2,'LineStyle','none');

plot(t,LAI_low,'-r','LineWidth',2);
fill([t fliplr(t)],[LAI_low_unc(:,1);flipud(LAI_low_unc(:,2))]','r','FaceAlpha',0.2,'LineStyle','none');
grid on;
box on;
set(gca,'FontSize',11);
xticks([datetime(2011,1,1) datetime(2014,1,1) datetime(2017,1,1)]);

ylabel('LAI (--)','FontSize',11);

xlabel('Year','FontSize',11);

ylim([0 4.5]);

[ylims2]=get(gca,'ylim');
y2_min=ylims2(1);
y2_max=ylims2(2);
[xlims2]=get(gca,'xlim');
x2_min=xlims2(1);
x2_max=xlims2(2);



text_x=(x2_max-x2_min)*text_x_perc/100+x2_min;
text_y=(y2_max-y2_min)*text_y_perc/100+y2_min;

text(text_x,text_y,'b)','FontSize',11);


figDir='./Figures/';

saveas(f1,[figDir 'F4_LAIComparision.png']);
print -dmeta;
print(f1,[figDir 'F4_LAIComparision.emf'],'-dmeta')

