function [r,p,phons] = correl (pv1, pv2,dopic)

% CORREL finds the correlation of the intersection of two PHONVEC objects
%
%        [r,p,phons] = correl (pv1, pv2, [dopic])
% 
% if dopic is not zero (0 = default) then a picture appears.
%  if dopic is 10, poorly placed labels appear on points.

if nargin<3,dopic=0;end
L1 = pv1.labels;
L2 = pv2.labels;
phons = findcommon (L1.phones, L2.phones)
PV1 = sub (pv1, phons);
PV2 = sub (pv2, phons);
[r,t,p] = correl (PV1.vec, PV2.vec);
if dopic
  figure; plot (PV1.vec, PV2.vec,'bo');
  % add text
  if 10 == dopic 
   for i = 1 : length(PV1.vec)
     ph = phons(i);
     if cmp (ph,'_')
       ph = '\_';
     end
     x = PV1.vec (i);
     y = PV2.vec (i);
     text (x+0.2,y,ph);
   end
 end
end


