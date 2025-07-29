function [mP,mR,MP,MR,mF,MF,Hloss]=micro_macro_averagedPR(N11,N00,N01,N10)
% [mP,mR,MP,MR,mF,MF,Hloss]=my.logical.micro_macro_averagedPR(real,estimate)
% [mP,mR,MP,MR,mF,MF,Hloss]=my.logical.micro_macro_averagedPR(N11,N00,N01,N10)
%
% A primitive to estimate the micro and macro averaged precision and
% recall of a matrix of individuals (indexing rows) and classes(indexing
% columns). Each individual may possess many classes.
%
% Micro-precision is the average precision across ALL decisions taken
% irrespective of the class of the documents. 
% It is biased towards highly populated classes.
% 
% Macro precisión is the average precision across precision classes. it is
% not biased towards class populations.
%
% Input A)
% - [real] is the boolean matrix of correct classifications
% - [estimate] is the boolean matrix of estimated classification
%
% INput B) (obtain these values with my.logical.ROC(real,estimate)
% - N11 : true positives
% - N00 : true negatives
% - N01 : false positives
% - N10 : false negatives
%
% Output:
% - MP: macro averaged precision
% - MR: macro averaged recall
% - mP: micro averaged precision
% - mR: micro averaged recall
% - mF: micro averaged F-measure(F1)
% - MF: macro averaged F-measure(F1)
% - Hloss: Hamming loss
% FVA: ca 2010

switch nargin
    case 2
        real = N11;
        estimate = N00;
        if ~(islogical(real) && islogical(estimate))
            error('my:logical:micro_macro_averagedPR','function only works on logical matrices');
        end
        sR = size(real);
        sE = size(estimate);
        if any(sR~=sE)
            error('my:logical:micro_macro_averagedPR','function only works on same-sized matrices');
        end
        %Find true positives, true negatives, False positives and false negatives
        [N11,N00,N01,N10]=my.logical.roc(real,estimate);%#ok<ASGLU> %these are all boolean
    case 4%check N11, etc.
        if ~(islogical(N11) && islogical(N00) && islogical(N10) && islogical(N01))
            error('my:logical:micro_macro_averagedPR','function only works on logical matrices');
        end
        sN11 = size(N11);
        sN00 = size(N00);
        sN10 = size(N10);
        sN01 = size(N01);
        if ~(all(sN11 == sN00) && all(sN10 == N00) && all(sN01 == sN00))
            error('my:logical:micro_macro_averagedPR','function only works on same-sized matrices');
        end
    otherwise
        error(nargchk(nargin,2,4));
end

%sum(N11+N00+N01+N10)% is a constant row
%Suppose the columns correspond to the classes
N11=sum(N11); %N00=sum(N00);
N01=sum(N01); N10=sum(N10);
% macroaveraging computes a simple average over classes (MRS, 2008),
% chapter 8.
MP = (N11./(N11+N01));
MP(isnan(MP))=0;%delete 0/0
MP=mean(MP);
% macroaveraged recall
MR = (N11./(N11+N10));
MR(isnan(MR))=0;%delete 0/0
MR=mean(MR);
%microaveraged precision and Recall computes PR over all possible instances
%(MRS, 2008: Chap. 8)
mP = sum(N11)/sum(N11+N01);
mR = sum(N11)/sum(N11+N10);
%If requested, also return micro/macro F1
if nargout > 4
    mF = 2*(1/mP+1/mR)^(-1);
    MF = 2*(1/MP+1/MR)^(-1);
end
if nargout > 6
    Hloss = (sum(sum(+N01))+sum(sum(+N10)))/(numel(N01));
end
return%MP,MR,mP,mR(mF,MF,Hloss)
