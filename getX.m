function out = getX(x,ts,shift)
holdX6 = x(6);
f=@(x) [x(1)+x(3)*ts;...        % Phi
    x(2)+x(4)*ts;...        % Theta
    x(3);...                % omegax
    x(4);...                % omeagy
    x(5);...                % omegaz
    x(6)+(x(7)-9.81*sind(x(2)))*ts;... % vx
    x(7);...                % accx
    x(8);...                % accy
    x(9)];
% accz

out= f(x);

if shift==1
    out(6) = holdX6;
end
