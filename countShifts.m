bm2 = 0;
bm1 = 0;
b1 = 0;
b2 = 0;
b3 = 0;
b4 = 0;
b5 = 0;
for ii=1:length(d(1,:))
    for jj =1:length(d(:,1))
        switch d(jj,ii)
            case -2
                bm2=bm2+1;
            case -1
                bm1=bm1+1;
            case 1
                b1=b1+1;
            case 2
                b2=b2+1;
            case 3
                b3=b3+1;
            case 4
                b4=b4+1;
            case 5
                b5=b5+1;
            otherwise
                continue
        end
    end
end

bOut = [bm2, bm1, b1, b2, b3, b4, b5];