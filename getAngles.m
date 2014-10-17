function [startAng, endAng] = getAngles(buffer)
    startAng = mean(buffer(1:ceil(length(buffer)/5)));
    endAng = mean(buffer(end-ceil(length(buffer)/5):end));
end