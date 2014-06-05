function out= drawTrajectory(initPos, angles)  

x_dash=zeros(length(angles(:,1))+1,1);
y_dash=zeros(length(angles(:,1))+1,1);
z_dash=zeros(length(angles(:,1))+1,1);

x_dash(1) = initPos(1);
y_dash(1) = initPos(2);
z_dash(1) = initPos(3);
for ii=1:length(angles(:,1))
    [x_dash(ii+1), y_dash(ii+1), z_dash(ii+1)]=getEuler(x_dash(ii), y_dash(ii), z_dash(ii), angles(ii,1),angles(ii,2),angles(ii,3));
end


keyboard;
fh1= figure;
scatter3(x_dash,y_dash,z_dash);
fh2=figure;
plot3(x_dash,y_dash,z_dash);
out=[x_dash, y_dash,z_dash];
end
