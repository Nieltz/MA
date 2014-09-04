function [ labeledFeatures ] = labelShiftTransitions(shifts)

addpath ..

%fileList=dir(fullfile('.','*.mat'));
ts = 0.001;

%select desired files form Database
startFileNo = 14;
endFileNo =  20;
runList = [startFileNo:endFileNo]; % set a vector with desired samples here!
%load shifts;
load('labeledShifts2.mat');
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
    
    
    gFY = slidingWindowFilter(gY,300);
    gFZ = slidingWindowFilter(gZ,300);
    shiftDetectorObj = shiftDetector(4,25);
    bufCount =1;    
    shifts=1;
    for ii = 300:length(aX)
        
        % Shift Detection
        [shift(ii), lklhd(ii)] = shiftDetectorObj.shiftDetection2(aX(ii),aY(ii),aZ(ii),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
        
        if shift(ii)==1
            bufGY(1:200) = gFY((ii-200+1):ii);
            bufGZ(1:200) = gFZ((ii-200+1):ii);
            bufGZ(200+bufCount) = gFZ(ii);
            bufGY(200+bufCount) = gFY(ii);
            bufCount= bufCount+1;
            
            
        end
        if (shift(ii-1)== 1 && shift(ii)==0)
            % shift is done -> copy shift data
            bufferGZ{shifts} = bufGZ;
            bufferGY{shifts} = bufGY;
            shifts=shifts+1;
            clear bufGZ;
            clear bufGY;
            bufCount=1;
        end
    end
    
    %% get direction for Y and X axis
    for ii = 1:(shifts-1)
        [corX] =  getCovForGX(bufferGZ{ii});
        [mCorX(ii), mIndex] = max(abs(corX(:)));
        [mTX(ii), mAX(ii), mLX(ii)] = ind2sub(size(corX),mIndex);
        mCorX(ii) = corX(mIndex);
        [corY] =  getCovForGX(bufferGY{ii});
        [mCorY(ii), mIndex] = max(abs(corY(:)));
        [mTY(ii), mAY(ii), mLY(ii)] = ind2sub(size(corY),mIndex);
        mCorY(ii) = corY(mIndex);
    end
    
    
    labelsForAngles = exShift(2:end);
    for ii = 1:shifts-1
        [labelsforTransitionsX,labelsforTransitionsY,labelsforTransitionsVec] = getDirection(labelsForAngles(ii),labelsForAngles(ii+1));
        labelsforTrans(ii,:) = [mCorX(ii),mTX(ii), mAX(ii), mLX(ii), mCorY(ii),mTY(ii), mAY(ii), mLY(ii), labelsforTransitionsX, labelsforTransitionsY,labelsforTransitionsVec,labelsForAngles(ii),labelsForAngles(ii+1)];
    end
   labelsforTransitions{jj} = labelsforTrans;
   
   
   
    close all;
    clear thx thy bufferGZ bufferGY labelsForAngles labelsforTrans mCorX mCorY mAX mTX mLX mTY mAY mLY labelsforTransitionsX labelsforTransitionsY labelsforTransitionsVec
save('labeledShifts2.mat','labelsforTransitions');
    
 end