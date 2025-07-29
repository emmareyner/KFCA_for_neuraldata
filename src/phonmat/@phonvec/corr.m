function [r,p,phons] = correl (pv1, pv2, phns, dopic)

% CORREL finds the correlation of the intersection of two PHONVEC objects
%
% [r,p,phons] = correl (pv1, pv2, phns, dopic)
%
%  phns and dopic are optional.

if nargin < 3,
  phns = pv1.labels.phones;
  dopic = 0;
elseif nargin < 4
  if isnumeric (phns)
    dopic = phns;
    phns = pv1.labels.phones;
  else
    dopic = 0;
  end;
end;


phons = findcommon (pv1.labels.phones, phns);
phons = findcommon (pv2.labels.phones, phons);
PV1 = sub (pv1, phons);
PV2 = sub (pv2, phons);
[r,t,p] = correl (PV1.vec, PV2.vec);

if dopic
   figure;
   plot (PV1.vec, PV2.vec, 'ko');
end;