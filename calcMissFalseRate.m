function [correctMean, correctGauss1, correctGauss2, falseMean,falseGauss1,...
    falseGauss2,sumTotal, dRate, fdRate] =  calcMissFalseRate(standalone, range)

if standalone ==1
    load('classifierResult.mat');
end

correctMean = 0;
correctGauss1 = 0;
correctGauss2 = 0;

falseMean = 0;
falseGauss1 = 0;
falseGauss2 = 0;
sumTotal = 0;

for ii = range;
    if ~isempty(results{ii})
        res = results{ii};
        correctMean = correctMean + res(1);
        correctGauss1 = correctGauss1 + res(3);
        correctGauss2 = correctGauss2 + res(5);
        
        falseMean = falseMean + res(2);
        falseGauss1 = falseGauss1 + res(4);
        falseGauss2 = falseGauss2 + res(6);
        
        sumTotal = sumTotal + res(7);
    end
end
dRate(1) =correctMean/sumTotal ;
dRate(2) =correctGauss1/sumTotal ;
dRate(3) =correctGauss2/sumTotal ;
fdRate(1) = falseMean/sumTotal ;
fdRate(2) = falseGauss1/sumTotal ;
fdRate(3) = falseGauss2/sumTotal ;