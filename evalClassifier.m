function evalClassifier()
%evalClassifier Evaluates means and ghaussian classifiers
%   The labels are read from Excel then a for each training set
%   clasification is done and compared to the labels


runList = [1:78];%40:78];

movementDetection =0;
%load shifts;
if movementDetection ==1
    load('labeledShifts2.mat');
    labelPos= 11;
else
    load('labeledShiftswAngles.mat');
    labelsforTransitions = labelsForTransitionsWAngles;
    labelPos= 15;
    
end

[excelShifts, excelText] =  xlsread('shifts.xlsx','shiftsForMatlab');
[a textLineLength]=size(excelText);

readGearDatabase;



checkDetected =0;

jj=1;
ts = 0.001;
filterWidth =300;
%% loop over files
for ii = runList
    fileName = gearFiles{ii};
    load(fileName);
    for kk = 1:textLineLength
        exText = excelText{ii,kk};
        if ~(isempty(exText))
            checkDetected =1;
        end
    end
    
    if (checkDetected ==1|| isempty(labelsforTransitions{ii}))
        display(['samples skipped Check data first at Line: ',num2str(jj)]);
        checkDetected =0;
        continue;
    end
    %% create objects
    shiftClassifier = shiftClusters;
    shiftDetectorObj = shiftDetector(485,25);
    classifier = stDetector();
    
    %% initialize variables
    dist = zeros(filterWidth,2);
    clust= ones(length(aX),1);
    clust(1:filterWidth)=4;
    startShift=51;
    shift=zeros(length(aX),1);
    shifts = 0;
    totalCount = 0;
    countMean = [0,0];
    countGauss1 = [0,0];
    countGauss2 = [0,0];
    trainingLabels =  labelsforTransitions{ii};
    res(1) = trainingLabels(1,labelPos-1);
    %% run Kalman filter
    [thx, thy] = simpleKalFilt(aX,aY,aZ,gZ,gY,ts);
    %% run classification loop
    for jj = filterWidth:length(aX)
        
        %% run shift detection
        [shift(jj), startShift(jj), shiftPower] = shiftDetectorObj.shiftDetection2(aX(jj),aY(jj),aZ(jj),gY(startShift-50:jj-100),jj);
        
        if ((shift(jj-1)== 1 && shift(jj)==0 && jj-startShift(jj)>150)||(shift(end)==1))
            if ((abs(shiftPower) > 4500) || (shift(end)==1))
                shifts=shifts+1;
               % res(shifts+1) = trainingLabels(shifts,labelPos);
            end
        end
        if shift(jj) ==0
            [clust(jj), dist] = shiftClassifier.run(-thy(jj),thx(jj),dist(clust(jj-1),:));
            p1{jj}= classifier.calcML([thx(jj),thy(jj)]);
            p2{jj}= classifier.calcML2([thx(jj),thy(jj)]);
            [blubb detOut1(jj)] = max(p1{jj});
            [blubb detOut2(jj)]= max(p2{jj});
            %% compare results
            if  clust(jj) == res(shifts+1)
                countMean(1) = countMean(1)+1;
            else
                countMean(2) = countMean(2)+1;
            end
            if  detOut1(jj) == res(shifts+1)
                countGauss1(1) = countGauss1(1)+1;
            else
                countGauss1(2) = countGauss1(2)+1;
            end
            if  detOut2(jj) == res(shifts+1)
                countGauss2(1) = countGauss2(1)+1;
            else
                countGauss2(2) = countGauss2(2)+1;
            end
            totalCount = totalCount+1;
            
            
        else
            dist = zeros(7,2);
        end
        
        
    end
    results{ii} = [countMean,countGauss1,countGauss2,totalCount];
    %keyboard;
    
end
keyboard;