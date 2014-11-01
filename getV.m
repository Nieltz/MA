function v = getV(gear)
% function returns speed for selected gear in m/s
% Gears are numerated from 1 to 5
% Where 0 is neutral gear and g is rearward gear
		vel =[0 2.8 7 9.7 15.3 22.2, -2.8];
        v = vel(gear-1);
end