classdef MarkovChain
    % This class contains the transition probabilities for a MarkovModel for the shift classification.
    % The probabilities define the likelyhood of a selected gear after a valid shift Event has occured.
    %
    
    properties (Constant)
        tMatrix =[ 0.25	0.6	0.05	0	0	0	0.1;
            0.35	0.1	0.35	0.1	0	0	0.1;
            0.1	0.3	0.15	0.3	0.05	0	0.1;
            0.1	0.1	0.3	0.1	0.3	0	0.1;
            0.025	0.075	0.1	0.6	0.1	0	0.1;
            0.7	0	0	0	0	0.1	0.2;
            0.35	0.1	0.05	0.05	0.05	0.3	0.1];
            
            end
            
            methods
            function obj = MarkovChain()
                
            end
            function out = getProb(obj,state)
                out = obj.tMatrix(state,:);
            end
            end
            
    end
    
