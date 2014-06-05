function [thX, thY, thZ] = filterAngles(type, aX, aY, aZ, gX, gY,gZ,ts)

persistent thXInt;
persistent thYInt;
persistent thZInt;
persistent persInit;

if isempty(persInit)
    persInit =1;
    thXInt = 0;
    thYInt = 0;
    thZInt = 0;
end

k= 1;
gX=gX/180*pi;
gY= gY/180*pi;
gZ=gZ/180*pi;




if type ==1 % Complementary Filter for now
    alpha = atan2(aY,aX); % Drehung um Z Achse
    beta = atan2(aY,aZ); % Drehung um X Achse
    gamma = -1*atan2(aX,aZ); % Drehung um y-Achse
    
    
    thXInt = k*thXInt+ts*gX+(1-k)*beta;
    thYInt = k*thYInt+ts*gY+(1-k)*gamma;
    k=1; % only gyro data is considered
    thZInt = k*thZInt+ts*gZ+(1-k)*alpha; 
    
    
    
%     if abs(gZ) > threshold
%         thXInt= ((alpha-thXInt) *(K^2 *deltaT + 2*K) + gZ)*deltaT;
%     else
%         thXInt =0;
%     end
%     if abs(gX) > threshold
%         thYInt = ((beta-thYInt) *(K^2 *deltaT + 2*K) + gX)*deltaT;
%     else
%         thYInt =0;
%     end
%     if abs(gY) > threshold
%         thZInt = ((gamma-thZInt) *(K^2 *deltaT + 2*K) + gY)*deltaT;
%     else
%         thZInt =0;
%     end
    
    
    thX = thXInt;
    thY = thYInt;
    thZ = thZInt;
end

end