function shifts = findShifts()

addpath ..

%select desired files form Database
startFileNo = 33;
endFileNo =  33;
runList = startFileNo:endFileNo; % set a vector with desired samples here!
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
    