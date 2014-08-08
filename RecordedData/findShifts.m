function shifts = findShifts(runList)

addpath ..

%select desired files form Database
startFileNo = 14;
endFileNo =  14;
if isempty(runList)
    runList = startFileNo:endFileNo; % set a vector with desired samples here!
end
%load shifts;

%fileList = {'1.txt.mat','2.txt.mat','3.txt.mat','4.txt.mat','5.txt.mat','R.txt.mat','1-2.txt.mat','1bis5.txt.mat'};
readGearDatabase;
% parse name
for ii= runList % start at 3 because first2 entries are . and ..
    
    load(gearFiles{ii});
    shifts{ii,1}=carAlgo(aX,aY,aZ,gX,gY,gZ);
    shifts{ii,2} = (gearFiles{ii});
    clear aX aY aZ gX gY gZ
end
