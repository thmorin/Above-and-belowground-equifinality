clear;close;clc
cd /home/thmorin/Equifinality_MCMC/

%Written by Tim Morin
%This version issued on Aug 23, 2022
%
%Aug update: A second run of each iteration runs in order to preserve the
%objective function scores. This allows easier bootstrapping of the best
%runs
%
%This function performs a semi-parallel Bayesian parameterization on ecosys
%It will copy a folder (by default named ./BaseRun/) and modifies a text file
%named param.dat, which the user must then allow to be read into ecosys by altering
%the FORTRAN ecosys code. User must design their own cost function and proposal functions
%in the appropriately named .m files

delete CO2_chain_*.txt
delete RE_chain_*.txt
delete GPP_chain_*.txt
%% Quantify uncertainy of peepers
iters=10000;
burnin=floor(0.1*iters);

chain_start=[
    0;       % PTL - WILL NOT CHANGE
    0;       % RMYC - WILL NOT CHANGE - UNUSED
    0;       % OQKM
    0;       % VMXO
    0;       % VCMX - Vc_max - maximum rate of rubsico carboxylation
    0;       % OSM
    0;       % XKCO2
    ];
chain_priors={
    0   %NOT USED
    0   %NOT USED
    
    
    makedist('Uniform','lower',-3,'upper',3) %OQKM_MULT - Pretty much done
    makedist('Uniform','lower',-1,'upper',1) %VMXO_MULT - NOT YET TUNED - probably too broad
    
    makedist('Uniform','lower',-0.3,'upper',0.3) %VCMX_MULT
    makedist('Uniform','lower',-0.5,'upper',0.5); %OSM_MULT
    makedist('Uniform','lower',-0.5,'upper',0.5) %XKCO2_MULT
    
    %makedist('Uniform','lower',-0.3,'upper',0.3) %ETMX_MULT - NOT TUNED YET. ADJUSTED BUT THEN DIDN'T TEST FOLLOWUP.
    %makedist('Uniform','lower',-1,'upper',1) %DCKI_MULT - NOT YET TUNED
};
    
save('Priors.mat','chain_priors');
success=MetropHastings_ecosys(iters,chain_start,0);

