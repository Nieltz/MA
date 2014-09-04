function out =  getRaisedCosFilt(alpha,T)
% T = WindowLength;
% alpha Roll Off Faktor

lBound = ((1-alpha)/(2*(1/T)));
uBound = ((1+alpha)/(2*(1/T)));

out= zeros(length((-T):1:(T)),1);
kk=1;
for ii = (-T):1:(T)
    if abs(ii) < lBound
        out (kk) = 1;
    elseif ((lBound < abs(ii) ) && (uBound> abs(ii)))
        out(kk)= cos(((pi*(1/T)/(2*alpha))*(abs(ii)-lBound)))^2;
    else
        out(kk)=0;
    end
    kk=kk+1;
end
end