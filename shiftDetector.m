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
        shiftDetected;
        startIndex;
    end
    
    methods
        function obj = shiftDetector(window, threshold)
            addpath .\..\tools;
            % Constructor
            obj.range =0; %range*9.81;
            obj.threshold = threshold;
            obj.holdtime = window;
            obj.ax=zeros(window,1);
            obj.ay=zeros(window,1);
            obj.az=zeros(window,1);
            obj.shiftDetected=0;
            obj.startIndex=51;
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
        function [ shiftDetect, stInd,shiftPower]  = shiftDetection2(obj, ax,ay,az,gy,ii)
            % this function compares the acceleration to a given threshold
            % and triggers a shift if the acceleratrion is higer than the
            % threshold.
            obj.ax(mod(ii,obj.holdtime)+1)=ax;
            obj.ay(mod(ii,obj.holdtime)+1)=ay;
            obj.az(mod(ii,obj.holdtime)+1)=az;
            diffx = abs(max(obj.ax)-min(obj.ax));
            diffy = abs(max(obj.ay)-min(obj.ay));
            diffz = abs(max(obj.az)-min(obj.az));
            
            if (diffx>obj.threshold)%||(diffy>obj.threshold)||(diffz>obj.threshold)

                if obj.shiftDetected==0
                    obj.shiftDetected=1; % marker shift is ongoing
                    obj.startIndex = ii;
                end
                
                shiftDetect = 1;
                shiftPower =0;
            else
                if obj.shiftDetected==1
                     obj.shiftDetected=0; % marker shift is ongoing
                     shiftPower=sum(gy);
                else
                      shiftPower =0;
                end
                shiftDetect = 0;
            end
            stInd= obj.startIndex;
            
        end
        
        
        function [shiftDetect , likelyhood] = shiftDetectionCa_Cfar(obj, ax,ay,az,slen,mlen,alpha)
            spaceLength = slen;
            maskLength = mlen;
            alpha = alpha;
            [ maxVal,maxLoc ] = obj.CA_CFAR(ax,alpha,maskLength,spaceLength);
            likelyhood =0;
            shiftDetect = find(maxLoc~=0);
           likelyhood= maxLoc;
        end
        
        function [shiftDetect , likelyhood] = shiftDetectionOs_Cfar(obj, aX)
            
        end
        
        function [ maxVal,maxLoc ] = CA_CFAR(obj,data,alpha,maskLength,spaceLength )
            %CA_CFAR
            i_data=data(:);
            maxVal=[];
            maxLoc=[];
            
            mask=ones(maskLength,1);
            mask(maskLength/2-spaceLength:maskLength/2+spaceLength)=0;
            
            N=sum(mask);
            mask=find(mask);
            for i=0:size(i_data,1)-maskLength-1
                th=sum(i_data(i+mask))/N;
                thCheck = th * alpha;
                if thCheck<i_data(i+floor(maskLength/2)+1)
                    maxLoc=[maxLoc,i+floor(maskLength/2)+1];
                    maxVal=[maxVal,i_data(i+floor(maskLength/2)+1)];
                end
            end
            
            
        end
        
        
        
    end
    
end

