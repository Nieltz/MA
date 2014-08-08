shiftClassifier = shiftClusters;
shiftDetectorObj = shiftDetector(4,25);
filterWidth = 300;
dist = zeros(filterWidth,2);
clust= ones(length(aX),1);
clust(1:filterWidth)=4;
holdShift=0;
ll=300;
for ii = filterWidth:length(aX)
    %   if ((aX(ii)-aX(ii-1)<0.2))&&((aY(ii)-aY(ii-1)<0.2))&&((aZg(ii)-aZg(ii-1)<0.3))
    
    [shift(ii), lklhd(ii)] = shiftDetectorObj.shiftDetection2(aX(ii),aY(ii),aZ(ii),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
    if shift(ii)==1
        holdShift=10;
    else
        holdShift = holdShift-1;
    end
    if holdShift > 0
        shifted =1;
    end
    
    if shift(ii) ==0
        [clust(ll), dist] = shiftClassifier.run(-thy(ii),thx(ii),dist(clust(ll-1),:));
        shifted =0;
    else
        if shifted == 0
            shifted =1;
            shifts(k)=ii;
            k=k+1;
        end
        dist = zeros(7,2);
    end
    ll=ll+1;
end


figure; plot(clust-1);