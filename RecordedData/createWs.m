addpath ..
addpath .\TrainigData
fileList=dir(fullfile('.','*.txt'));

%select desired files form Database
startFileNo = 61;
endFileNo = 79;
runList = startFileNo:endFileNo; % set a vector with desired samples here!
%load shifts;

%fileList = {'1.txt.mat','2.txt.mat','3.txt.mat','4.txt.mat','5.txt.mat','R.txt.mat','1-2.txt.mat','1bis5.txt.mat'};
readGearDatabase;
% parse name
for ii= runList % start at 3 because first2 entries are . and ..
% 
% 
% % parse name
% for ii= 1:length(fileList) % start at 3 because first2 entries are . and ..
%     fileName=fileList(ii).name;
    fileName = gearFilesTxt{ii};
    [lines, accData, gyroData]=readSensData(fileName,'Car');
    [aZ, aY, aX, gX, gY, gZ] = processSensData(lines, accData(2), gyroData(3),'Car');
    save([fileName,'.mat'],'aX','aY','aZ','gX','gY','gZ')
    clear lines 
    
end
