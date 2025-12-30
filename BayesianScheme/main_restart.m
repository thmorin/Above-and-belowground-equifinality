clear;close;clc
cd /home/thmorin/Equifinality_MCMC_10PER/

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

%% Quantify uncertainy of peepers
iters=10000;
burnin=floor(0.1*iters);

data=importdata('PRM_chain.txt');
chain_start=data(end,:)';

success=MetropHastings_ecosys_restart(iters,chain_start,0);

