function [ labeledFeatures ] = labelShifts(shifts)

addpath ..

%fileList=dir(fullfile('.','*.mat'));
ts = 0.001;

%select desired files form Database
startFileNo = 12;
endFileNo =  20;
runList = [startFileNo:endFileNo]; % set a vector with desired samples here!
%load shifts;
load('labeledFeatures.mat');
[excelShifts, excelText] =  xlsread('shifts.xlsx','shiftsForMatlab');
[a textLineLength]=size(excelText);
checkDetected =0;
%fileList = {'1.txt.mat','2.txt.mat','3.txt.mat','4.txt.mat','5.txt.mat','R.txt.mat','1-2.txt.mat','1bis5.txt.mat'};
readGearDatabase;
% parse name
for jj= runList % start at 3 because first2 entries are . and ..
    %fileName=fileList(ii).name;
    fileName = gearFiles{jj};
    load(fileName);
    exShift=excelShifts(excelShifts(:,1)==jj,:); % read Line with labels to selected shift from Eycel Data
    
    for ii = 1:textLineLength
        exText = excelText{jj,ii};
        if ~(isempty(exText))
            checkDetected =1;
        end
    end
    
    if checkDetected ==1
        display(['samples skipped Check data first at Line: ',num2str(jj)]);
        checkDetected =0;
        continue;
    end
    
    exShift=excelShifts(excelShifts(:,1)==jj,:); % read Line with labels to selected shift from Eycel Data
    exShift(isnan(exShift))=''; % Delete NaN entries
    
    
    [thx, thy] = simpleKalFilt(aX,aY,aZ,gX,gY,ts);
    figure; plot(thx)
    title('THX');
    figure;plot(-thy)
    title('THY');
    %   algoStandalone;
    [shifts, fname]=findShifts(runList);
    keyboard;
    labelsForAngles = exShift(2:end);
    for ii = 1:shifts
        labelsforTransitions{ii} = getDirection(labels(ii),labels(ii+1));
    end
    labeledAngles = collectFeatures(thx,thy,shifts{jj,1},labelsForAngles);
    labeledFeatures{jj} = labeledAngles;
    
    transitions
    close all;
    clear thx thy labelsForAngles
end
save('labeledFeatures.mat','labeledFeatures');
save('labeledShifts.mat','labelsforTransitions');
end

