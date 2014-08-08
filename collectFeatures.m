% Function for feature labeling

function labeledFeatures = collectFeatures(thx,thy,shifts,labels)

% Format of matrix should look like this:
% matrix(thx, thy, label)

lFeatures = zeros(length(thx),3);
lFeatures(:,1)=thx;
lFeatures(:,2)=thy;

kk = 1; % Label number
waiter = 50; % Wait variable
waitForShift = waiter;
for ii = 1:length(thx)
    if waitForShift == 0 % wait until shift is over
        if kk <=length(shifts)
            if ii==shifts(kk)
                % last set to label
                kk=kk+1;
                waitForShift = waiter;
            end
            % Sample was valid so reset wait variable
            
        end
        % copy samples
        lFeatures(ii,3)=labels(kk);
    else
        %skip samples
        waitForShift = waitForShift-1;
        continue
    end
end
kk=1;
labeledFeatures= zeros(sum(lFeatures(:,1)~=0),3);
for ii = 1:length(thx)
    if lFeatures(ii,1)~=0
        labeledFeatures(kk,:) = lFeatures(ii,:);
        kk=kk+1;
    end
end