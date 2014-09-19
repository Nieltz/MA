function [ falseDetection, missDetection ] = testShiftDetection()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

addpath ..

%fileList=dir(fullfile('.','*.mat'));
ts = 0.001;
detectorThresholds=[20:40];
load('labeledShifts2.mat');
[excelShifts, excelText] =  xlsread('shifts.xlsx','shiftsForMatlab');
[a textLineLength]=size(excelText);

readGearDatabase;

%select desired files form Database
startFileNo = 12;
endFileNo =  12;
runList = [startFileNo:endFileNo]; % set a vector with desired samples here!
%load shifts;
falseDetection = zeros(length(detectorThresholds),length(runList));
missDetection = zeros(length(detectorThresholds),length(runList));

for testRuns=1:length(detectorThresholds);
    
    checkDetected =0;
    %fileList = {'1.txt.mat','2.txt.mat','3.txt.mat','4.txt.mat','5.txt.mat','R.txt.mat','1-2.txt.mat','1bis5.txt.mat'};
    
    % create Shift detector object
    shiftDetectorObj = shiftDetector(4,detectorThresholds(testRuns));
    
    % parse name
    ind=0;
    for jj= runList % start at 3 because first2 entries are . and ..
        ind=ind+1;
        %fileName=fileList(ii).name;
        fileName = gearFiles{jj};
        load(fileName);
        exShift=excelShifts(excelShifts(:,1)==jj,:); % read Line with labels to selected shift from Eycel Data
        noOfShifts  = getNumberOfshifts(exShift);
        shifts=1;
        aFX = slidingWindowFilter(aX,300);
        aFY = slidingWindowFilter(aY,300);
        aFZ = slidingWindowFilter(aZ,300);
        for ii = 300:length(aX)
            
            % Shift Detection
            [shift(ii), lklhd(ii)] = shiftDetectorObj.shiftDetection2(aFX(ii),aFY(ii),aFZ(ii),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
            if (shift(ii-1)== 1 && shift(ii)==0)
                shifts=shifts+1;
            end
            
        end
        if (shifts-noOfShifts)>0
            falseDetection(testRuns,ind)= (shifts-noOfShifts);
        elseif (shifts-noOfShifts)<0
            missDetection(testRuns,ind) = noOfShifts-shifts;
        end
        clear shifts
    end
    clear shiftDetectorObj
    
end
end
function out = getNumberOfshifts(exShift)
% count number of Shifts
out = 0;
for ii = 2:length(exShift)
    if ~isnan(exShift(ii))
        out=out+1;
    end
end
end