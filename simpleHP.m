function out = simpleHP(data)
out=zeros(length(data),1);
for ii=2:length(data)
    if isnan(data(ii))
        
        ii=ii+1;
        continue;
    else
        out(ii)=data(ii)-0.99*data(ii-1);
        
    end
end
