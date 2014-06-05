
function kalFilt(accx,accy,accz,waccx,waccy)

it=100;
realv=10;
                   % x'                y'
measures = [accx'; accy',accz,waccx',waccy'];

xPos =1;
yPos =0;
zPos =0;
vx=0;
vy=0;
vz=0;
ax=0;
ay=0;
az=0;
thx=0;
thy=0;
thz=0;
wx=0;
wy=0;

x = [xPos, ... % xPosition
    yPos,  ... % yPosition
    zPos,  ... % zPosition
    vx,    ... % Geschwindigkeit in X-Richtung
    vy,    ... % Geschwindigkeit in Y-Richtung
    vz,    ... % Geschwindigkeit in Z-Richtung
    ax,    ... % Beschleunigung in X-Richtung
    ay,    ... % Beschleunigung in Y-Richtung
    az,    ... % Beschleunigung in Z-Richtung
    thx,   ... % Winkel um X-Achse   
    thy,   ... % Winkel um Y-Achse   
    wx,    ... % Winkelgeschwindigkeit um X-Achse   
    wy]    ... % Winkelgeschwindigkeit um Y-Achse  
    
    
    

% Transition Matrix
A= [1,0,0,ts,0,0,ts^2,0,0,0,0,0,0;
    0,1,0,0,ts,0,0,ts^2,0,0,0,0,0;
    0,0,1,0,0,ts,0,0,ts^2,0,0,0,0;
    0,0,0,1,0,0,ts,0,0,0,0,0,0;
    0,0,0,0,1,0,0,ts,0,0,0,0,0;
    0,0,0,0,0,1,0,0,ts,0,0,0,0;
    0,0,0,0,0,0,1,0,0,0,0,0,0;
    0,0,0,0,0,0,0,1,0,0,0,0,0;
    0,0,0,0,0,0,0,0,1,0,0,0,0;
    0,0,0,0,0,0,0,0,0,1,0,ts,0;
    0,0,0,0,0,0,0,0,0,0,1,0,ts;
    0,0,0,0,0,0,0,0,0,0,0,1,0;
    0,0,0,0,0,0,0,0,0,0,0,0,1];

% Noise Matrix
P=[10,0,0,0,0,0,0,0,0,0,0,0,0;
   0,10,0,0,0,0,0,0,0,0,0,0,0;
   0,0,10,0,0,0,0,0,0,0,0,0,0;
   0,0,0,10,0,0,0,0,0,0,0,0,0;
   0,0,0,0,10,0,0,0,0,0,0,0,0;
   0,0,0,0,0,10,0,0,0,0,0,0,0;
   0,0,0,0,0,0,10,0,0,0,0,0,0;
   0,0,0,0,0,0,0,10,0,0,0,0,0;
   0,0,0,0,0,0,0,0,10,0,0,0,0;
   0,0,0,0,0,0,0,0,0,10,0,0,0;
   0,0,0,0,0,0,0,0,0,0,10,0,0;
   0,0,0,0,0,0,0,0,0,0,0,10,0;
   0,0,0,0,0,0,0,0,0,0,0,0,10];


G = [ts^2, ts^2,ts^2,ts,ts,ts,1,1,1,ts,ts,1,1];  

sig = 1;
Q = G*G'.*sig^2; 



%Measurement function 
    mThx = atan2(ay,az);
    mThy = atan2(ax,az); 
    
% y = [mThx, ... Winkel um X-Achse an Hand Beschleunigungsdaten   
%     mThy, ... Winkel um Y-Achse an Hand Beschleunigungsdaten   
%     mX,    ...  aus Zustands�bergang abgeleitete neue X-Position
%     mY,    ...  aus Zustands�bergang abgeleitete neue Y-Position
%     mZ];   ...  aus Zustands�bergang abgeleitete neue Z-Position

H = [0,0,0,0,0,0,1,0,0,0,0,0,0;
     0,0,0,0,0,0,0,1,0,0,0,0,0;
     0,0,0,0,0,0,0,0,1,0,0,0,0;
     0,0,0,0,0,0,0,0,0,mThx,0,0,0;
     0,0,0,0,0,0,0,0,0,0,mThy,0,0];
     
R =[10,0,0,0,0;
    0,10,0,0,0
    0,0,10,0,0
    0,0,0,10,0
    0,0,0,0,10];

I= eye(13);
     
    



%% predict
x=A*x;      % Zustand pädizieren
P=A*P*A'+Q; % Kovarianz prädizieren

%% Correction 
Z= measures;
y=Z-(H*x); % Innovation aus Messwertdifferent
S=H*P*H'+R);
K=P*H'*inv(S); % Kalman Gain
x=x+(K*y);
P=(I-K*H))*P;



