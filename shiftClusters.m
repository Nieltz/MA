classdef shiftClusters <stDetector
    %shiftClusters this class contains the mean values of the shift stick
    %positions and the functions to update those
    
    
    properties
        c0; % Pos Forward Left
        c1; % Pos Forward Middle
        c2; % Pos Forward Right
        c3; % Pos Rearward
        c4; % Pos Backward Left 
        c5; % Pos Backard Middle
        c6; % Pos Neutral
        distType; % Flag for Euclidean distance or mahalanobis distance
        adaptEnable % Flag to enable adaptation
    end
    
    methods
        function obj = shiftClusters(adaptEnable, dMahaEnable)
            stDetector();
            % Constructor
            if adaptEnable==0
                obj.c0 = [-8,15];
                obj.c2 = [0,15];
                obj.c4 = [8,15];
                obj.c6 = [0,0];
                obj.c1 = [-8,-15];
                obj.c3 = [0,-15];
                obj.c5 = [8,-15];
            else
               obj.c0 = fliplr(obj.mu1);
               obj.c1 = fliplr(obj.mu2);
               obj.c2 = fliplr(obj.mu3);
               obj.c3 = fliplr(obj.mu4);
               obj.c4 = fliplr(obj.mu5);
               obj.c5 = fliplr(obj.mu6);
               obj.c6 = fliplr(obj.mu7);               
            end
        end
        
        function [clust, di]= run (obj, alpha, beta,oldDist)
            if obj.adaptEnable==1
                alp = alpha + oldDist(1)/2;
                bet = beta + oldDist(2)/2;
            else
                alp = alpha;
                bet = beta;
            end
             if obj.distType ==0
                dist = obj.getEuclideanDistance(alp, bet);
             else
                dist = obj.getMahaDistance(alp, bet);
             end
             di=obj.updateD(alpha,beta);
            [d, clust] = min(dist);
            obj.updateC(clust-1, alp, bet);
            
        end
        
        function [dist] = getEuclideanDistance(obj,alpha, beta)
            dist(1) = sqrt( (obj.c0(1)-alpha)^2 + (obj.c0(2)-beta)^2);
            dist(2) = sqrt( (obj.c1(1)-alpha)^2 + (obj.c1(2)-beta)^2);
            dist(3) = sqrt( (obj.c2(1)-alpha)^2 + (obj.c2(2)-beta)^2);
            dist(4) = sqrt( (obj.c3(1)-alpha)^2 + (obj.c3(2)-beta)^2);
            dist(5) = sqrt( (obj.c4(1)-alpha)^2 + (obj.c4(2)-beta)^2);
            dist(6) = sqrt( (obj.c5(1)-alpha)^2 + (obj.c5(2)-beta)^2);
            dist(7) = sqrt( (obj.c6(1)-alpha)^2 + (obj.c6(2)-beta)^2);
            

        end
        
        function dist = getMahaDistance(obj,alpha,beta)
            dist(1)=sqrt((obj.c0-[alpha,beta])*inv(obj.v1')*(obj.c0-[alpha,beta])');
            dist(2)=sqrt((obj.c1-[alpha,beta])*inv(obj.v2')*(obj.c1-[alpha,beta])');
            dist(3)=sqrt((obj.c2-[alpha,beta])*inv(obj.v3')*(obj.c2-[alpha,beta])');
            dist(4)=sqrt((obj.c3-[alpha,beta])*inv(obj.v4')*(obj.c3-[alpha,beta])');
            dist(5)=sqrt((obj.c4-[alpha,beta])*inv(obj.v5')*(obj.c4-[alpha,beta])');
            dist(6)=sqrt((obj.c5-[alpha,beta])*inv(obj.v6')*(obj.c5-[alpha,beta])');
            dist(7)=sqrt((obj.c6-[alpha,beta])*inv(obj.v7')*(obj.c6-[alpha,beta])');          
        end
        
        function d=updateD(obj,alpha,beta)
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

