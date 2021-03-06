function model = trainsvm

addpath ..
addpath .\svm\matlab

%fileList=dir(fullfile('.','*.mat'));
ts = 0.001;

%select desired files form Database
startFileNo = 40;
endFileNo =  78;
runList = [startFileNo:endFileNo]; % set a vector with desired samples here!

runList=[12:32, 35:78];

%load shifts;
load('labeledShifts2.mat');
[excelShifts, excelText] =  xlsread('shifts.xlsx','shiftsForMatlab');
[a textLineLength]=size(excelText);

checkDetected =0;

jj=1;

for jj = runList
    
    for ii = 1:textLineLength
        exText = excelText{jj,ii};
        if ~(isempty(exText))
            checkDetected =1;
        end
    end
    
    if checkDetected ==1
        display(['samples skipped Check data first at Line: ',num2str(jj)]);
        checkDetected =0;
        continue;
    end
    
    if jj> 1
        len = len+ length (trainingLabels(:,1));
    else
        len=0;
    end
    trainingLabels =  labelsforTransitions{jj};
    labels(len+1:len+length(trainingLabels(:,1))) = trainingLabels(:,11);
    trainingSamples(len+1:len+length(trainingLabels(:,1)),:) = ...
        [trainingLabels(:,1),trainingLabels(:,2), trainingLabels(:,3), trainingLabels(:,4),trainingLabels(:,5),...
        trainingLabels(:,6),trainingLabels(:,7),trainingLabels(:,8)];
    jj=jj+1;
end

%% normalize valus
for jj=1:8
    meanTsamples(jj) = mean(trainingSamples(:,jj));
    stdTsamples(jj) = std(trainingSamples(:,jj));
    trainingSamplesNorm(:,jj) = (trainingSamples(:,jj)-meanTsamples(jj))./stdTsamples(jj);
end
%labels = trainingLabels(:,11);
svmOptionString= '-b -s 2 -t 3';
model = svmtrain2(labels',trainingSamplesNorm,svmOptionString);
save('svmModel.mat','model', 'meanTsamples', 'stdTsamples', 'svmOptionString');