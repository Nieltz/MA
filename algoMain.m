function algoMain()
addpath RecordedData;
addpath \RecordedData;

clear all; close all;

%% Configure Test
filename='N_Running.txt';
matlabWS = 1; % set to one if matlab Workspace with read in Data exists

ts= 0.001;


filterWidth = 300;
<<<<<<< HEAD
if matlabWS == 0
=======
if matlabWS == 1
>>>>>>> 28726d1ce584517ce05cb4286bccac0eb1a5d90d
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
gZ = gZ-mean(gZ(10:100));

% init variables
aFX = zeros(length(aX),1);
aFY = zeros(length(aX),1);
aFZ = zeros(length(aX),1);
gFX = zeros(length(aX),1);
gFY = zeros(length(aX),1);
gFZ = zeros(length(aX),1);
thXg = zeros(length(aX),1);
thYg = zeros(length(aX),1);
thZg = zeros(length(aX),1);

pos=zeros(3,length(aX));           % Initial Position (X,Y,Z)
pos(3,:)=1;

%% Data Fusion with Kalman filter
% [thx, thy] = simpleKalFilt(aX,aY,aZ,gZ,gY,ts);
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
    %   if ((aX(ii)-aX(ii-1)<0.2))&&((aY(ii)-aY(ii-1)<0.2))&&((aZg(ii)-aZg(ii-1)<0.3))
    % gZSW(ii) = slidingWindowFilter((gZ(ii-200+1):ii),200);
    [shift(ii), lklhd(ii)] = shiftDetectorObj.shiftDetection2(aX(ii),aY(ii),aZ(ii),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
end
if shift(ii) ==0
    [clust(ii), dist] = shiftClassifier.run(-thy(ii),thx(ii),dist(clust(ii-1),:));
    p1{ii}= classifier.calcML([thx(ii),thy(ii)]);
    p2{ii}= classifier.calcML2([thx(ii),thy(ii)]);
    [blubb detOut1(ii)] = max(p1{ii});
    [blubb detOut2(ii)]= max(p2{ii});
else
    bufGZ(1:200) = gZ((ii-200+1):ii);
    bufGZ(200+bufCount) = gZ(ii);
    bufCount= bufCount+1;
    dist = zeros(7,2);
end
if (shift(ii-1)== 1 && shift(ii)==0)
    shifts=shifts+1;
    bufferGZ{shifts} = bufGZ;
    clear bufGZ;
    bufCount=1;
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