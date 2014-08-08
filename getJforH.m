function H = getJforH(accx,accy,accz,waccz,ts)

datanAxAz_Ax = accz/(accx^2+accz^2); % thy
datanAxAz_Az = accx/(accx^2+accz^2); % thy
datanAyAz_Ay = accz/(accy^2+accz^2); % thx
datanAyAz_Az = accy/(accy^2+accz^2); % thx

dw2= accx*ts+9.81*sind(atand(accx/accz));
dax = waccz * ts;
dphi = waccz*ts*cosd(atand(accx/accz));

H = [1,0,0,0,0,0,datanAyAz_Ay,datanAyAz_Az; % thx
     0,1,0,0,0,datanAxAz_Ax,0,datanAxAz_Az; % thy
     0,0,1,0,0,0,0,0;                       % omegax
     0,0,0,1,0,0,0,0;                       % omegay
     0,0,0,0,1,0,0,0;                       % omegaz
     0,0,0,0,0,1,0,0;   
     0,dphi,0,0,0,0,1,0;                % accy
     0,0,0,0,0,0,0,1];            


end