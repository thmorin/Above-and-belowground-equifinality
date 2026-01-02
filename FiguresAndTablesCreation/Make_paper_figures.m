cd("C:\Users\thmor\OneDrive - SUNY ESF\Documents\Publications\2022_Equifinality\CodesAndFigs_03092023\CodesToMakeFigures");

addpath("../Equifinality_MCMC/")

% Mandatory to HAVE run, but not every single time
runPosteriors %Use if you need to make postiors after a big 10,000 run. Performs subsample
bootstrapPosterior %Use this to make the mat files and run statistics on the outputs

%% TABLES
MakeTable1
MakeTable2
%% FIGURES, MAIN TEXT
CompareBaseToMeasured                % FIGURE 1
MakeCO2BeforeAndAfter                % FIGURE 2
viewPosteriors                       % FIGURE 3 and A2
CompareModernDayModels               % FIGURE 4
MakeSuiteOfPosteriorProjectionPlots  % FIGURE 5
%% APPENDIX FIGURES
makeSpinupPlot                       % APPENDIX A1
%Appendix A2, rerun viewPosteriors with directory pointed at the inversion test
makeClimateForcingPlot               % APPENDIX A3