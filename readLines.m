function  lines = readLines( filename )

fid = fopen(filename)

%data= fread(fid,'*char');
tline = fgetl(fid);
ii=1;
while ischar(tline)
    disp(tline)
    tline = fgetl(fid);
    if ii>7
       lines(ii)=sscanf(tline,'%d:%d:%d.%d, %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d');
    end
    ii=ii+1;
end

end

