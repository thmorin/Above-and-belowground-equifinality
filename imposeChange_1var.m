function []=imposeChange_1var(chain_out,runNo)
% copyfile('UMB_base',['run' num2str(runNo)]);
chain_out=10.^(chain_out);
fname=sprintf('./run%d/param.dat',runNo);
fid=fopen(fname,'w');
fclose(fid);
dlmwrite(fname,chain_out','-append');