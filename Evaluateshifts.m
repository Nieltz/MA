a= slidingWindowFilter(gZ,300);
figure;plot(thy)
figure;pl(1)=subplot(3,1,1);plot(a)
pl(2)=subplot(3,1,2);plot(gZ)
pl(3)=subplot(3,1,3);plot(thx)
linkaxes([pl],'x');