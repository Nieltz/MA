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
            obj.ax(mod(ii,500)+1)=ax;
            obj.ay(mod(ii,500)+1)=ay;
            obj.az(mod(ii,500)+1)=az;
            diffx = abs(max(obj.ax)-min(obj.ax));
            diffy = abs(max(obj.ay)-min(obj.ax));
            diffz = abs(max(obj.az)-min(obj.ax));
            
            if (diffx>obj.threshold)||(diffy>obj.threshold)||(diffz>obj.threshold)
                shiftDetect = 1;
                likelyhood=1;
            else
                shiftDetect = 0;
                likelyhood=0;
            end
        end
        
        function [shiftDetect , likelyhood] = shiftDetection3(obj, thx)
        end
    end
    
end

