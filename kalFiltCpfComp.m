function out=  kalFiltCpfComp(accx,accy,accz,waccx,waccy,waccz,ts)

r1=10;
r2=0.1;



x = [0;0;0;0;0;0;0;0];

f=@(x) [x(1)+x(3)*ts;...        % Phi
        x(2)+x(4)*ts;...        % Theta
        x(3);...                % omegax                   
        x(4);...                % omeagy
        x(5);...                % omegaz
        x(6);...                % accx
        x(7);...                % accy
        x(8)];                  % accz             
        
    %  x(6)+(x(7)-9.81*sind(x(2)))*ts;... % vx
    
Q = [0.0001,0,0,0,0,0,0,0;
    0,0.0001,0,0,0,0,0,0;
    0,0,0.0001,0,0,0,0,0;
    0,0,0,0.0001,0,0,0,0;
    0,0,0,0,0.0001,0,0,0;
    0,0,0,0,0.0001,0,0,0;
    0,0,0,0,0,0,0.001,0;
    0,0,0,0,0,0,0,0.001];

R =[r1,0,0,0,0,0,0,0;
    0,r1,0,0,0,0,0,0;
    0,0,r2,0,0,0,0,0;
    0,0,0,r2,0,0,0,0;
    0,0,0,0,r2,0,0,0;
    0,0,0,0,0,r1,0,0;
    0,0,0,0,0,0,r1,0;
    0,0,0,0,0,0,0,r1];
    
R = eye(8)*.01;

P= eye(8);

H=[ 1,0,0,0,0,0,0,0;
    0,1,0,0,0,0,0,0;
    0,0,1,0,0,0,0,0;
    0,0,0,1,0,0,0,0;
    0,0,0,0,1,0,0,0;
    0,0,0,0,0,1,0,0;
    0,0,0,0,0,0,1,0;
    0,0,0,0,0,0,0,1];



I=eye(8);
kk=1;
v=zeros(length(accx),1);
holdOffTime=500;
shift = 2;
for ii=1:length(accx)
    
    %% Check for bad input Data
    if ((isnan(accx(ii))) || (isnan(accy(ii))) || (isnan(accz(ii))) || (isnan(waccx(ii))) || (isnan(waccy(ii))))
        continue
    else
        kk=kk+1;
    end
%     if (shifts(ii)==1)
%         v(kk+1) = v(kk);
%     else
        v(kk+1) = v(kk)+(accx(ii)-9.81*sind(x(2)))*ts;

%     end


if (ii == 12143)||(ii == 20808)||(ii == 28019)||(ii == 34804)||(ii == 44580)
    shift = shift+1;
end
    %% Precalculations         
    aYc(kk) = waccz(ii)*getV((shift));% (accx(ii)-9.81*sind(x(2)))*ts;
    mThy =-atan2d(accy(ii)+aYc(kk),accz(ii));
    mThx = atan2d(accx(ii),accz(ii));
    A = getJforA(waccz(ii),ts);
    %% Kalman Filter
    x = f(x);%getX(x,ts,shifts(ii)); % preditct State;
    P = A*P*A' + Q;
    z = [mThy,mThx, waccy(ii),waccx(ii),waccz(ii),accx(ii),-aYc(ii)+accy(ii),accz(ii)];
    J_h = getJforH(accx(ii),accy(ii),accz(ii),waccz(ii),ts);
    y = z' - H*x;
    S = J_h*P*J_h' + R;
    K = P*J_h'*inv(S);
    x = x + K*y;
    P = (I-K*J_h)*P;
    out(kk,:)=x;
end
thx=out(:,1);
thy=out(:,2);
keyboard
end