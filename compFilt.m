function [ang, ang2,hp,tp]=compFilt(accAng,wacc,ts)

persistent initPers;
persistent angleInt;

if(isempty(initPers))
    angleInt=0;
    initPers=0;
end

%wacc=wacc/180*pi;

angleInt=angleInt+wacc*ts;

accAng=accAng*0.5;
HpOut=angleInt*.5-filterr(angleInt*.5);
TpOut=accAng+filt2(accAng);

hp=HpOut;
tp=TpOut;

ang=HpOut+TpOut;
ang2=angleInt;
end



function d = filterr(in)

persistent inInt
persistent initPers2

if(isempty(initPers2))
    inInt=0;
    initPers2=0;
end
a=0.5;

d=inInt+(in-inInt)*(-a);
inInt= (in-inInt)*(-a) + in;

% x+(1-k)*x1+kx-kx1+x
% x+x1-kx1+kx-kx1+x


% 2x+x1-2kx1+kx
% k*(x-2x1)+2x+x1



out=d;
end

function out = filt2(in)

persistent inInt2
persistent initPers

if(isempty(initPers))
    inInt2=0;
    initPers=0;
end
a=0.5;

d=inInt2+(in-inInt2)*(-a);
inInt2= (in-inInt2)*(-a) + in;



% x-(x1+kx-kx1)
% x-kx+kx1-((x-x1)k+x)
% x-kx+kx1-(kx-kx1+x)
% x-kx+kx1-kx+kx1-x
% -2kx+2kx1
% 2k(x1-x)


out=d;
end

