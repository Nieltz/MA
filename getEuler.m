
function [xBig, yBig, zBig]=  getEuler(x,y,z,a,b,c)
% a=a/180*pi;
% b= b/180*pi;
% c=c/180*pi;

M = [cos(a)*cos(c)-sin(a)*cos(b)*sin(c),  -cos(a)*sin(c)-sin(a)*cos(b)*cos(c),  sin(a)*sin(b);
    sin(a)*cos(c)+cos(a)*cos(b)*sin(c), -sin(a)*sin(c)+cos(a)*cos(b)*cos(c), -cos(a)*sin(b);
    sin(b)*sin(c),sin(b)*sin(c), cos(b)];



AA= M'*[x;y;z];
xBig = AA(1);
yBig = AA(2);
zBig = AA(3);


%achse =[0:9];

%scatter3(x,achse,y,achse,z);
%scatter3([x, xBig],[y, yBig],[z, zBig]);
%scatter3(xBig, yBig, yBig)


%keyboard
end