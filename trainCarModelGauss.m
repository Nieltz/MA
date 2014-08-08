function [ mu1, mu2, mu3, mu4, mu5, mu6, mu7, v1, v2,v3,v4,v5,v6,v7 ] = trainCarModelGauss ()
% function to determin Gaussian ddistribution for labeled Data
addpath RecordedData

load('LabeledFeatures.mat');

i1 = 0;
i2 = 0;
i3 = 0;
i4 = 0;
i5 = 0;
i6 = 0;
i7 = 0;

feat1Old=[];
feat2Old=[];
feat3Old=[];
feat4Old=[];
feat5Old=[];
feat6Old=[];
feat7Old=[];

for ii = 1:length(labeledFeatures)
    features = labeledFeatures{ii};
    
    if isempty(features)
        continue
    end
    % initialize memory for features
    feat1=zeros(length(feat1Old) + length(features(features(:,3)==1)),2);
    feat2=zeros(length(feat2Old) + length(features(features(:,3)==2)),2);
    feat3=zeros(length(feat3Old) + length(features(features(:,3)==3)),2);
    feat4=zeros(length(feat4Old) + length(features(features(:,3)==4)),2);
    feat5=zeros(length(feat5Old) + length(features(features(:,3)==5)),2);
    feat6=zeros(length(feat6Old) + length(features(features(:,3)==6)),2);
    feat7=zeros(length(feat7Old) + length(features(features(:,3)==7)),2);
    
    % copy of previous iterations to new memory
    if ~isempty(feat1Old)
        feat1(1:length(feat1Old),:)=feat1Old;
    end
    if ~isempty(feat1Old)
        feat2(1:length(feat2Old),:)=feat2Old;
    end
    if ~isempty(feat1Old)
        feat3(1:length(feat3Old),:)=feat3Old;
    end
    if ~isempty(feat1Old)
        feat4(1:length(feat4Old),:)=feat4Old;
    end
    if ~isempty(feat1Old)
        feat5(1:length(feat5Old),:)=feat5Old;
    end
    if ~isempty(feat1Old)
        feat6(1:length(feat6Old),:)=feat6Old;
    end
    if ~isempty(feat1Old)
        feat7(1:length(feat7Old),:)=feat7Old;
    end
    
    % Read new features
    feat1(length(feat1Old)+1:end,:) =  features(features(:,3)==1,1:2);
    feat2(length(feat2Old)+1:end,:) =  features(features(:,3)==2,1:2);
    feat3(length(feat3Old)+1:end,:) =  features(features(:,3)==3,1:2);
    feat4(length(feat4Old)+1:end,:) =  features(features(:,3)==4,1:2);
    feat5(length(feat5Old)+1:end,:) =  features(features(:,3)==5,1:2);
    feat6(length(feat6Old)+1:end,:) =  features(features(:,3)==6,1:2);
    feat7(length(feat7Old)+1:end,:) =  features(features(:,3)==7,1:2);
    
    feat1Old = feat1;
    feat2Old = feat2;
    feat3Old = feat3;
    feat4Old = feat4;
    feat5Old = feat5;
    feat6Old = feat6;
    feat7Old = feat7;
    

m1X = mean(feat1Old(:,1));
m1Y = mean(feat1Old(:,2));
m2X = mean(feat2Old(:,1));
m2Y = mean(feat2Old(:,2));
m3X = mean(feat3Old(:,1));
m3Y = mean(feat3Old(:,2));
m4X = mean(feat4Old(:,1));
m4Y = mean(feat4Old(:,2));
m5X = mean(feat5Old(:,1));
m5Y = mean(feat5Old(:,2));
m6X = mean(feat6Old(:,1));
m6Y = mean(feat6Old(:,2));
m7X = mean(feat7Old(:,1));
m7Y = mean(feat7Old(:,2));

v1 = cov(feat1Old(:,1),feat1Old(:,2));
v2 = cov(feat2Old(:,1),feat2Old(:,2));
v3 = cov(feat3Old(:,1),feat3Old(:,2));
v4 = cov(feat4Old(:,1),feat4Old(:,2));
v5 = cov(feat5Old(:,1),feat5Old(:,2));
v6 = cov(feat6Old(:,1),feat6Old(:,2));
v7 = cov(feat7Old(:,1),feat7Old(:,2));

mu1=[m1X,m1Y];
mu2=[m2X,m2Y];
mu3=[m3X,m3Y];
mu4=[m4X,m4Y];
mu5=[m5X,m5Y];
mu6=[m6X,m6Y];
mu7=[m7X,m7Y];

       

        
        



end
    a= -20:0.5:20;
            b= -20:0.5:20;
            [A,B]=meshgrid(a,b);
%             F= mvnpdf([A(:) B(:)],mu1,v1);
%             F = reshape(F,length(b),length(a));
            figure;
%             surf(a,b,F)
            F= mvnpdf([A(:) B(:)],mu2,v2);
            F = reshape(F,length(b),length(a));
%             hold on
            surf(a,b,F)
%             F= mvnpdf([A(:) B(:)],mu3,v3);
%             F = reshape(F,length(b),length(a));
%             hold on
%             surf(a,b,F)
            F= mvnpdf([A(:) B(:)],mu4,v4);
            F = reshape(F,length(b),length(a));
            hold on
            surf(a,b,F)
%             F= mvnpdf([A(:) B(:)],mu5,v5);
%             F = reshape(F,length(b),length(a));
%             hold on
%              surf(a,b,F)
%             F= mvnpdf([A(:) B(:)],mu6,v6);
%             F = reshape(F,length(b),length(a));
%             hold on
%             surf(a,b,F);


end
