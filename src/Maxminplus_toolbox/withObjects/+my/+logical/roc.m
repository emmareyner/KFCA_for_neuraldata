function [TP,TN,FP,FN]=roc(S,R)
% function [TP,TN,FP,FN]=roc(S,R)
%
% A primitive to compare two boolean matrices of the same dimension for a
% detection of 1's and 0's.
% S is the stimulus (real, true) matrix, and R the response (estimated,
% probable) matrix.
% It returns the matrices with the true positives, true negatives false
% positives and false negatives. From this it is very easy to plot points
% into a ROC curve.
if nargout > 0,
    sS = size(S);
    sR = size(R);
    if any(sS ~= sR),
        error('my:logical:roc','non-conformant input matrices');
    end
    %always return sparse results
    if ~issparse(S), S = sparse(S); end
    if ~issparse(R), R = sparse(R); end
    TP=S&R;
    if nargout > 1,
        TN=~(S|R);
        if nargout > 2,
            FP=(S<R);%quicker than ~S&&R
            if nargout > 3,
                FN=(S>R);%quicker than S&&~R
            end
            %The last is redundant so it might not be asked for.
        end
    end
end
return
