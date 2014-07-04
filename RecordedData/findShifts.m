function shifts = findShifts()

addpath ..

fileList=dir(fullfile('.','*.mat'));

% parse name
for ii= 1:length(fileList) % start at 3 because first2 entries are . and ..
    fileName=fileList(ii).name;
    
    load(fileName);
    shifts{ii}=carAlgo(aX,aY,aZ,gX,gY,gZ);
    clear aX aY aZ gX gY gZ
end
    