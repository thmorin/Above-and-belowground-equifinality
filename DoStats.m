function [r2,slope,bias,NRMSE]=DoStats(Model,Observed,plotYN)
if all(isnan(Model)) || all(isnan(Observed))
    r2=nan;
    slope=nan;
    bias=nan;
    NRMSE=nan;
else
    [p,~,~,~,stats]=regress(Model,[Observed ones(size(Observed))]);
    mod_resid=Model-Observed;
    slope=p(1); r2=stats(1);
    bias=nansum(mod_resid)/sum(~isnan(mod_resid));
    NRMSE=nansum(mod_resid.^2)/sum(~isnan(mod_resid))/nanmean(Observed);

    if plotYN==1
        figure();
        plot(Observed,Model,'.');
        xlimits=get(gca,'xlim');
        hold on;
        plot(xlimits,[xlimits' ones(2,1)]*p);
    end
end