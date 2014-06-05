function  [aX, aY, aZ, gX, gY, gZ] = processSensData( lines, sensAcc, sensGyro)

switch sensAcc
    case 2
        lsb2ms2 = 9.81/1024;
    case 4
        lsb2ms2 = 9.81/512;
    case 8
        lsb2ms2 = 9.81/256;
    case 16
        lsb2ms2 = 9.81/128;
    otherwise
        error('Accelerometer Sensitivity not supported');
end

switch sensGyro
    case 2000
        gyro2degs = 16.4;
    case 1000
        gyro2degs = 32.8;
    case 500
        gyro2degs = 65.6;
    case 250
        gyro2degs = 131.2;
    case 125
        gyro2degs = 262.4;
    otherwise
        error('Gyro Sensitivity not supported');
end

aX=lines(5,:);
aY=lines(7,:);
aZ=lines(9,:);
gX=lines(11,:);
gY=lines(13,:);
gZ=lines(15,:);

aX=aX.*lsb2ms2;
aY=aY.*lsb2ms2;
aZ=aZ.*lsb2ms2;
gX=gX./gyro2degs;
gY=gY./gyro2degs;
gZ=gZ./gyro2degs;


