function subpm = reorder (pm,firstlabels)

% REORDER member function of class PHONMAT that reorders the object
%    subpm = reorder (pm,firstlabels)
%
%    pm is of type PHONMAT and firstlabels a string with k onelabels of pm. 
%      These k onelabels should become the first phones of subpm.
%      The remaining phones of subpm are the same as those of pm, in the
%      same order.
%    The title of subpm is the same as that of pm.

subpm = sub (pm, charcat(firstlabels, stringremove (get(pm,'phones'), firstlabels)));


