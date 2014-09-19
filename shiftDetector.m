classdef shiftDetector < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        threshold;
        range;
        holdtime;
        ax;
        ay;
        az;
        alpha;
        maskLength;
        spaceLength;
    end
    
    methods
        function obj = shiftDetector(range, threshold)
            % Constructor
            obj.range = range*9.81;
            obj.threshold = threshold;
            obj.holdtime = 500;
            obj.ax=zeros(500,1);
            obj.ay=zeros(500,1);
            obj.az=zeros(500,1);
        end
        
        function [ shiftDetect, likelyhood]  = shiftDetection(obj, ax,ay,az )
            % shiftDetection; This functions determines if a shift has been detected and
            % returns the likelyhood of it
            px=1/ (obj.range/(abs(ax)));
            py=1/ (obj.range/(abs(ay)));
            pz=1/ (obj.range/(abs(az)));
            
            likelyhood = px*py*pz;
            if likelyhood > obj.threshold
                shiftDetect = 1;
                obj.holdtime=50;
            elseif obj.holdtime > 0
                obj.holdtime=obj.holdtime-1;
                shiftDetect = 1;
            else
                shiftDetect=0;
            end
        end
        function [ shiftDetect, likelyhood]  = shiftDetection2(obj, ax,ay,az,ii)
            % this function compares the acceleration to a given threshold
            % and triggers a shift if the acceleratrion is higer than the
            % threshold.
            obj.ax(mod(ii,500)+1)=ax;
            obj.ay(mod(ii,500)+1)=ay;
            obj.az(mod(ii,500)+1)=az;
            diffx = abs(max(obj.ax)-min(obj.ax));
            diffy = abs(max(obj.ay)-min(obj.ay));
            diffz = abs(max(obj.az)-min(obj.az));
            
            if (diffx>obj.threshold)||(diffy>obj.threshold)||(diffz>obj.threshold)
                shiftDetect = 1;
                likelyhood=1;
            else
                shiftDetect = 0;
                likelyhood=0;
            end
        end
        
        
        function [shiftDetect , likelyhood] = shiftDetectionCa_Cfar(obj, aX)
            %CA_CFAR
            i_data=aX;
            maxVal=[];
            maxLoc=[];
            
            mask=ones(obj.maskLength,1);
            mask(obj.maskLength/2-obj.spaceLength:obj.maskLength/2+obj.spaceLength)=0;
            
            N=sum(mask);
            mask=find(mask);
            for i=0:size(i_data,1)-obj.maskLength-1
                th=sum(i_data(i+mask))/N;
                if alpha*th<i_data(i+floor(obj.maskLength/2)+1)
                    maxLoc=[maxLoc,i+floor(obj.maskLength/2)+1];
                    maxVal=[maxVal,i_data(i+floor(obj.maskLength/2)+1)];
                end
            end
            
            
        end
        
        function [shiftDetect , likelyhood] = shiftDetectionOs_Cfar(obj, aX)
            
        end
        
        function [ maxVal,maxLoc ] = CA_CFAR( data,alpha,maskLength,spaceLength )
            %CA_CFAR
            i_data=data(:);
            maxVal=[];
            maxLoc=[];
            
            mask=ones(maskLength,1);
            mask(maskLength/2-musd:maskLength/2+spaceLength)=0;
            
            N=sum(mask);
            mask=find(mask);
            for i=0:size(i_data,1)-maskLength-1
                th=sum(i_data(i+mask))/N;
                if alpha*th<i_data(i+floor(maskLength/2)+1)
                    maxLoc=[maxLoc,i+floor(maskLength/2)+1];
                    maxVal=[maxVal,i_data(i+floor(maskLength/2)+1)];
                end
            end
            
            
        end
        
        
        
    end
    
end

