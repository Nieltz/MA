function algoMain()

clear all; close all;

%% Configure Test
filename='Sensor4.txt';
%samplingRateAccel = 
%samplingRateGyro = 

ts= 0.0005;

filterWidth = 5;

[lines, accData, gyroData]=readSensData(filename);
[aX, aY, aZ, gX, gY, gZ] = processSensData(lines, accData(2), gyroData(3));

KalFilt(aX,aY,aZ,gX,gY,ts);


% Remove Offsets in Acceleration Data
aX = aX-mean(aX(1:100));
aY = aY-mean(aY(1:100));
aZ = aZ-(mean(aZ(1:100)-9.81));



% init variables
aFX = zeros(length(aX),1); 
aFY = zeros(length(aX),1); 
aFZ = zeros(length(aX),1); 
gFX = zeros(length(aX),1); 
gFY = zeros(length(aX),1); 
gFZ = zeros(length(aX),1); 
thX = zeros(length(aX),1); 
thY = zeros(length(aX),1); 
thZ = zeros(length(aX),1); 
thXg = zeros(length(aX),1); 
thYg = zeros(length(aX),1); 
thZg = zeros(length(aX),1); 

pos=zeros(3,length(aX));           % Initial Position (X,Y,Z)
pos(3,:)=1;



for ii = filterWidth:length(aX)
    
    % reduce noise of recorded Signal
        [aFX(ii), aFY(ii), aFZ(ii), gFX(ii), gFY(ii),gFZ(ii)] = filterNoise(aX(ii-filterWidth+1:ii),...
            aY(ii-filterWidth+1:ii), aZ(ii-filterWidth+1:ii), gX(ii-filterWidth+1:ii), gY(ii-filterWidth+1:ii), gZ(ii-filterWidth+1:ii)); 
        % calculate Angles
    [thX(ii), thY(ii), thZ(ii)] = filterAngles(1, aFX(ii), aFY(ii), aFZ(ii), gFX(ii), gFY(ii),gFZ(ii),ts);
    
    
    thXg(ii) = thXg(ii-1)+gFX(ii)*ts;
    thYg(ii) = thYg(ii-1)+gFY(ii)*ts;
    thZg(ii) = thZg(ii-1)+gFZ(ii)*ts;
    
    [hiFreq(ii), loFreq(ii)]=filt(thYg(ii));
    [angle(ii),angle2(ii),hp(ii),tp(ii)]=compFilt(((-1)*atan2( aX(ii),aZ(ii) ) ),gFY(ii),ts);
    [loFreq2(ii),hiFreq2(ii), angleC1(ii)] = compFilter(((-1)*atan2( aX(ii),aZ(ii) ) ), thYg(ii));
   
    [pos(1,ii) pos(2,ii) pos(3,ii)] = getEuler(pos(1,ii-1),pos(2,ii-1),pos(3,ii-1),thXg(ii), thYg(ii), thZg(ii));
    

end




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
plot(gX);
title('Angle X Axis');
s5=subplot(3,2,4);
plot(gY);
title('Angle Y Axis');
s6=subplot(3,2,6);
plot(gZ);
title('Angle Z Axis');


keyboard;
drawTrajectory

end