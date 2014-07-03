addpath ..

fileList=dir(fullfile('.','*.txt'));

% parse name
for ii= 1:length(fileList) % start at 3 because first2 entries are . and ..
    fileName=fileList(ii).name;
    [lines, accData, gyroData]=readSensData(fileName,'Car');
    [aX, aY, aZ, gX, gY, gZ] = processSensData(lines, accData(2), gyroData(3),'Car');
    save([fileName,'.mat'],'aX','aY','aZ','gX','gY','gZ')
    clear lines 
    
end
