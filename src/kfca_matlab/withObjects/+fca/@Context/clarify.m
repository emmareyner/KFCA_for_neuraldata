function [Kout]=clarify(Kin)
%function [Kout]=clarify(Kin)
%
% Clarifies a maxplus formal context. Clarification, in K-FCA refers to
% the incidence not having full bottom rows or columns. These are
% always sent to the bottom or top concept.
%
% - Kin is the input boolean context
% - Kout is the output boolean context with:
%    - Kout.R is the same as K.R
%    - Kout.iG and Kout.iM are the indexes that allow to select the
%    clarified matrix from Kout.I
%    - Kout.g and Kout.m are also modified to reflect the dimensions of
%    the clarified context.
%    - Kout.qG and Kout.qM 
%       - Kout.qG is a (1 x size(Kout.R,1) row each of whose cells says to
%       which class the row indexed by that cell belongs. Those cols
%       tagged with -Inf are rows initially set to mp_zero in Kout.R
%       - Kout.qM is a (1 x size(Kout.R,2) row each of whose cells says to
%       which class the column indexed by that cell belongs. Those cols
%       tagged with -Inf are columns initially set to mp_zero in Kout.R
%
if Kin.clarified 
    warning('fca:Context:clarify','Input context already clarified: nothing done');
    Kout = Kin;
else
    Kout = clarify@fca.Precontext(Kin);%copy and mark as clarified
    
    [g,m]=realsize(Kout);
    %1. clarify rows
    %1.1. Find unique rows and which classes they belong to
    [Icr,classes_objs,blocks_objs]=unique(Kout.I,'rows','first');
    Kout.iG=false(g,1);Kout.iG(classes_objs)=true;
    Kout.qG=classes_objs(blocks_objs);%translate blocks into original ones
    %Kout.iG =  classes_objs;
    %Kout.qG = blocks_objs;
    %2. Clarify cols
    %1.1. Find unique cols and which classes they belong to
    [unused, classes_atts,blocks_atts]=unique(Icr','rows','first');
    Kout.iM=false(m,1);Kout.iM(classes_atts)=true;
    Kout.qM=classes_atts(blocks_atts);%translate blocks into original ones
end

return%Kout

