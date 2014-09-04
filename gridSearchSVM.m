function gridSearchSVM

addpath ..
addpath .\svm\matlab

%fileList=dir(fullfile('.','*.mat'));
ts = 0.001;

%select desired files form Database
startFileNo = 40;
endFileNo =  78;
runList = [startFileNo:endFileNo]; % set a vector with desired samples here!
%load shifts;
load('labeledShifts2.mat');
[excelShifts, excelText] =  xlsread('shifts.xlsx','shiftsForMatlab');
[a textLineLength]=size(excelText);

testSetNo = 16;

checkDetected =0;

jj=1;

for ii = runList
    
    for kk = 1:textLineLength
        exText = excelText{ii,kk};
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
    trainingLabels =  labelsforTransitions{ii};
    labels(len+1:len+length(trainingLabels(:,1))) = trainingLabels(:,11);
    labels2(len+1:len+length(trainingLabels(:,1))) = trainingLabels(:,9);
    trainingSamples(len+1:len+length(trainingLabels(:,1)),:) = ...
        [trainingLabels(:,1),trainingLabels(:,2), trainingLabels(:,3), trainingLabels(:,4),trainingLabels(:,5),...
        trainingLabels(:,6),trainingLabels(:,7),trainingLabels(:,8)];
    jj=jj+1;
end

testSet = labelsforTransitions{testSetNo};
testLabels = testSet(:,11);
lenTestSet = length(testLabels);

%% normalize valus
for ii=1:8
    meanTsamples(ii) = mean(trainingSamples(:,ii));
    stdTsamples(ii) = std(trainingSamples(:,ii));
    trainingSamplesNorm(:,ii) = (trainingSamples(:,ii)-meanTsamples(ii))./stdTsamples(ii);
end

gamma = -15:2;
C = -5:15;
t = [1, 2,3, 4];
indi=0;
for ii = C
    indi = indi+1;
    indj=0;
    for jj = gamma        
        indj = indj+1;
        indt=0;
%         for mm = t
            indt = indt+1;
     %   for kk = runList
%             for mm = 1:textLineLength
%                 exText = excelText{kk-35,mm};
%                 if ~(isempty(exText))
%                     checkDetected =1;
%                 end
%             end
%             
%             if checkDetected ==1
%                 checkDetected =0;
%                 continue;
%             end
            
            svmOptionString{indi,indj}= ['-s 0 -b 1 -g ',num2str(2^jj),' -c ',num2str(2^ii),' -t 2'];
            testmodel = svmtrain2(labels2',[trainingSamplesNorm(:,1)],svmOptionString);
            model = svmtrain2(labels',trainingSamplesNorm,svmOptionString{indi,indj});
            
            
            %labels = trainingLabels(:,11);
%             for mm = 1:textLineLength
%                 exText = excelText{kk-35,mm};
%                 if ~(isempty(exText))
%                     checkDetected =1;
%                 end
%             end
%             
%             if checkDetected ==1
%                 checkDetected =0;
%                 continue;
%             end
            
            
%             trainingLabels =  labelsforTransitions{kk};
            normCorX = trainingSamplesNorm(:,1);
            normMtx  = trainingSamplesNorm(:,2);
            normAx   = trainingSamplesNorm(:,3);
            normLx   = trainingSamplesNorm(:,4);
            normCorY = trainingSamplesNorm(:,5);
            normMty  = trainingSamplesNorm(:,6);
            normAy   = trainingSamplesNorm(:,7);
            normLy   = trainingSamplesNorm(:,8);
            trainNorm1 = (testSet(:,1)-meanTsamples(1))./stdTsamples(1);
            trainNorm2 = (testSet(:,2)-meanTsamples(2))./stdTsamples(2);
            trainNorm3= (testSet(:,3)-meanTsamples(3))./stdTsamples(3);
            trainNorm4 = (testSet(:,4)-meanTsamples(4))./stdTsamples(4);
            trainNorm5 = (testSet(:,5)-meanTsamples(5))./stdTsamples(5);
            trainNorm6 = (testSet(:,6)-meanTsamples(6))./stdTsamples(6);
            trainNorm7 = (testSet(:,7)-meanTsamples(7))./stdTsamples(7);
            trainNorm8 = (testSet(:,8)-meanTsamples(8))./stdTsamples(8);
            
            
           % [svmOut{indi,indj}, accuracy{indi,indj}, dec_values{indi,indj}]   = svmpredict(labels',trainingSamplesNorm,model);
           a = trainingSamplesNorm;
    %       [svmOut{indi,indj}, accuracy{indi,indj}, dec_values{indi,indj}] = svmpredict([-4;4;-3],[a(3:5,1),a(3:5,2),a(3:5,3),a(3:5,4),a(3:5,5),a(3:5,6),a(3:5,7),a(3:5,8)],model);
           [svmOut{indi,indj}, accuracy{indi,indj}, dec_values{indi,indj}]  = svmpredict(testLabels,[trainNorm1,trainNorm2,trainNorm3,trainNorm4,trainNorm5,trainNorm6,trainNorm7,trainNorm8],model);
%             testsvmOut = svmpredict(1,(normCorX(1)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(2)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(3)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(4)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(5)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(6)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(7)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(8)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(9)),testmodel);
%             testsvmOut = svmpredict(1,(normCorX(10)),testmodel);
   %     end
        clear model
%         end
    end
end


keyboard;



end
