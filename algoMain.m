function algoMain()
addpath RecordedData;
addpath \RecordedData;
addpath .\..\tools;

clear all; close all;

warning('off','MATLAB:illConditionedMatrix');
load('svmModel.mat');


%% Configure Test
filename='nils1.txt';
matlabWS = 1; % set to one if matlab Workspace with read in Data exists

ts= 0.001;


filterWidth = 300;

if matlabWS == 0
    [lines, accData, gyroData]=readSensData(filename,'Car');
    [aZ, aY, aX, gX, gY, gZ] = processSensData(lines, accData(2), gyroData(3),'Car');
else
    load([filename,'.mat']);
    %     aZ1=aZ;
    %     aZ=aX;
    %     aX=aZ1;
end


% Remove Offsets in Acceleration Data
% aX = aX-mean(aX(10:100));
% aY = aY-mean(aY(10:100));
% aZg = aZ-(mean(aZ(10:100)-9.81));
% aZ = aZ-mean(aZ(10:100));

% Remove Offsets in Gyro Data
gX = gX-mean(gX(10:100));
gY = gY-mean(gY(10:100));
%gZ = gZ-mean(gZ(10:100));

% init variables
aFX = slidingWindowFilter(aX,300);
aFY = slidingWindowFilter(aY,300);
aFZ = slidingWindowFilter(aZ,300);
gFX = zeros(length(aX),1);
gFY = slidingWindowFilter(gY,300);
gFZ = slidingWindowFilter(gZ,300);

thXg = zeros(length(aX),1);
thYg = zeros(length(aX),1);
thZg = zeros(length(aX),1);

pos=zeros(3,length(aX));           % Initial Position (X,Y,Z)
pos(3,:)=1;

%% Data Fusion with Kalman filter
[thx, thy] = simpleKalFilt(aX,aY,aZ,gZ,gY,ts);
%out = kalFiltCpfComp(aX,aY,aZ,gZ,gY,gX,ts,shifts);

%extended KalmanFilter
% KalFilt(aX,aY,aZg,gX,gY,ts);
%thx=simpleTP(thx);
%thy=simpleTP(thy);

aTPX=simpleHP(aX);
aTPY=simpleHP(aY);
aTPZ=simpleHP(aZ);

shiftClassifier = shiftClusters;
shiftDetectorObj = shiftDetector(4,25);

classifier = stDetector();
%% Main Loopat
dist = zeros(filterWidth,2);
clust= ones(length(aX),1);
clust(1:filterWidth)=4;
shifts=1;
bufCount =1;
for ii = filterWidth:length(aX)
    
    % Shift Detection
    [shift(ii), lklhd(ii)] = shiftDetectorObj.shiftDetection2(aFX(ii),aFY(ii),aFZ(ii),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
    
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
        gzMeans(shifts)= mean(bufGZ);
        if gzMeans(shifts) < -1
            dir(ii) =1; % movement to the left --> down shift
        elseif(gzMeans(shifts)>=-3 && gzMeans(shifts) < 3.8)
            dir(ii) =0; % no movement in Y direction --> same gear or gear below or on top
        else
            dir(11) =2; % movement to the right --> up shift
        end
        shifts=shifts+1;
        clear bufGZ;
        clear bufGY;
        bufCount=1;
    end
end
keyboard;
currentGear = 2;
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
    % normalize TrainingData
    normCorX(ii)= (mCorX(ii)-meanTsamples(1))/stdTsamples(1);
    normMtx(ii) = (mTX(ii)-meanTsamples(2))/stdTsamples(2);
    normAx(ii)  = (mAX(ii)-meanTsamples(3))/stdTsamples(3);
    normLx(ii)  = (mLX(ii)-meanTsamples(4))/stdTsamples(4);
    normCorY(ii)= (mCorY(ii)-meanTsamples(5))/stdTsamples(5);
    normMty(ii) = (mTY(ii)-meanTsamples(6))/stdTsamples(6);
    normAy(ii)  = (mAY(ii)-meanTsamples(7))/stdTsamples(7);
    normLy(ii)  = (mLY(ii)-meanTsamples(8))/stdTsamples(8);
    
    svmOut(ii)=svmpredict(0.5,[mCorX(ii),mTX(ii), mAX(ii), mLX(ii),mCorY(ii), mTY(ii), mAY(ii), mLY(ii)],model);
    svmOut(ii)=svmpredict(0.5,[normCorX(ii),normMtx(ii), normAx(ii), normLx(ii),normCorY(ii), normMty(ii), normAy(ii), normLy(ii)],model);
    currentGear(ii+1) = decShift(currentGear(ii), svmOut(ii));
end

keyboard;
%% Do shift Classification
for ii = filterWidth:length(aX)
    if shift(ii) ==0
        [clust(ii), dist] = shiftClassifier.run(-thy(ii),thx(ii),dist(clust(ii-1),:));
        p1{ii}= classifier.calcML([thx(ii),thy(ii)]);
        p2{ii}= classifier.calcML2([thx(ii),thy(ii)]);
        [blubb detOut1(ii)] = max(p1{ii});
        [blubb detOut2(ii)]= max(p2{ii});
    else
        dist = zeros(7,2);
    end
end

%         state(ii) =1;
%     else
%         state(ii)=0;
%         dist=[0,0];
%     end

% if (isnan(aX(ii))) || (isnan(aY(ii))) || (isnan(aZ(ii))) || (isnan(gX(ii))) || (isnan(gY(ii)))
%     continue
%
% end

% reduce noise of recorded Signal with sliding window filter
%     [aFX(ii), aFY(ii), aFZ(ii), gFX(ii), gFY(ii),gFZ(ii)] = filterNoise(aX(ii-filterWidth+1:ii),...
%         aY(ii-filterWidth+1:ii), aZ(ii-filterWidth+1:ii), gX(ii-filterWidth+1:ii), gY(ii-filterWidth+1:ii), gZ(ii-filterWidth+1:ii));
%
%     % Integrate Angles from gyroscopes;
%     thXg(ii) = thXg(ii-1)+gFX(ii)*ts;
%     thYg(ii) = thYg(ii-1)+gFY(ii)*ts;
%     thZg(ii) = thZg(ii-1)+gFZ(ii)*ts;
%
%     [hiFreq(ii), loFreq(ii)]=filt(thYg(ii));
%     [angle(ii),angle2(ii),hp(ii),tp(ii)]=compFilt(((-1)*atan( aY(ii)/aZ(ii) ) ),gFX(ii),ts);
%
%
%     [pos(1,ii) pos(2,ii) pos(3,ii)] = getEuler(pos(1,ii-1),pos(2,ii-1),pos(3,ii-1),thx(ii), thy(ii), 0);
%





f1=figure;
title('Raw Data');
s1=subplot(3,2,1);
plot(aX);
title('Accerleration X Axis');
s2=subplot(3,2,3);
plot(aY);
title('Accerleration Y Axis');
s3=subplot(3,2,5);
plot(aZ);
title('Accerleration Z Axis');
s4=subplot(3,2,2);
plot(gZ);
title('Angle X Axis');
s5=subplot(3,2,4);
plot(gY);
title('Angle Y Axis');
s6=subplot(3,2,6);
plot(gX);
title('Angle Z Axis');


keyboard;
drawTrajectory

end