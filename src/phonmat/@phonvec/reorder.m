function newpv = reorder(pv)

% REORDER returns a new PHONVEC object that is a sorted version of pv
%
%	newpv = reorder (pv)

L = pv.labels;
ph = L.phones;

[sortedvals, ordering] = sort (-pv.vec);
vec2 = pv.vec (ordering);
phones2 = ph (ordering);

newpv = phonvec (phones2, vec2, pv.title);   
   