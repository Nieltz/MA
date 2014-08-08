function out = slidingWindowFilter(data, windowSize)

out(1:windowSize) = data(1:windowSize); 

for ii = windowSize+1: length(data)
    
out(ii) = mean(data((ii-windowSize):ii));

end 