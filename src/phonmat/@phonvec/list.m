function [absvals,probs] = list ( pv )

absvals = pv.vec;
probs = probabilitize (absvals);
 