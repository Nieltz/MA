function gear = decShift(currentGear, svmOut)

switch(currentGear)
    case 1
        switch (svmOut)
            case 1
                gear = 3;
            case 2
                gear = 4;
            case 3
                gear = 2;
            case 5
                gear = 5;
            case 6
                gear = 6;
            otherwise
                gear =-1;
        end
        
    case 2
        switch (svmOut)
            case 1
                gear = 4;
            case -3
                gear = 1;
            case -4
                gear = 3;
            case 5
                gear = 6;
            case -6
                gear = 5;
            otherwise
                gear =-1;
        end
    case 3
        switch (svmOut)
            case 1
                gear = 5;
            case -1
                gear = 1;
            case 2
                gear = 6:
            case 3
                gear = 4;
            case 4
                gear = 2;
            otherwise
                gear =-1;
        end
    case 4
        switch (svmOut)
            case 1
                gear = 6;
            case -1
                gear = 2;
            case -2
                gear = 1;
            case -3
                gear = 3;
            case -4
                gear = 5;
            otherwise
                gear =-1;
        end
    case 5
        switch (svmOut)
            case -1
                gear = 3;
            case 3
                gear = 6;
            case 4
                gear = 4;
            case -5
                gear = 1;
            case -6
                gear = 2;
            otherwise
                gear =-1;
        end
    case 6
        switch (svmOut)
            case -1
                gear = 4;
            case -2
                gear = 3;     
            case -3
                gear = 5;   
            case -5
                gear = 2;
            case -6
                gear =-6;
        end
    case 7
        switch (svmOut)
            case 1
            case -1
            case 2
            case -2
            case 3
            case -3
            case 4
            case -4
            case 5
            case -5
            case 6
            case -6
        end
        
    otherwise
        
end

end