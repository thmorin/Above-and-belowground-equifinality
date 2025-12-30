% Load in all the plots daily C. Plot the NBT over and over again on 10
% year cycle. Color for each 10 year cycle
clear;close;clc
dataLoc='./UMB_SPINUP_TEST/outputs/';
files=dir([dataLoc '01010*dc']);
j=1;
NEE_cat=[];
for i=1:length(files)
    readDailyEcosys([dataLoc files(i).name]);
    load([dataLoc files(i).name '.mat'])
    NEE_cat=[NEE_cat;CO2_FLUX];
    
    if mod(i,10)==0
        NEE_full(:,j)=NEE_cat;
        j=j+1;
        NEE_cat=[];
    end
end

x=10:10:360;

f1=figure();
f1.Units='centimeters';
f1.Position=[10 5 9.5 10];

hold on;
for i=1:size(NEE_full,2)
    box on;
    grid on;
    plot(x,NEE_full(1:36,i),'LineWidth',2);
end
xlabel('Day of year');
set(gca,'FontSize',11);
ylabel('Cumulative NEE (gC m^{-2})','FontSize',11);
l1=legend('Decade 1','Decade 2','Decade 3','Decade 4','Decade 5','Decade 6','Decade 7','Location','Best');
l1.FontSize=11;

datDir='./CodesToMakeFigures/Figures/';
saveas(f1,[datDir 'FA1_Spinup.png']);
print -dmeta;
print(f1,[datDir 'FA1_Spinup.emf'],'-dmeta')
