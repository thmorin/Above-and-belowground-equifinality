function [success]=MetropHastings_ecosys_restart(iters,chain_prior,plotYN)

parNum=4;
postLen=1000;

best_scores=load('scores.dat');
best_gpp=load('best_gpp.dat');
best_co2=load('best_co2.dat');
best_re=load('best_re.dat');
best_params=load('best_params.dat');
bbb=load('PRM_scores.txt');
jj=sort(bbb(:,1));
fprintf('Restarting from %d\n',jj(end));
count=((jj(end)+1):(jj(end)+parNum-1))';
%% Begin Metropolis Hastings algorithm
for i=2:ceil(iters/(parNum-1))
    chain_post=nan(length(chain_prior),parNum);
    cost_post=nan(length(chain_prior),parNum);
    tic        
    for j=1:parNum
        delete(['./run' num2str(j) '/outputs/*'])
        if j>1
            chain_post(:,j)=ProposalFunction(chain_prior);
        else
            chain_post(:,j)=chain_prior;
        end
        imposeChange_1var(chain_post(:,j),j);
    end
    fprintf('Beginning parallel ecosys runs %d\n',i);
    parfor j=1:parNum
        fprintf('Running now %d\n',j);
        system(['cd ./run' num2str(j) ' ; ./run_usumb_short']);
        
        [cost_post(:,j),CO2_post,RE_post,GPP_post]=MyCostFunction(chain_post(:,j),j,plotYN);
        CO2_post(isnan(CO2_post))=-9999;
        RE_post(isnan(RE_post))=-9999;
        GPP_post(isnan(GPP_post))=-9999;

        if i==1 && j==1
            fid_co2s=fopen('CO2_start.txt','w');
            fclose(fid_co2s);
            dlmwrite('CO2_start.txt',CO2_post','-append');
            
            fid_res=fopen('RE_start.txt','w');
            fclose(fid_res);
            dlmwrite('RE_start.txt',RE_post','-append');
            
            fid_gpp=fopen('GPP_start.txt','w');
            fclose(fid_gpp);
            dlmwrite('GPP_start.txt',GPP_post','-append');
        end
    end
    %fprintf('getting out of parallel loop\n');
    tt=toc;
    fprintf('Parallel ecosys runs %d finished, took %f\n',i,tt);
    cost_prior=cost_post(:,1);
    for j=2:size(cost_post,2)
        rn=rand(size(cost_post,1),1);
        prob=exp(cost_post(:,j)-cost_prior);
        for k=3:length(rn)
	    fprintf('Cost post=%0.05f\n',cost_post(k,j));
	    fprintf('Cost prior=%0.05f\n',cost_prior(k));
            %A postivie number is REALLY good here
            %A negative number is LESS good here
            if rn(k)<prob(k)
                % Accept new value
                chain_prior(k)=chain_post(k,j);
                % You also need to accept the new cost
                cost_prior(k)=cost_post(k,j);
                fprintf('ACCEPT %0.03f\n',prob(k));
                Accept=1;
            else
                % Do not accept new value
                fprintf('REJECT %0.03f\n',prob(k));
        		Accept=0;
            end
            dlmwrite('Chain_status.txt',[i,j,k,prob(k),chain_post(k,j),Accept],'-append');
        end
        chain_tmp(:,j-1)=chain_prior;
        dlmwrite('PRM_chain.txt',chain_prior','-append');
        
        
    end
    if i==1
        count=(1:parNum-1)';
    else
        %count=[count;count((i-2)*(parNum-1)+1:(i-1)*(parNum-1))+parNum-1];
        count=count+parNum-1;
    end
    
    parfor j=1:size(chain_tmp,2)
        %Copy over to a posterior folder
        imposeChange_1var(chain_tmp(:,j),j);
        system(['rm ./run' num2str(j) '/outputs/*']);
        
        %Rerun with the most recent version
        fprintf('Generating score for %d now\n',j);
        system(['cd ./run' num2str(j) ' ; ./run_usumb_short']);

        %Save the objective function score
        [cost_score,M_CO2,M_RE,M_GPP]=MyCostFunction(chain_tmp(:,j),j,plotYN);
        CO2_tmp(j,:)=M_CO2;
        RE_tmp(j,:)=M_RE;
        GPP_tmp(j,:)=M_GPP;
        av_cost_tmp(j)=mean(cost_score(3:end));
        fid_scores=fopen('PRM_scores.txt','a+');
        fprintf(fid_scores,'%d,%0.05f,%0.05f,%0.05f,%0.05f,%0.05f\n',count(j),cost_score(3:end));
        fclose(fid_scores);
    end
    fprintf('Chain %d complete\n',i);
    if length(best_scores)+length(av_cost_tmp)<postLen
        best_scores=[best_scores;av_cost_tmp'];
        best_gpp=[best_gpp;GPP_tmp];
        best_co2=[best_co2;CO2_tmp];
        best_re=[best_re;RE_tmp];
        best_params=[best_params;chain_tmp'];
    else
        for j=1:parNum-1
            score_diff=best_scores-av_cost_tmp(j);
            [~,ind_list]=sort(best_scores-av_cost_tmp(j),'descend');
            I=ind_list(end);
            
            if score_diff(I)<0
                fprintf('Replacing %d score %0.06f with %0.06f\n',I,best_scores(I),av_cost_tmp(j));
                best_scores(I)=av_cost_tmp(j);
                best_gpp(I,:)=GPP_tmp(j,:);
                best_co2(I,:)=CO2_tmp(j,:);
                best_re(I,:)=RE_tmp(j,:);
                best_params(I,:)=chain_tmp(:,j)';
            end
        end
    end
    fid_scores=fopen('scores.dat','w');
    fclose(fid_scores);
    dlmwrite('scores.dat',best_scores,'-append');
    
    fid_co2=fopen('best_co2.dat','w');
    fclose(fid_co2);
    dlmwrite('best_co2.dat',best_co2,'-append');
    
    fid_gpp=fopen('best_gpp.dat','w');
    fclose(fid_gpp);
    dlmwrite('best_gpp.dat',best_gpp,'-append');
    
    fid_re=fopen('best_re.dat','w');
    fclose(fid_re);
    dlmwrite('best_re.dat',best_re,'-append');
    
    fid_params=fopen('best_params.dat','w');
    fclose(fid_params);
    dlmwrite('best_params.dat',best_params,'-append');
end
success=1;
end
