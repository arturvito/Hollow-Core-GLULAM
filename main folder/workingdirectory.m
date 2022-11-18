function [odir] = workingdirectory()
mdir = './output/';

if ~exist(mdir)
   mkdir(mdir);
end

k = 0;
sdir = ['case' num2str(k)];
while exist([mdir sdir])
    k = k+1;
    sdir = ['case' num2str(k)];
end

odir = ([mdir sdir]);
mkdir(odir);
figures = [odir '/plots'];
mkdir(figures);

end
