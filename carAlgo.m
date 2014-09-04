function shifts =carAlgo(aX,aY,aZ,gX,gY,gZ)
ts=0.001;
%% Data Fusion with Kalman filter
%[thx, thy] = simpleKalFilt(aX,aY,aZ,gX,gY,ts);
%extended KalmanFilter
% KalFilt(aX,aY,aZg,gX,gY,ts);

% kalmanFilter = kalFilter();

shiftClassifier = shiftClusters;
shiftDetectorObj = shiftDetector(4,25);

dist = zeros(300,2);
clust= ones(length(aX),1);
clust(1:300)=4;

shifted=0;
k=1;
shifts(k)=0;

ll=300;
holdShift=0;
%% Main Loop
for ii = 300:length(aX)
        
   if (isnan(aX(ii))) || (isnan(aY(ii))) || (isnan(aZ(ii))) || (isnan(gX(ii))) || (isnan(gY(ii)))
       continue
        
   end 
    
   [shift(ii), lklhd(ii)] = shiftDetectorObj.shiftDetection2(aX(ii),aY(ii),aZ(ii),ii);%(aTPX(ii)-aTPX(ii-1)),(aTPY(ii)-aTPY(ii-1)),(aTPZ(ii)-aTPZ(ii-1)),ii);
   
%    if shift(ii)==1
%        holdShift=10;
%    else
%        holdShift = holdShift-1;
%    end
%    if holdShift > 0
%        shifted =1;
%    end
   
%    [thx(ii),thy(ii)]=kalmanFilter.runFilter(aX(ii),aY(ii),aZ(ii),gX(ii),gY(ii),shifted); 
   
   if shift(ii) ==0
%         [clust(ll), dist] = shiftClassifier.run(-thy(ii),thx(ii),dist(clust(ll-1),:));
        shifted =0;
    else
        if shifted == 0
            shifted =1;
            shifts(k)=ii;
            k=k+1;
        end
%         dist = zeros(7,2);
    end
    ll=ll+1;
   
    
end
end