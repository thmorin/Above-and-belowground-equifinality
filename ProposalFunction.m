function [chain_out]=ProposalFunction(chain_in)
% Investigating water table depth: change of 1.6-1.9 cm is ideal proposal range
load('Priors.mat','chain_priors');
chain_out=nan(size(chain_in));

chain_out(1)=chain_in(1);
chain_out(2)=chain_in(2);

for i=3:length(chain_in)
    prob=0;
    while prob==0
        %pd=makedist('Uniform','lower',chain_in(i)-0.5,'upper',chain_in(i)+0.5);
        %pd=makedist('Uniform','lower',chain_in(i)-0.1761,'upper',chain_in(i)+0.1761);
        if i==4 %VMXO proposal testing
            pd=makedist('Uniform','lower',chain_in(i)-0.3,'upper',chain_in(i)+0.3);
            chain_out(i)=icdf(pd,rand);
            prob=pdf(chain_priors{i},chain_out(i));
        elseif i==7 %ETMX proposal function - TESTING
            pd=makedist('Uniform','lower',chain_in(i)-0.2,'upper',chain_in(i)+0.2);
            chain_out(i)=icdf(pd,rand);
            prob=pdf(chain_priors{i},chain_out(i));
        elseif i==3 %OQKM proposal function - NOT GOOD. 99% acceptance as of 11/16/2021
            % Still a problem. 0.1 difference leads to the same change in
            % RE as 0.8 change... unclear why?
            pd=makedist('Uniform','lower',chain_in(i)-1.5,'upper',chain_in(i)+1.5); %1.5 was too big. Always a rejection OR an acceptance. 0.5 was too low, I think. But it also explored low first, so tough to gauge.
            r=rand;
            chain_out(i)=icdf(pd,r);
            prob=pdf(chain_priors{i},chain_out(i));
        elseif i==7 %XKCO2 proposal function - GOOD
            pd=makedist('Uniform','lower',chain_in(i)-0.2,'upper',chain_in(i)+0.2);
            chain_out(i)=icdf(pd,rand);
            prob=pdf(chain_priors{i},chain_out(i));
        elseif i==6 %OSM proposal function - UNTESTED
            pd=makedist('Uniform','lower',chain_in(i)-0.2,'upper',chain_in(i)+0.2);
            chain_out(i)=icdf(pd,rand);
            prob=pdf(chain_priors{i},chain_out(i));
        elseif i==9 %DCKI proposal function - Maybe too small still. 97.962% acceptance as of 11/1/2021
            pd=makedist('Uniform','lower',chain_in(i)-0.4,'upper',chain_in(i)+0.4);
            chain_out(i)=icdf(pd,rand);
            prob=pdf(chain_priors{i},chain_out(i));
        elseif i==5 %VCmax proposal function - GOOD
            pd=makedist('Uniform','lower',chain_in(i)-0.2,'upper',chain_in(i)+0.2);
            chain_out(i)=icdf(pd,rand);
            prob=pdf(chain_priors{i},chain_out(i));
        end
    end
end
