function out = simpleTP(data,k)
out=zeros(length(data),1);
for ii=2:length(data)
    if isnan(data(ii))
        
        ii=ii+1;
        continue;
    else
        out(ii)=data(ii)*0.01+out(ii-1)*0.99;%(1-k/10);
        
    end
end
