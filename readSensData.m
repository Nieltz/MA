function [linesOut, accData, gyroData] = readSensData( filename,type )

fid = fopen(filename)
%lins=0;
%data= fread(fid,'*char');
tline = fgetl(fid);
ii=0;
kk=1;
while ischar(tline)
    tline = fgetl(fid);
    ii=ii+1;
    switch (ii)
        case 1
            % skip
        case 2
            %skip
        case 3
            %% Accelerometer Config
            [accData]= sscanf(tline,'# Accelerometer Sensor Mode: Normal, Bandwidth:%d Hz, Range: %d');
        case 4
            %% Magnetometer config
        case 5
            %% Gyro config
            [gyroData]= sscanf(tline,'# Gyroscope Sensor Mode: Normal, Bandwidth: %dHz fs -> %dKHz, Range: %d�/s');
        case 6
            % skip
        otherwise
            if ~(strcmp(type,'Car'))
                %read data
                if (tline(1)~=-1)
                    %  line=sscanf(tline,'%f:%f:%f.%f %f);5%,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
                    %                           T T T  T  T   aX 0 aY 0  aZ 0  gX, 0 gY 0  gZ
                    line=sscanf(tline,'%d:%d:%d.%d, %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d');
                    if length(line) == 15
                        %                       T T T  T  T   aX 0 aY 0  aZ 0  gX, 0 gY 0  gZ
                        lins(:,kk)=sscanf(tline,'%d:%d:%d.%d, %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d');
                        kk=kk+1;
                    end
                end
            end
    end
end
if ~(strcmp(type,'Car'))
    linesOut=lins;
else
    [linesOut(1,:),linesOut(2,:),linesOut(3,:),linesOut(4,:),linesOut(5,:),linesOut(6,:),linesOut(7,:),linesOut(8,:),linesOut(9,:)]=ReadSensDataCar(filename, 9, ii);
end

end

