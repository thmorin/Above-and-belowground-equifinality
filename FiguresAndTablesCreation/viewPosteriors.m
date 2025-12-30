cd('C:/Users/thmor/OneDrive - SUNY ESF/Documents/Publications/2022_Equifinality/CodesAndFigs_03092023/CodesToMakeFigures/');
clear;close;clc

dataLoc='../Equifinality_MCMC_10PER/';

% Update as of 03/31/2022
% Be sure you've used runPosteriors.m first!
% Then run collatePosteriors.m

data=importdata([dataLoc 'best_params.dat']);

vars=5;

f1=figure();
f1.Units='centimeters';
f1.Position=[10 5 19 12];
t=tiledlayout(5,5);
t.TileSpacing='compact';
t.Padding='compact';
for i=1:vars
    if i==1
        ii=1;
    elseif i==2
        ii=7;
    elseif i==3
        ii=13;
    elseif i==4
        ii=19;
    elseif i==5
        ii=25;
    end
    nexttile(ii);
    
    histogram(data(:,i+2));
    set(gca,'FontSize',10);
    if i==1
        xlim([-3 3]);
        xticks([-3 0 3]);
        binEdgeY=linspace(-3,3,11);
    elseif i==2
        xlim([-1 1]);
        xticks([-1 0 1]);
        binEdgeY=linspace(-1,1,11);
    elseif i==3
        xlim([-.3 .3]);
        xticks([-.3 0 .3]);
        binEdgeY=linspace(-.3,.3,11);
    elseif i==4
        xlim([-.5 .5]);
        xticks([-.5 0 .5]);
        binEdgeY=linspace(-.5,.5,11);
    else 
        xlim([-.5 .5]);
        xticks([-.5 0 .5]);
        binEdgeY=linspace(-.5,.5,11);
    end
    
    if i==5
        yticklabels([]);
    else
        xticklabels([]);
        yticklabels([]);
    end

    if i==1
        ylabel('K_m','FontSize',10);
    elseif i==5
        xlabel('K_{CO2}','FontSize',10)
    end

    for j=1:i-1
        if j==1
            binEdgeX=linspace(-3,3,11);
        elseif j==2
            binEdgeX=linspace(-1,1,11);
        elseif j==3
            binEdgeX=linspace(-.3,.3,11);
        elseif j==4
            binEdgeX=linspace(-.5,.5,11);
        else
            binEdgeX=linspace(-.5,.5,11);
        end
        jj=ii-i+j;
        
        nexttile(jj);
        h=histogram2(data(:,j+2),data(:,i+2),'FaceColor','flat','ShowEmptyBins','on','EdgeColor','none');
        view(2);
        
        if j==1
            xlim([-3 3]);
            xticks([-3 0 3]);
        elseif j==2
            xlim([-1 1]);
            xticks([-1 0 1]);
        elseif j==3
            xlim([-.3 .3]);
            xticks([-.3 0 .3]);
        elseif j==4
            xlim([-.5 .5]);
            xticks([-.5 0 .5]);
        else 
            xlim([-.5 .5]);
            xticks([-.5 0 .5]);
        end
        if i==1
            ylim([-3 3]);
            yticks([-3 0 3]);
        elseif i==2
            ylim([-1 1]);
            yticks([-1 0 1]);
        elseif i==3
            ylim([-.3 .3]);
            yticks([-.3 0 .3]);
        elseif i==4
            ylim([-.5 .5]);
            yticks([-.5 0 .5]);
        elseif i==5
            ylim([-.5 .5]);
            yticks([-.5 0 .5]);
        end
        
        
        if j>1
            yticklabels([]);
        end
        if i<5
            xticklabels([]);
        else
            if j==1
                xlabel('K_m','FontSize',10)
            elseif j==2
                xlabel('µ_{max}','FontSize',10)
            elseif j==3
                xlabel('V_{c,max}','FontSize',10)
            elseif j==4
                xlabel('\Psi_{max}','FontSize',10)
            end
        end
        
        if i==2
            ylabel('µ_{max}','FontSize',10);
        elseif i==3 && j==1
            ylabel('V_{c,max}','FontSize',10);
        elseif i==4 && j==1
            ylabel('\Psi_{max}','FontSize',10);
        elseif i==5 && j==1
            ylabel('K_{CO2}','FontSize',10)
        end
        set(gca,'FontSize',10);
        set(gca,'color',[0.2422    .1504    0.6603]);
    end
end
dataDir='./Figures/';
saveas(f1,[dataDir 'F3_Histogram.png'])
print -dmeta;
print(f1,[dataDir 'F3_Histogram.emf'],'-dmeta')