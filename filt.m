function [HpOut,TpOut]  = filt(in)

persistent inInt
persistent blubb

if(isempty(blubb))
    inInt=0;
    blubb=0;
end
a=0.5;

in=in/2;
d=inInt+(in-inInt)*(-a);
inInt= (in-inInt)*(-a) + in;


HpOut=in-d;
TpOut=in+d;
end



