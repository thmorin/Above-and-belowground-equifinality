clear;close;clc
% cd /home/thmorin/
cd("C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\");
dataLocVec={'./Equifinality_MCMC/','./Equifinality_MCMC_10PER/'};

load('./Equifinality_MCMC/UMB_UNC.mat');
for jj=1:length(dataLocVec)
    dataLoc=dataLocVec{jj};
    pref='';
    % Boot strapping the posterior
    f=dir([dataLoc 'posterior_*']);
    yList=2010:2018;
    GPP_full=[];RE_full=[];CO2_full=[];LE_full=[];sll_re_full=[];sll_gpp_full=[];
    for j=1:length(f)
        %fprintf('Started run %d\n',j);
        M_T=[];M_CO2=[];M_RE=[];M_GPP=[];M_LE=[];
        check_for=dir([dataLoc f(j).name '/outputs/010102099dc']);
        if ~isempty(check_for)
        for i=1:length(yList)
            fileName=sprintf([dataLoc pref f(j).name '/outputs/01010%dhc'],yList(i));
            readHourlyEcosys(fileName);
            load([fileName '.mat'],'ECO_CO2_FLUX','SOIL_CO2_FLUX','TIME');
            M_T=[M_T;TIME];
            M_CO2=[M_CO2;ECO_CO2_FLUX];
            M_RE=[M_RE;SOIL_CO2_FLUX];

            fileName=sprintf([dataLoc pref f(j).name '/outputs/01011%dhc'],yList(i));
            readHourlyEcosys(fileName);
            load([fileName '.mat'],'CAN_GPP');
            M_GPP=[M_GPP;0;diff(CAN_GPP)];

            fileName=sprintf([dataLoc pref f(j).name '/outputs/01010%dhh'],yList(i));
            readHourlyEcosys(fileName);
            load([fileName '.mat'],'ECO_LE');
            M_LE=[M_LE;ECO_LE];
        end
        GPP_full=[GPP_full M_GPP];
        RE_full=[RE_full smoothdata(M_RE)];
        LE_full=[LE_full M_LE];
        CO2_full=[CO2_full M_CO2];

        [yn,whereat]=ismember(M_T,T);
        T=T(whereat(yn==1));

        CO2=CO2(whereat(yn==1));
        CO2_SD=CO2_SD(whereat(yn==1));
        GPP=GPP(whereat(yn==1));
        GPP_SD=GPP_SD(whereat(yn==1));
        RE=RE(whereat(yn==1));
        RE_SD=RE_SD(whereat(yn==1));

        pd_co2_short=pd_CO2(whereat(yn==1));
        pd_gpp_short=pd_GPP(whereat(yn==1));
        pd_re_short =pd_RE (whereat(yn==1));

        lhood_CO2=nan(length(pd_co2_short),1);
        lhood_GPP=nan(length(pd_co2_short),1);
        lhood_RE =nan(length(pd_co2_short),1);

        for i=1:length(M_CO2)
            %lhood(i)=pdf(pd_short{i},M_CO2(i));
            peak_CO2=pdf(pd_co2_short{i},pd_co2_short{i}.mu);
            peak_GPP=pdf(pd_gpp_short{i},pd_gpp_short{i}.mu);
            peak_RE =pdf(pd_re_short {i},pd_re_short {i}.mu);

            lhood_CO2(i)=pdf(pd_co2_short{i},M_CO2(i))/peak_CO2;
            lhood_GPP(i)=pdf(pd_gpp_short{i},M_GPP(i))/peak_GPP;
            lhood_RE (i)=pdf(pd_re_short {i},M_RE (i))/peak_RE;
        end
        llhood_co2=log(lhood_CO2);
        llhood_co2(llhood_co2==-Inf)=-9999999;

        llhood_gpp=log(lhood_GPP);
        llhood_gpp(llhood_gpp==-Inf)=-9999999;

        llhood_re=log(lhood_RE);
        llhood_re(llhood_re==-Inf)=-9999999;

        [~,m,~,HH,~,~]=datevec(T);

        ind=(m>=6 & m<=8); %June-August
        sll_re=sum(llhood_re(ind))/length(llhood_re(ind));
        ind=(m>=6 & m<=8 & HH>=11 & HH<=16); %June-August, 11-4 PM
        sll_gpp=sum(llhood_gpp(ind))/sum(ind);



        sll_re_full=[sll_re_full sll_re];
        sll_gpp_full=[sll_gpp_full sll_gpp];

        end
        if mod(j,10)==0
            fprintf('%s %s Training posterior %d completed\n',dataLoc,pref,j);
        end
    end

    [~,I]=sort(sll_gpp_full);
    ind_runs=I(1:10);

    GPP_full=GPP_full(ind_runs);
    CO2_full=CO2_full(ind_runs);
    RE_full=RE_full(ind_runs);
    LE_full=LE_full(ind_runs);

    GPP_full=GPP_full/12/60/60*1000000;
    GPP_N=sum(~isnan(GPP_full),2);

    CO2_med=median(CO2_full,2);
    CO2_mean=mean(CO2_full,2);
    CO2_std=std(CO2_full,[],2);
    CO2_95_bds=prctile(CO2_full,[2.5 97.5],2);
    CO2_N=sum(~isnan(CO2_full),2);

    RE_med=median(RE_full,2);
    RE_mean=mean(RE_full,2);
    RE_std=std(RE_full,[],2);
    RE_95_bds=prctile(RE_full,[2.5 97.5],2);
    RE_N=sum(~isnan(RE_full),2);

    GPP_med=median(GPP_full,2);
    GPP_mean=mean(GPP_full,2);
    GPP_std=std(GPP_full,[],2);
    GPP_95_bds=prctile(GPP_full,[2.5 97.5],2);

    LE_med=median(LE_full,2);
    LE_mean=mean(LE_full,2);
    LE_std=std(LE_full,[],2);
    LE_95_bds=prctile(LE_full,[2.5 97.5],2);
    LE_N=sum(~isnan(LE_full),2);

    save([dataLoc pref 'BootstrappedTrainingPeriod.mat'],...
        'GPP_full','GPP_med','GPP_95_bds','GPP_mean','GPP_std','GPP_N',...
        'RE_full','RE_med','RE_95_bds','RE_mean','RE_std','RE_N',...
        'CO2_full','CO2_med','CO2_95_bds','CO2_mean','CO2_std','CO2_N',...
        'LE_med','LE_mean','LE_std','LE_95_bds','LE_N');

    clearvars -except r dataLoc yList pref dataLocVec jj kk ind_runs T CO2 CO2_SD ...
        GPP GPP_SD RE RE_SD pd_CO2 pd_GPP pd_RE ind_runs
end

%% Daily training period posterior


for jj=1:length(dataLocVec)
    CO2_full_l=[];
    pref='';
    f=dir([dataLoc 'posterior_*']);
    %% Training period loop
    for j=length(f)
        M_T_l=[];M_CO2_l=[];
        check_for=dir([dataLoc f(j).name '/outputs/010102099dc']);
        if ~isempty(check_for)
        for i=1:length(yList)
            fileName=sprintf([dataLoc  pref f(j).name '/outputs/01010%ddc'],yList(i));
            readDailyEcosys(fileName);
            load([fileName '.mat'],'CO2_FLUX','TIME');

            M_T_l=[M_T_l;TIME];
            M_CO2_l=[M_CO2_l;CO2_FLUX];
        end
        CO2_full_l=[CO2_full_l M_CO2_l];
        end
        if mod(j,10)==0
            fprintf('%s %s DAILY training posterior %d completed\n',dataLoc,pref,j);
        end
    end
    CO2_full=CO2_full_l;
    CO2_med=median(CO2_full_l,2);
    CO2_mean=mean(CO2_full_l,2);
    CO2_std=std(CO2_full_l,[],2);
    CO2_95_bds=prctile(CO2_full_l,[2.5 97.5],2);
    CO2_N=sum(~isnan(CO2_full_l),2);

    save([dataLoc pref 'DailyBootstrappedTrainingPeriod.mat'],...
        'CO2_full','CO2_med','CO2_95_bds','CO2_mean','CO2_std','CO2_N');
    clearvars -except r dataLoc yList kk jj dataLocVec ind_runs
end