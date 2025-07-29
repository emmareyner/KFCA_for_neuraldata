function l = logit(p)
%function l = logit(p)
% Returns the logit of probability p as l=log(p/(1-p)). Base of logarithm
% is e.
% 
% The inverse function is 

if any(any((p>1) | (p<0)))
        error('double:logit','input is not a probability in function logit')
end
l = log(p./(1-p));
return
