function [ falseDetection, missDetection, missDetectRate, falseDetectRate ] = testShiftDetection()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

addpath ..

%fileList=dir(fullfile('.','*.mat'));
ts = 0.001;
detectorThresholds=[450:5:550];
%Load
load('labeledShifts2.mat');
%Load list of samples to be skipped
load('corruptedList');
[excelShifts, excelText] =  xlsread('shifts.xlsx','shiftsForMatlab');
[a textLineLength]=size(excelText);

readGearDatabase;

%select desired files form Database
startFileNo = 26;
endFileNo = 32;

runList = [startFileNo:endFileNo]; % set a vector with desired samples here!
runList=[12:32, 35:78];
%load shifts;
falseDetection = zeros(length(detectorThresholds),length(runList));
missDetection = zeros(length(detectorThresholds),length(runList));

totalNoOfRealShifts =zeros(length(detectorThresholds),1);
missDetectRate = zeros(length(detectorThresholds),1);
falseDetectRate = zeros(length(detectorThresholds),1);


for testRuns=1:length(detectorThresholds);
    
    checkDetected =0;
    %fileList = {'1.txt.mat','2.txt.mat','3.txt.mat','4.txt.mat','5.txt.mat','R.txt.mat','1-2.txt.mat','1bis5.txt.mat'};
    
    % create Shift detector object
    shiftDetectorObj = shiftDetector(detectorThresholds(testRuns),25);
    
    % parse name
    ind=0;
    for jj= runList %Loop over data sets
        if sum(corrupted(corrupted==jj))
            %skip corrupted samples
            continue;
        end
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
        shift=zeros(length(aX),1);
        startShift=51;
        %        [shift, lklhd] = shiftDetectorObj.shiftDetectionCa_Cfar(aX,aY,aZ,10,21,5 );
        for ii = 300:length(aX)
            
            
            % Shift Detection
            [shift(ii), startShift(ii), shiftPower] = shiftDetectorObj.shiftDetection2(aX(ii),aY(ii),aZ(ii),gY(startShift-50:ii-100),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
            if (shift(ii-1)== 0 && shift(ii)==1)
                startShift=ii;
            end
            if (shift(ii-1)== 1 && shift(ii)==0 && ii-startShift(ii)>150)
                if abs(shiftPower) > 4500
                     shifts=shifts+1;
                end
            elseif(shift(end)==1)
                shifts=shifts+1;
            end
            
        end
        
        % Count false and miss detections
        if (shifts-noOfShifts)>0
            falseDetection(testRuns,ind)= (shifts-noOfShifts);
        elseif (shifts-noOfShifts)<0
            missDetection(testRuns,ind) = noOfShifts-shifts;
        end
        if (shifts-noOfShifts) ~=0
%               keyboard
        end
        %sum Shifts from Excel
        totalNoOfRealShifts(testRuns) = noOfShifts-1 +totalNoOfRealShifts(testRuns); % substract one because noOfshift contains the number states and not shift actions
        %totalNoOfDetectedShifts(testRuns) = totalNoOfDetectedShifts(testRuns);
        clear shifts
    end
    
    %% Calculate Detection Rates
    if totalNoOfRealShifts(testRuns)>1
        % prevent div0 if no shift event occured
        missDetectRate(testRuns) = sum(missDetection(testRuns,:))/totalNoOfRealShifts(testRuns);
        falseDetectRate(testRuns) = sum(falseDetection(testRuns,:))/totalNoOfRealShifts(testRuns);
    else
        missDetectRate(testRuns)=0;
        falseDetectRate(testRuns)
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