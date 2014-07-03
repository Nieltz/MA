classdef shiftClusters <handle
    %shiftClusters this class contains the mean values of the shift stick
    %positions and the functions to update those
    
    
    properties
        c0; % Pos Forward Left
        c1; % Pos Forward Middle
        c2; % Pos Forward Right
        c3; % Pos Neutral
        c4; % Pos Backward Left 
        c5; % Pos Backard Middle
        c6; % Pos Backward Right
    end
    
    methods
        function obj = shiftClusters
            % Constructor
            obj.c0 = [-8,15];
            obj.c1 = [0,15];
            obj.c2 = [8,15];
            obj.c3 = [0,0];
            obj.c4 = [-8,-15];
            obj.c5 = [0,-15];
            obj.c6 = [8,-15];
        end
        
        function [clust, di]= run (obj, alpha, beta,oldDist)
           alp = alpha + oldDist(1)/2;
           bet = beta + oldDist(2)/2;
            [dist, di] = obj.getDistance(alp, bet);
            [d, clust] = min(dist);
            obj.updateC(clust-1, alp, bet);
            
        end
        
        function [dist,d] = getDistance(obj,alpha, beta)
            dist(1) = sqrt( (obj.c0(1)-alpha)^2 + (obj.c0(2)-beta)^2);
            dist(2) = sqrt( (obj.c1(1)-alpha)^2 + (obj.c1(2)-beta)^2);
            dist(3) = sqrt( (obj.c2(1)-alpha)^2 + (obj.c2(2)-beta)^2);
            dist(4) = sqrt( (obj.c3(1)-alpha)^2 + (obj.c3(2)-beta)^2);
            dist(5) = sqrt( (obj.c4(1)-alpha)^2 + (obj.c4(2)-beta)^2);
            dist(6) = sqrt( (obj.c5(1)-alpha)^2 + (obj.c5(2)-beta)^2);
            dist(7) = sqrt( (obj.c6(1)-alpha)^2 + (obj.c6(2)-beta)^2);
            
            d(1,1)=(obj.c0(1)-alpha); d(1,2) = (obj.c0(2)-beta);
            d(2,1)=(obj.c1(1)-alpha); d(2,2) = (obj.c1(2)-beta);
            d(3,1)=(obj.c2(1)-alpha); d(3,2) = (obj.c2(2)-beta);
            d(4,1)=(obj.c3(1)-alpha); d(4,2) = (obj.c3(2)-beta);
            d(5,1)=(obj.c4(1)-alpha); d(5,2) = (obj.c4(2)-beta);
            d(6,1)=(obj.c5(1)-alpha); d(6,2) = (obj.c5(2)-beta);
            d(7,1)=(obj.c6(1)-alpha); d(7,2) = (obj.c6(2)-beta);
        end
        
        function updateC (obj, cluster,alpha, beta)
             switch cluster
%                 case 0 
%                     obj.c0 = mean([obj.c0;[alpha,beta]]);
%                 case 1
%                     obj.c1 = mean([obj.c0;[alpha,beta]]);
%                 case 2
%                     obj.c2 = mean([obj.c0;[alpha,beta]]);
%                 case 3
%                     obj.c3 = mean([obj.c0;[alpha,beta]]);
%                 case 4
%                     obj.c4 = mean([obj.c0;[alpha,beta]]);
%                 case 5
%                     obj.c5 = mean([obj.c0;[alpha,beta]]);
%                 case 6
%                     obj.c6 = mean([obj.c0;[alpha,beta]]);
%                 otherwise
%                     error('wrong cluster selected');
                case 0 
                    obj.c0 = obj.c0.*0.999+0.001.*[alpha,beta];
                case 1
                    obj.c1 = obj.c1.*0.999+0.001.*[alpha,beta];
                case 2
                    obj.c2 = obj.c2.*0.999+0.001.*[alpha,beta];
                case 3
                    obj.c3 = obj.c3.*0.999+0.001.*[alpha,beta];
                case 4
                    obj.c4 = obj.c4.*0.999+0.001.*[alpha,beta];
                case 5
                    obj.c5 = obj.c5.*0.999+0.001.*[alpha,beta];
                case 6
                    obj.c6 = obj.c6.*0.999+0.001.*[alpha,beta];
                otherwise
                    error('wrong cluster selected');
            end
            
        end 
    end
    
end

