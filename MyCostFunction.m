function [cost_function,M_CO2,M_RE,M_GPP]=MyCostFunction(chain_out,j,plotYN)
% Read shit
M_T=[];M_CO2=[];M_RE=[];M_GPP=[];
yList=2010:2018;
for i=1:length(yList)
    fileName=sprintf('./run%d/outputs/01010%dhc',j,yList(i));
    readHourlyEcosys(fileName);
    load([fileName '.mat'],'ECO_CO2_FLUX','SOIL_CO2_FLUX','TIME');
    M_T=[M_T;TIME];
    M_CO2=[M_CO2;ECO_CO2_FLUX];
    M_RE=[M_RE;SOIL_CO2_FLUX];
    
    fileName=sprintf('./run%d/outputs/01011%dhc',j,yList(i));
    readHourlyEcosys(fileName);
    load([fileName '.mat'],'CAN_GPP');
    M_GPP=[M_GPP;0;diff(CAN_GPP)];
end
M_RE=smoothdata(M_RE);
M_GPP=M_GPP/12/60/60*1000000; %Conversion to umol/m2/s
load('UMB_UNC.mat','T',...
    'pd_CO2','CO2','CO2_SD',...
    'pd_GPP','GPP','GPP_SD',...
    'pd_RE' ,'RE' ,'RE_SD');

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


load('Priors.mat','chain_priors');
cost_function=nan(length(chain_out),1);
for k=3:length(chain_out)
    [~,m,~,HH,~,~]=datevec(T);
    JPD=0; %Joint probability modifier for VCMAX and JMAX, which should vary log linearly
    if k==3 %OQKM cost function - only looks at soil carbon fluxes
        ind=(m>=6 & m<=8); %June-August
        sll=sum(llhood_re(ind))/length(llhood_re(ind));
    elseif k==4 % VMXO cost function
        ind=(m>=6 & m<=8); %June-August
        sll=sum(llhood_re(ind))/length(llhood_re(ind));
    elseif k==5 %VCMAX cost function - only daytimes
        ind=(m>=6 & m<=8 & HH>=11 & HH<=16); %June-August, 11-4 PM
        sll=sum(llhood_gpp(ind))/sum(ind);
        
        JMx_mod=.89*chain_out(5); %Log linear model from Walker. Slope given in Table 4. Graphic in Figure 3.
        peak_JPD=pdf('Normal',JMx_mod,JMx_mod,.1192);
        %Variance (below) from Walker. I got it by controlling for the linear slope and then looking for residual standard deviation. I didn't really get the full data though so might be off in reality
        JPD=log(pdf('Normal',chain_out(6),JMx_mod,.1192)/peak_JPD); %Slope and variation from Walker et all Photosynthetic Trait meta-analysis & modeling, Ecology and Evolution
    elseif k==6 %
        ind=(m>=6 & m<=8 & HH>=11 & HH<=16); %June-August, 11-4 PM
        sll=sum(llhood_gpp(ind))/sum(ind);
    elseif k==7 %XKCO2 cost function - only GPP daytimes in summer
        ind=(m>=6 & m<=8 & HH>=11 & HH<=16); %June-August, 11-4 PM
        sll=sum(llhood_gpp(ind))/sum(ind);
        
        JMx_mod=.89*chain_out(5); %Log linear model from Walker. Slope given in Table 4. Graphic in Figure 3.
        peak_JPD=pdf('Normal',JMx_mod,JMx_mod,.1192);
        %Variance (below) from Walker. I got it by controlling for the linear slope and then looking for residual standard deviation. I didn't really get the full data though so might be off in reality
        JPD=log(pdf('Normal',chain_out(6),JMx_mod,.1192)/peak_JPD); %Slope and variation from Walker et all Photosynthetic Trait meta-analysis & modeling, Ecology and Evolution
    elseif k==7 %ETMX cost function - only GPP daytimes in summer
        ind=(m>=6 & m<=8 & HH>=11 & HH<=16); %June-August, 11-4 PM
        sll=sum(llhood_gpp(ind))/sum(ind);
    elseif k==8 %DCKI cost function - only looks at soil carbon fluxes
        sll=sum(llhood_re)/length(llhood_re);
    end
    param_llhood=pdf(chain_priors{k},chain_out(k));
    fprintf('SLL from %d =%f\n',k,sll);
    fprintf('JPD from %d =%f\n',k,JPD);
    cost_function(k)=sll+param_llhood+JPD/2;
    %cost_function(k)=sll;
end


if plotYN==1
    f1=figure();
    f1.Units='Normalized';
    f1.Position=[0 0 1 1];
    subplot(2,1,1)
    plot(T,RE,'Color','k');
    hold on;
    plot(T,RE+RE_SD,'--','Color',[.5 .5 .5]);
    plot(T,RE-RE_SD,'--','Color',[.5 .5 .5]);
    
    plot(M_T,M_RE,'r');
    datetick('x');
    ylabel('RE (\mumol m^{-2} s^{-1})');
    
    subplot(2,1,2);
    plot(T,llhood_re);
    datetick('x');
end
