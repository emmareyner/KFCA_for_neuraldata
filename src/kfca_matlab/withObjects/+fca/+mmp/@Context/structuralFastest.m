function Ks = structuralFastest(K,phi)
%function Ks = structuralFastest(K,phi)
% 
% A function to calculate the structural \phi-standard context of a maxplus
% formal context, in Ks. This has always a SPARSE incidence.
%
% Input:
% - [K], a maxminplus formal context K.
% - [phi], the pivot or minimum degree of existence requested. The higher
% phi, the less concepts in the lattice. If this is not provided, phi==0 is
% assumed.
%
% Output:
% - Ks, the structural context
%  - Kout, if requested, on exit, a  structural context for the given phi=K.Phis{end} has been added in at
%  K.Ks{end}, and the new element is returned in Kout.
%
% CAVEAT! K has to be irreducible!
%
% Author: FVA 2007-2009
% Doc: FVA 2007-2009

% FVA: Nov, 2008. Kout.Ks.I made sparse. Changed structural lattice
% defining formula to avoid inversion of matrix.
% FVA: Changed so that only the new structural context is returned. Operate
% with explore_in_phi to do the modifications to K.

%% data preparation
%When only providing a context, the structural context is for phi==0, the
%unit in maxminplus.

if nargin == 1, phi = 0; end

% At least clarify before operation!
%if ~K.clarified,
%   error('fca:mmp:Context:structural', 'clarify input context first');
%end

%% ON explored contexts, this acts like a retrieval operation
if K.explored
    warning('mmp:fca:Context:structural','Context fully explored already: doing retrieval');
    %now find the best approximation to the context requested
    exact = mmp_x_eq(K.Phis,phi);
    if  ~any(exact)%look for an approximation
        warning('fca:mmp:Context:structural','phi parameter %d is not an exact value of the incidence.',phi);
        lbounds = phi >= K.Phis;%detect lower bounds in Phis
        glb = max(K.phis(lbounds));% find greater lower bound
        warning('fca:mmp:Context:structural','using the closest value, %d',glb);
        exact = mmp_x_eq(K.Phis,glb);
    end
    place = find(exact,1);
    Ks = K.Ks(place);
    return%Kout
end
%% 
[newg newm]= size(K);


for i=1:newg        
    for j=1:newm
        %Compare intents or extents (both produce the same results) Both
        %are column vectors, remember    
        I(i,j)=K.R(i,j)<phi;
    end
end

%full(I)
%I=not(I);%This is for <=!
%I=mp_ldiv(gamma_ext,mu_ext);%This is the mp operation

%% Append this structural lattice to the output context
[vG, vM]=concat_labels(K);
name = sprintf('%s_structural_%f',K.Name,phi);
Ks=fca.Context(vG,vM,I,name);
% if ~any(mmp_l_eq(Kout.Phis,phi))%If previously unexplored
%     Kout.Ks{end+1}=Ks;
%     Kout.Phis(end+1)=phi;
% end
return
