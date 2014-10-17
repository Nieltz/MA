function algoFinal
addpath RecordedData;
addpath \RecordedData;
addpath .\..\tools;

clear all; close all;

warning('off','MATLAB:illConditionedMatrix');
load('svmModel.mat');

% slect test set to be run
runList=[12:32, 35:78];

%% Configure Test
filename='nils2.txt';
matlabWS = 1; % set to one if matlab Workspace with read in Data exist


ts= 0.001;
filterWidth = 300;



%Load Data
if matlabWS == 0
    [lines, accData, gyroData]=readSensData(filename,'Car');
    [aZ, aY, aX, gX, gY, gZ] = processSensData(lines, accData(2), gyroData(3),'Car');
else
    load([filename,'.mat']);
    %     aZ1=aZ;
    %     aZ=aX;
    %     aX=aZ1;
end



simpleKalFilt=initKalFilt();
shiftDetectorObj = shiftDetector(485,25);


%% main Loop
for ii= filterWidth:length(aX)
    [thx(ii), thy(ii)] = simpleKalFilter.run(aX(ii),aY(ii),aZ(ii),gZ(ii),gY(ii),ts);
    
end
    
end