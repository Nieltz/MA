function [xBig, yBig, zBig]=  getEuler(x,y,z,a,b,c)


M = [cos(a)*cos(c)-sin(a)*cos(b)*sin(c), sin(a)*cos(c)+cos(a)*cos(b)*sin(c), sin(b)*sin(c);
    -cos(a)*sin(c)-sin(a)*cos(b)*cos(c), -sin(a)*sin(c)+cos(a)*cos(b)*cos(c), sin(b)*sin(c);
    sin(a)*sin(b), -cos(a)*sin(b), cos(b)]

[xBig,yBig,zBig] = M*[x,y,z];    
    
    
end
