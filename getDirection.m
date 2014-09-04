function [x,y,vec] = getDirection(startGear, destGear)
% Function returns direction of shifts  
% x= -1 movement to left, x =0 straight shift, x= 1 movement to right
% y= -1 backward movement, y= 1 forward movement
% vec is combined direction

switch startGear
    case 1
        switch destGear
            case 2
                x = 0;
                y= -1;
                vec = 3;
            case 3
                x = 1;
                y = 1;
                vec = 1;
            case 4
                x = 1;
                y = -1;
                vec = 2;
            case 5
                x = 1;
                y = 1;
                vec = 5;
            case 6
                x = 1;
                y = -1;
                vec = 6;
        end
     
    case 2
        switch destGear
            case 1
                x = 0;
                y = 1;
                vec = -3;
            case 3
                x = 1;
                y = 1;
                vec= -4;
            case 4
                x = 1;
                y = -1;
                vec = 1;
            case 5
                x = 1;
                y = 1;
                vec = 6;
            case 6
                x = 1;
                y = -1;
                vec = 5;
        end
        
    case 3
        switch destGear
            case 2
                x = -1;
                y = -1;
                vec = 4;
            case 1
                x = -1;
                y =  1;
                vec = -1;
            case 4
                x = 0;
                y = -1;
                vec = 3; 
            case 5
                x = 1;
                y = 1;
                vec = 1;
            case 6
                x = 1;
                y = -1;
                vec = 2;
        end
        
    case 4
        switch destGear
            case 2
                x = -1;
                y = -1;
                vec =-1;
            case 3
                x = 0;
                y = 1;
                vec = -3;
            case 1
                x = -1;
                y = 1;
                vec = -2;
            case 5
                x = 1;
                y = 1;
                vec = -4;
            case 6
                x = 1;
                y = -1;
                vec = 1;
        end
        
    case 5
        switch destGear
            case 2
                x = -1;
                y = -1;
                vec = -5; 
            case 3
                x = -1;
                y = 1;
                vec =-1;
            case 4
                x = -1;
                y = -1;
                vec = 4;
            case 1
                x = -1;
                y = 1;
                vec = -6;
                
            case 6
                x = 0;
                y = -1;
                vec =3;
        end
        
    case 6
        switch destGear
            case 2
                x = -1;
                y = -1;
                vec = -6;
            case 3
                x = -1;
                y = 1;
                vec = -2;
            case 4
                x = -1;
                y = -1;
                vec =-1;
            case 1
                x = -1;
                y = 1;  
                vec = -5;
            case 5
                x = 0;
                y = 1;
                vec = -3;
        end
end


end