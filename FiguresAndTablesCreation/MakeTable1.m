%Make Table 1 data
cd("C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\CodesToMakeFigures")

clear;close;clc

dataLoc1='../Equifinality_MCMC/';  % Not used, but jdone in case it was needed at some point. Good for reference.
dataLoc2='../Equifinality_MCMC_10PER/';

data=importdata([dataLoc2 'best_params.dat']);

% Column 1 is the phloem multiplier.
% Column 2 is unused. It was for an earlier version but ended up not being useful. It was easier to ignore it
% than to redo the source code and rerun.

medMult=median(data);
finalValue=10.^(medMult);

extendedFinalValue=[finalValue finalValue(end-2:end) finalValue(end-2:end)];

%Order: PTL, RMYC (vestigal in the final version), OQKM, VMXO, VCMX, OSM, XKCO2
startVals=[1 1 12 0.125 35 -1 12.5 45 -1.25 12.5 45 -1.25 12.5];
finalVals=startVals.*extendedFinalValue;