classdef kalFilter <handle
    %kalFilter Class contains kalManFilter Algorithm for car application
    
    properties
        A;
        B;
        P;
        Q;
        R;
        H;
        I;
        x;
        
        ts;
    end
    
    methods
        function obj =kalFilter()
            obj.ts = 0.001;
            
            % constructor creates object and sets up the covariance matrices
            q1= 0.001;
            q2= 0.0001;
            q3= 0.001;
            
            r1=1;
            r2=1;
            
            obj.setMatrices(q1,q2,q3, r1,r2)
            
        end
        
        function [thx,thy] = runFilter (obj,accx, accy,accz, waccy, waccx,shiftDetect)
            if shiftDetect == 0
                shiftDetect =-1;
            else
                 shiftDetect =0;
            end
            x_old1 =  obj.x(1);
            x_old2 = obj.x(2);
            obj.x = obj.A*obj.x+obj.B*(obj.x*shiftDetect);
            obj.P = obj.A*obj.P*obj.A' + obj.Q;
            z = [-atan2d(accx,accz)+(obj.x(1)*obj.ts*shiftDetect),atan2d(accy,accz)+(obj.x(2)*obj.ts*shiftDetect),waccy+(obj.x(3)*obj.ts*shiftDetect),waccx+(obj.x(4)*obj.ts*shiftDetect)];
            y = z' - obj.H*obj.x;
            S = obj.H*obj.P*obj.H' + obj.R;
            K = obj.P*obj.H'*inv(S);
            obj.x = obj.x + K*y;
            obj.P = (obj.I-K*obj.H)*obj.P;
            thx = obj.x(1);
            thy = obj.x(2);
        end
        
        function setMatrices(obj,q1,q2,q3, r1,r2)
            obj.x = [0;0;0;0];
            
            % transition Matrix
            obj.A= [1,0,obj.ts,0;
                0,1,0,obj.ts;
                0,0,1,0;
                0,0,0,1];
            
            % Control Matrix
            obj.B= [0,0,obj.ts,0;
                0,0,0,obj.ts;
                0,0,0,0;
                0,0,0,0];
            
            
            % Noise Matrix
            obj.Q = [0.0005,0,0,0;
                0,0.0005,0,0;
                0,0,0.0005,0;
                0,0,0,0.0005];
            
            % Measure Matrix
            obj.R = [r1,0,0,0;
                0,r1,0,0;
                0,0,r2,0;
                0,0,0,r2];
            
            % Covariance matrix;
            obj.P= eye(4);
            
            
            obj.H=[1,0,0,0;
                0,1,0,0;
                0,0,1,0;
                0,0,0,1];
            
            obj.I=eye(4);
        end
    end
    
    
end

