function simpleKalFilt(accx,accz,waccy,ts)

q1= 0.001;
q2= 0.0001;
q3= 0.001;

r1=0.1;
r2=0.001;

dt=ts;
x = [0; 0; 0];
F = [1 dt -dt;
    0  1   0;
    0  0   1];

Q = [q1  0  0;
    0 q2  0;
    0  0 q3];

R = [r1  0;
    0 r2];

P= eye(3);

H=[1 0 0;
    0 1, 0];
I=eye(3);


for ii=1:length(accx);   
    x = F*x;
    P = F*P*F' + Q;
    z = [-180/pi*atan2(accx(ii),accz(ii)),waccy(ii)];
    y = z' - H*x;
    S = H*P*H' + R;
    K = P*H'*inv(S);
    x = x + K*y;
    P = (I-K*H)*P;
    out(ii,:)=x;
end
keyboard
end