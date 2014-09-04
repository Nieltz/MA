function [corcov, corcov2] = getCovForGX(GX)
initMeanGX = sum(GX(1:150))/150;
GX=GX-initMeanGX;
%figure;plot(GX);
%for h= height
%    hs = hs+1;
ts=0;
for T = 20:10:400
    ts=ts+1;
    as=0;
    diffGF = length(GX)-(2*T);
    filtMask = zeros(length(GX),1);
    for alpha = 0:0.1:1
        as=as+1;
        filt = getRaisedCosFilt(alpha,T);        
        for ii = 1:(length(GX)-length(filt)-1)
            filtMask(ii:length(filt)+(ii-1)) = filt;
            c(ii) = (filtMask-mean(filtMask))'*(GX-mean(GX))';

            %cout(ii)=c(ii,ceil(numel(filtMask)/2)-1:end-ceil(numel(filtMask))/2);
        end
            %[mCor(ii), mIndex] = max(abs(cout(:)));
            %[mII, mT] = ind2sub(size(cout),mIndex);
%         d = conv(filt-mean(filt(:)), GX-mean(GX(:)))/sum(filt(:));
        corcov(:,as,ts) = c;%(ceil(numel(filt)/2)-1:end-ceil(numel(filt))/2);
%         corcov2(:,as,ts) = d(ceil(numel(filt)/2)-1:end-ceil(numel(filt))/2);
        % figure;plot(filt);
        %%ii=1;
        %%for ii = 1:(length(GX)-(3*T+1))
        %corcof(ii) = sum((h.*filt).*GX(ii:(ii+length(filt)-1))')/(sum(abs(h.*filt))+sum(abs(GX(ii:(ii+length(filt)-1)))));
        
        %      figure;plot(filt);
        %               corcof=cora(1,2);
        % [tmax, asMax, tsMax] = corcov(max(corcov)
        % keyboard
        %             [maxVal,ind] = min(abs(corcof));
        %             correlation(hs,ts,as) = corcof(ind);
    end
end
%end
end

