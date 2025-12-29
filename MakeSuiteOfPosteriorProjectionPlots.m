%Must have run runPosteriors.m and bootstrapPosterior.m first
%% Projection Plot
baseDir='C:/Users/thmor/OneDrive - SUNY ESF/Documents/Publications/2022_Equifinality/CodesAndFigs_03092023/';

dataLoc =[baseDir 'Equifinality_MCMC/'];
dataLoc2=[baseDir 'Equifinality_MCMC_10PER/'];

yList=2010:2099;

load([dataLoc2 'BootstrappedProjectionW.mat'],...
    'DISCHG_proj_med','DISCHG_proj_95_bds','DISCHG_proj_N',...
    'ET_proj_med','ET_proj_95_bds',...
    'RUNOFF_proj_med','RUNOFF_proj_95_bds',...
    'WTR_STRESS_proj_med','WTR_STRESS_proj_95_bds',...
    'WTR_TBL_proj_med','WTR_TBL_proj_95_bds',...
    'TRANSPN_proj_med','TRANSPN_proj_95_bds',...
    'TIME','DTIME');

load([dataLoc2 'BootstrappedProjectionC.mat'],...
    'AUTO_RESP_proj_med','AUTO_RESP_proj_95_bds',...
    'CAN_HT_proj_med','CAN_HT_proj_95_bds',...
    'CO2_FLUX_proj_med','CO2_FLUX_proj_95_bds',...
    'ECO_AGB_proj_med','ECO_AGB_proj_95_bds',...
    'ECO_GPP_proj_med','ECO_GPP_proj_95_bds',...
    'ECO_LAI_proj_med','ECO_LAI_proj_95_bds',...
    'ECO_NPP_proj_med','ECO_NPP_proj_95_bds',...
    'ECO_RA_proj_med','ECO_RA_proj_95_bds',...
    'ECO_RH_proj_med','ECO_RH_proj_95_bds',...
    'GPP_proj_med','GPP_proj_95_bds',...
    'LAI_proj_med','LAI_proj_95_bds',...
    'NBP_proj_med','NBP_proj_95_bds',...
    'SUBS_DIC_FLUX_proj_med','SUBS_DIC_FLUX_proj_95_bds',...
    'SUBS_DOC_FLUX_proj_med','SUBS_DOC_FLUX_proj_95_bds',...
    'SURF_DIC_FLUX_proj_med','SURF_DIC_FLUX_proj_95_bds',...
    'SURF_DOC_FLUX_proj_med','SURF_DOC_FLUX_proj_95_bds',...
    'LITTER_C_proj_med','LITTER_C_proj_95_bds');

DISCHG_10_med=DISCHG_proj_med;          DISCHG_10_95=DISCHG_proj_95_bds;  l_N=DISCHG_proj_N(1);
ET_10_med=ET_proj_med;                  ET_10_95=ET_proj_95_bds;
RUNOFF_10_med=RUNOFF_proj_med;          RUNOFF_10_95=RUNOFF_proj_95_bds;
WTR_STRESS_10_med=WTR_STRESS_proj_med;  WTR_STRESS_10_95=WTR_STRESS_proj_95_bds;
WTR_TBL_10_med=WTR_TBL_proj_med;        WTR_TBL_10_95=WTR_TBL_proj_95_bds;
TRANSPN_10_med=TRANSPN_proj_med;        TRANSPN_10_95=TRANSPN_proj_95_bds;

AUTO_RESP_10_med=AUTO_RESP_proj_med;    AUTO_RESP_10_95=AUTO_RESP_proj_95_bds;
CAN_HT_10_med=CAN_HT_proj_med;          CAN_HT_10_95=CAN_HT_proj_95_bds;
CO2_FLUX_10_med=CO2_FLUX_proj_med;      CO2_FLUX_10_95=CO2_FLUX_proj_95_bds;
ECO_AGB_10_med=ECO_AGB_proj_med;        ECO_AGB_10_95=ECO_AGB_proj_95_bds;
ECO_GPP_10_med=ECO_GPP_proj_med;        ECO_GPP_10_95=ECO_GPP_proj_95_bds;
ECO_LAI_10_med=ECO_LAI_proj_med;        ECO_LAI_10_95=ECO_LAI_proj_95_bds;
ECO_NPP_10_med=ECO_NPP_proj_med;        ECO_NPP_10_95=ECO_NPP_proj_95_bds;
ECO_RA_10_med=-ECO_RA_proj_med;      	ECO_RA_10_95=-ECO_RA_proj_95_bds;
ECO_RH_10_med=-ECO_RH_proj_med;          ECO_RH_10_95=-ECO_RH_proj_95_bds;
GPP_10_med=GPP_proj_med;                GPP_10_95=GPP_proj_95_bds;
LAI_10_med=LAI_proj_med;                LAI_10_95=LAI_proj_95_bds;
NBP_10_med=NBP_proj_med;                NBP_10_95=NBP_proj_95_bds;
SUBS_DIC_10_med=SUBS_DIC_FLUX_proj_med;      SUBS_DIC_10_95=SUBS_DIC_FLUX_proj_95_bds;
SUBS_DOC_10_med=SUBS_DOC_FLUX_proj_med;      SUBS_DOC_10_95=SUBS_DOC_FLUX_proj_95_bds;
SURF_DIC_10_med=SURF_DIC_FLUX_proj_med;      SURF_DIC_10_95=SURF_DIC_FLUX_proj_95_bds;
SURF_DOC_10_med=SURF_DOC_FLUX_proj_med;      SURF_DOC_10_95=SURF_DOC_FLUX_proj_95_bds;
LITTER_C_10_med=LITTER_C_proj_med;      LITTER_C_10_95=LITTER_C_proj_95_bds;
    
load([dataLoc 'BootstrappedProjectionW.mat'],...
    'DISCHG_proj_med','DISCHG_proj_95_bds','DISCHG_proj_N',...
    'ET_proj_med','ET_proj_95_bds',...
    'RUNOFF_proj_med','RUNOFF_proj_95_bds',...
    'WTR_STRESS_proj_med','WTR_STRESS_proj_95_bds',...
    'WTR_TBL_proj_med','WTR_TBL_proj_95_bds',...
    'TRANSPN_proj_med','TRANSPN_proj_95_bds',...
    'TIME','DTIME');

load([dataLoc 'BootstrappedProjectionC.mat'],...
    'AUTO_RESP_proj_med','AUTO_RESP_proj_95_bds',...
    'CAN_HT_proj_med','CAN_HT_proj_95_bds',...
    'CO2_FLUX_proj_med','CO2_FLUX_proj_95_bds',...
    'ECO_AGB_proj_med','ECO_AGB_proj_95_bds',...
    'ECO_GPP_proj_med','ECO_GPP_proj_95_bds',...
    'ECO_LAI_proj_med','ECO_LAI_proj_95_bds',...
    'ECO_NPP_proj_med','ECO_NPP_proj_95_bds',...
    'ECO_RA_proj_med','ECO_RA_proj_95_bds',...
    'ECO_RH_proj_med','ECO_RH_proj_95_bds',...
    'GPP_proj_med','GPP_proj_95_bds',...
    'LAI_proj_med','LAI_proj_95_bds',...
    'NBP_proj_med','NBP_proj_95_bds',...
    'SUBS_DIC_FLUX_proj_med','SUBS_DIC_FLUX_proj_95_bds',...
    'SUBS_DOC_FLUX_proj_med','SUBS_DOC_FLUX_proj_95_bds',...
    'SURF_DIC_FLUX_proj_med','SURF_DIC_FLUX_proj_95_bds',...
    'SURF_DOC_FLUX_proj_med','SURF_DOC_FLUX_proj_95_bds',...
    'LITTER_C_proj_med','LITTER_C_proj_95_bds');

DISCHG_b_med=DISCHG_proj_med;          DISCHG_b_95=DISCHG_proj_95_bds;  b_N=DISCHG_proj_N(1);
ET_b_med=ET_proj_med;                  ET_b_95=ET_proj_95_bds;
RUNOFF_b_med=RUNOFF_proj_med;          RUNOFF_b_95=RUNOFF_proj_95_bds;
WTR_STRESS_b_med=WTR_STRESS_proj_med;  WTR_STRESS_b_95=WTR_STRESS_proj_95_bds;
WTR_TBL_b_med=WTR_TBL_proj_med;        WTR_TBL_b_95=WTR_TBL_proj_95_bds;
TRANSPN_b_med=TRANSPN_proj_med;        TRANSPN_b_95=TRANSPN_proj_95_bds;

AUTO_RESP_b_med=AUTO_RESP_proj_med;    AUTO_RESP_b_95=AUTO_RESP_proj_95_bds;
CAN_HT_b_med=CAN_HT_proj_med;          CAN_HT_b_95=CAN_HT_proj_95_bds;
CO2_FLUX_b_med=CO2_FLUX_proj_med;      CO2_FLUX_b_95=CO2_FLUX_proj_95_bds;
ECO_AGB_b_med=ECO_AGB_proj_med;        ECO_AGB_b_95=ECO_AGB_proj_95_bds;
ECO_GPP_b_med=ECO_GPP_proj_med;        ECO_GPP_b_95=ECO_GPP_proj_95_bds;
ECO_LAI_b_med=ECO_LAI_proj_med;        ECO_LAI_b_95=ECO_LAI_proj_95_bds;
ECO_NPP_b_med=ECO_NPP_proj_med;        ECO_NPP_b_95=ECO_NPP_proj_95_bds;
ECO_RA_b_med=-ECO_RA_proj_med;          ECO_RA_b_95=-ECO_RA_proj_95_bds;
ECO_RH_b_med=-ECO_RH_proj_med;          ECO_RH_b_95=-ECO_RH_proj_95_bds;
GPP_b_med=GPP_proj_med;                GPP_b_95=GPP_proj_95_bds;
LAI_b_med=LAI_proj_med;                LAI_b_95=LAI_proj_95_bds;
NBP_b_med=NBP_proj_med;                NBP_b_95=NBP_proj_95_bds;
SUBS_DIC_b_med=SUBS_DIC_FLUX_proj_med;      SUBS_DIC_b_95=SUBS_DIC_FLUX_proj_95_bds;
SUBS_DOC_b_med=SUBS_DOC_FLUX_proj_med;      SUBS_DOC_b_95=SUBS_DOC_FLUX_proj_95_bds;
SURF_DIC_b_med=SURF_DIC_FLUX_proj_med;      SURF_DIC_b_95=SURF_DIC_FLUX_proj_95_bds;
SURF_DOC_b_med=SURF_DOC_FLUX_proj_med;      SURF_DOC_b_95=SURF_DOC_FLUX_proj_95_bds;
LITTER_C_b_med=LITTER_C_proj_med;       LITTER_C_b_95=LITTER_C_proj_95_bds;

makeComparisons=1;
if makeComparisons==1
vList={'NBP','ECO_GPP','ECO_RA','ECO_RH'};
uList={'gC m^{-2}','gC m^{-2}','gC m^{-2}','gC m^{-2}'};
labList={'NBP','GPP','RA','RH'};

txt1={'a)','c)','e)','g)'};
txt2={'b)','d)','f)','h)'};

[yy,mmm,dd]=datevec(DTIME);
yyList=unique(yy);

for i=1:length(vList)
    %% COMPARE THE TWO
    var=vList{i};
    unit=uList{i};
    
    
    tmp_med_b=eval([var '_b_med']);
    tmp_bds_b=eval([var '_b_95']);
    
    tmp_med_10=eval([var '_10_med']);
    tmp_bds_10=eval([var '_10_95']);
    
    
    med_b=nan(length(yyList),1);
    bds_b=nan(length(yyList),2);
    
    med_10=nan(length(yyList),1);
    bds_10=nan(length(yyList),2);
    
    t=nan(length(yyList),1);
    for j=1:length(yyList)
        ind=find(yy==yyList(j),1,'last');
        
        med_b(j)=tmp_med_b(ind);
        bds_b(j,:)=tmp_bds_b(ind,:);
        
        med_10(j)=tmp_med_10(ind);
        bds_10(j,:)=tmp_bds_10(ind,:);
        
        t(j)=yyList(j);
    end
    if i==1
        f1=figure();
        f1.Units='centimeters';
        f1.Position=[5 5 15 13]; %95 mm x 115 mm
        
        tPlot=tiledlayout(4,2);
        tPlot.TileSpacing='compact';
    end
    nexttile%    subplot(3,2,(i-1)*2+1);
    
    hold on;
    h_blue=fill([t;flipud(t)],[bds_b(:,1);flipud(bds_b(:,2))],'b','FaceAlpha',.2,'LineStyle','none');
    h1=plot(t,med_b,'b','LineWidth',2);
    
    h_red=fill([t;flipud(t)],[bds_10(:,1);flipud(bds_10(:,2))],'r','FaceAlpha',.2,'LineStyle','none');
    h3=plot(t,med_10,'r','LineWidth',2);

    set(gca,'FontSize',11);
    grid on;
    ylimPrior=get(gca,'ylim');
    
%     if i==1
        text(2022,(ylimPrior(2)-ylimPrior(1))*.9+ylimPrior(1),txt1{i},'FontSize',11);
%     else
%         text(2022,(ylimPrior(2)-ylimPrior(1))*.2+ylimPrior(1),txt1{i},'FontSize',11);
%     end
    ylim([ylimPrior(1) ylimPrior(2)]);
    
    if i==1
        labList{i}='NEE'
    end

    box on;
    ylabel([labList{i} ' (' unit ')'],'FontSize',11);
    if i==1
        lgd=legend([h1 h3 h_blue h_red],...
            'Baseline',...
            'Optimized Degraded',...
            'Baseline Ens. 95^{th} bds.',...
            'Opt. Deg. Ens. 95^{th} bds.',...
            'Location','NorthOutside','box','off','fontsize',11);
        lgd.NumColumns=2;
        set(lgd, 'Interpreter', 'tex')

        lgd.Layout.Tile='North';
    end
    
    xlim([t(1) t(end)]);
    if i<4
        xticklabels('');
    end
    
%     subplot(3,2,i*2);
    nexttile
    hold on;

    %fill([t;flipud(t)],[bds_b(:,1);flipud(bds_b(:,2))],'b','FaceAlpha',.2,'LineStyle','none');

    l1=plot(t,abs((med_b-med_10)./med_b)*100,'-k','LineWidth',2);
    
    base_bds=abs(bds_b (:,1)-bds_b (:,2));
    low_bds =abs(bds_10(:,1)-bds_10(:,2));
    bds_err=abs((base_bds-low_bds)./base_bds)*100;
    
    %l2=plot(t,bds_err,'--','Color','k','LineWidth',1);
    ylim([0 100]);
    box on;
    grid on;
    ylabel('Difference %','FontSize',11);
    xlim([t(1) t(end)]);
    
    text(2022,90,txt2{i});
    
    if i<4
        xticklabels('')
    end
    
    % if i==1
    %     leg=legend([l1 l2],'Mag. err.','Env. size err.','Location','NorthOutside','box','off');
    %     leg.FontSize=11;
    %     leg.NumColumns=2;
    % end
    % 
    set(gca,'FontSize',11);
end
saveas(f1,[baseDir 'CodesToMakeFigures/Figures/F5_' var '.png']);
print -dmeta;
print(f1,[baseDir 'CodesToMakeFigures/Figures/F5_' var '.emf'],'-dmeta')
end