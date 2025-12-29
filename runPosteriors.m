clear;close;clc
%runPosteriors
%cd /home/thmorin/
postRunLocVec={'../Equifinality_MCMC/','../Equifinality_MCMC_10PER/'};


for jj=1:length(postRunLocVec)
postRunLoc=postRunLocVec{jj};
data=importdata([postRunLoc 'best_params.dat']);
PostSize=size(data,1); %How big a posterior you want

parfor i=1:size(data,1)
    ind=i;
    
    copyfile([postRunLoc 'UMB_base'],[postRunLoc 'posterior_' num2str(i)]);
    delete([postRunLoc 'posterior_' num2str(i) '/outputs/*'])
    
    fname=sprintf([postRunLoc 'posterior_%d/param.dat'],i);
    fid=fopen(fname,'w');
    fclose(fid);
    p=10.^data(ind,:);
    dlmwrite(fname,p,'-append');
    fprintf('Posterior %d running\n',i);
    system(['cd ' postRunLoc 'posterior_' num2str(i) ' ; ./run_usumb_short_proj']);
    system (['cd ' postRunLoc 'posterior_' num2str(i) '; rm *']);
end
end