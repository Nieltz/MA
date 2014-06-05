function [accOut, gyroOut, angle]=compFilter(accel, gyro,ts)

persistent accelInt
persistent gyroInt
persistent initPers

if(isempty(initPers))
    initPers=0;
    gyroInt=0;
    accelInt=0;
end
k=-0.5;
%TP
% k*(x-2x1)+2x+x1
accelInt=k*(accel-2*accelInt)+2*accel+accelInt;

accOut=accelInt;

%HP
% 2k(x1-x)
gyroInt=2*k*(gyroInt-gyro);
gyroOut=gyroInt;
    
angle=accOut+gyroInt;
end