function [thx,thy]=  simpleKalFilt(accx,accy,accz,waccx,waccy,ts)

q1= 0.001;
q2= 0.0001;
q3= 0.001;

r1=1;
r2=1;

x = [0;0;0;0;0;0];

A= [1,0,ts,0,-ts,0;
    0,1,0,ts,0,-ts;
    0,0,1,0,0,0;
    0,0,0,1,0,0;
    0,0,0,0,1,0;
    0,0,0,0,0,1];

Q = [0.0005,0,0,0,0,0;
    0,0.00005,0,0,0,0;
    0,0,0.00005,0,0,0;
    0,0,0,0.00005,0,0;
    0,0,0,0,0.00005,0;
    0,0,0,0,0,0.00005];

R = [r1,0,0,0;
    0,r1,0,0;
    0,0,r2,0;
    0,0,0,r2];

P= eye(6);

H=[1,0,0,0,0,0;
    0,1,0,0,0,0;
    0,0,1,0,0,0;
    0,0,0,1,0,0];

I=eye(6);
kk=1;
for ii=1:length(accx)
    
    if ((isnan(accx(ii))) || (isnan(accy(ii))) || (isnan(accz(ii))) || (isnan(waccx(ii))) || (isnan(waccy(ii))))
        continue
    else
        kk=kk+1;
    end
    
    x = A*x;
    P = A*P*A' + Q;
    z = [-atan2d(accx(ii),accz(ii)),atan2d(accy(ii),accz(ii)),waccy(ii),waccx(ii)];
    y = z' - H*x;
    S = H*P*H' + R;
    K = P*H'*inv(S);
    x = x + K*y;
    P = (I-K*H)*P;
    out(kk,:)=x;
end
thx=out(:,1);
thy=out(:,2);

end