classdef stDetector
    %stDetector Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % covariance matrices
        v1;
        v2;
        v3;
        v4;
        v5;
        v6;
        v7;
        % mean values
        mu1;
        mu2;
        mu3;
        mu4;
        mu5;
        mu6;
        mu7;
        currentState;
        markovMod;
        prob;
    end
    
    properties (Constant)
        D=2; % Dimension =2
        
    end
    
    
    methods
        function obj = stDetector()
            % load vars and mus
            [ obj.mu1, obj.mu2, obj.mu3, obj.mu4, obj.mu5, obj.mu6, obj.mu7,...
                obj.v1, obj.v2,obj.v3,obj.v4,obj.v5,obj.v6,obj.v7 ] = trainCarModelGauss ();
            obj.currentState =1;
            obj.markovMod = MarkovChain();
        end
        
        function init(obj)
            % this function must determine the first state.....
        end
        
        function  p= getPDF(obj,x,C,mu)
            p= 1/((2*pi)*sqrt(det(C)))*exp(-0.5*(mu-x)*C^(-1)*(mu-x)');
        end
        
        function p =calcML(obj,x)
            
            obj.v1=eye(2)*5;
            obj.v2=eye(2)*5;
            obj.v3=eye(2)*5;
            obj.v4=eye(2)*5;
            obj.v5=eye(2)*5;
            obj.v6=eye(2)*5;
            obj.v7=eye(2)*5;
            
            mus= [obj.mu1; obj.mu2; obj.mu3; obj.mu4; obj.mu5; obj.mu6; obj.mu7];
            vs =  {obj.v1, obj.v2, obj.v3,obj.v4, obj.v5, obj.v6, obj.v7};
            %    vs =  {abs(obj.v1).*5+1, abs(obj.v2).*5+1, abs(obj.v3).*5+1, abs(obj.v4).*5+1, abs(obj.v5).*5+1, (obj.v6).*5+1, abs(obj.v7).*5+1};
            
            % calc pdf for current state:
            switch (obj.currentState)
                case 1
                    p1 = obj.getPDF(x,obj.v1,obj.mu1);
                case 2;
                    p1 = obj.getPDF(x,obj.v2,obj.mu2);
                case 3;
                    p1 = obj.getPDF(x,obj.v3,obj.mu3);
                case 4;
                    p1 = obj.getPDF(x,obj.v4,obj.mu4);
                case 5;
                    p1 = obj.getPDF(x,obj.v5,obj.mu5);
                case 6;
                    p1 = obj.getPDF(x,obj.v6,obj.mu6);
                case 7;
                    p1 = obj.getPDF(x,obj.v7,obj.mu7);
            end
            
            mProb = obj.markovMod.getProb(obj.currentState);
            p=zeros(7,1);
            
            % calc Likelyhood ratios to other functions
            for ii= 1:7
                if ii == obj.currentState
                    continue
                end
                
                p(ii) = (obj.getPDF(x,vs{ii},mus(ii,:)) / p1) * mProb(ii);
            end
        end
        function [p,selProb, ind] =calcML2(obj,x)
            mProb = obj.markovMod.getProb(obj.currentState);
            
            obj.prob(1) = obj.getPDF(x,obj.v1,obj.mu1)*mProb(1);
            obj.prob(2) = obj.getPDF(x,obj.v2,obj.mu2)*mProb(2);
            obj.prob(3) = obj.getPDF(x,obj.v3,obj.mu3)*mProb(3);
            obj.prob(4) = obj.getPDF(x,obj.v4,obj.mu4)*mProb(4);
            obj.prob(5) = obj.getPDF(x,obj.v5,obj.mu5)*mProb(5);
            obj.prob(6) = obj.getPDF(x,obj.v6,obj.mu6)*mProb(6);
            obj.prob(7) = obj.getPDF(x,obj.v7,obj.mu7)*mProb(7);
            p=obj.prob;
            [selProb, ind] = max(p);
            
        end
        function drawPdfs(obj)
            a= 20:-0.5:-20;
            b= 20:-0.5:-20;
            [A,B]=meshgrid(a,b);
            F= mvnpdf([A(:) B(:)],obj.mu1,obj.v1);
            F = reshape(F,length(b),length(a));
            h1=figure;
            surf(a,b,F)
            F= mvnpdf([A(:) B(:)],obj.mu2,obj.v2);
            F = reshape(F,length(b),length(a));
            hold on
            surf(a,b,F)
            F= mvnpdf([A(:) B(:)],obj.mu3,obj.v3);
            F = reshape(F,length(b),length(a));
            hold on
            surf(a,b,F)
            F= mvnpdf([A(:) B(:)],obj.mu4,obj.v4);
            F = reshape(F,length(b),length(a));
            hold on
            surf(a,b,F)
            F= mvnpdf([A(:) B(:)],obj.mu5,obj.v5);
            F = reshape(F,length(b),length(a));
            hold on
            surf(a,b,F)
            
            xlabel('Angle Phi in Deg');
            ylabel('Angle Theta in Deg');
            zlabel('Probability Density');
%             F= mvnpdf([A(:) B(:)],obj.mu6,obj.v6);
%             F = reshape(F,length(b),length(a));
%             hold on
%             surf(a,b,F);
        end
    end
    
end

