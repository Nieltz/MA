function [aFX, aFY, aFZ, gFX, gFY, gFZ] = filterNoise(aX, aY, aZ, gX, gY, gZ)

% Use Sliding Window averaging for now
aFX = mean(aX);
aFY = mean(aY);
aFZ = mean(aZ);
gFX = mean(gX);
gFY = mean(gY);
gFZ = mean(gZ);
