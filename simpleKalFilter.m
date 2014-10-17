classdef simpleKalFilter < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        r1;
        r2;
        A;
        Q;
        R;
        P;
        H;
        I;
        x;
    end
    
    methods
        function obj = simpleKalFilter()
            obj.r1=10;
            obj.r2=0.1;
            
            obj.x = [0;0;0;0;0;0];
            
            obj.A= [1,0,ts,0,-ts,0;
                0,1,0,ts,0,-ts;
                0,0,1,0,0,0;
                0,0,0,1,0,0;
                0,0,0,0,1,0;
                0,0,0,0,0,1];
            
            obj.Q = [0.0005,0,0,0,0,0;
                0,0.0005,0,0,0,0;
                0,0,0.0005,0,0,0;
                0,0,0,0.0005,0,0;
                0,0,0,0,0.0005,0;
                0,0,0,0,0,0.0005];
            
            obj.R = [obj.r1,0,0,0;
                0,obj.r1,0,0;
                0,0,obj.r2,0;
                0,0,0,obj.r2];
            
            obj.P= eye(6);
            
            obj.H=[1,0,0,0,0,0;
                0,1,0,0,0,0;
                0,0,1,0,0,0;
                0,0,0,1,0,0];
            obj.I = eye(6);
        end
        
        function [thx, thy] = run(obj,aX,aY,aZ,gZ,gY)
            obj.x = obj.A*obj.x;
            obj.P = obj.A*obj.P*obj.A' + obj.Q;
            z = [-atan2d(aX,aZ),atan2d(aY,aZ),waccy,waccx];
            y = z' - obj.H*obj.x;
            obj.S = obj.H*obj.P*obj.H' + obj.R;
            K = obj.P*obj.H'*inv(obj.S);
            obj.x = obj.x + K*y;
            obj.P = (obj.I-K*obj.H)*obj.P;
            thx=obj.x(1);
            thy=obj.x(2);          
        end
        
    end
    
end

