function Ks = structural(K,phi)
%function Ks = structural2(K,phi)
%
% A function to calculate the structural \phi-standard context of a maxplus
% formal context, in Ks. This has always a SPARSE incidence.
%
% Input:
% - [K], a maxminplus formal context K.
% - [phi], the pivot or minimum degree of existence requested. If this is
% not provided, phi==0 is assumed. 
%
% Output:
% - Ks, the structural context
%  - Kout, if requested, on exit, a  structural context for the given
%  phi=K.Phis{end} has been added in at K.Ks{end}, and the new element is
%  returned in Kout.
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
error(nargchk(1, 2, nargin));
if nargin == 1, phi = 0; end

%FVA: Clarification on Rmax,plus is almost always useless.
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
%% if not explored!
else
    % As suspected by CPM, FVA and proven by JMGC,
    % the structural incidence can be calculated by means of a threshold on phi
    I= K.R(K.iG,K.iM) <= phi;
    %I= K.R(K.iG,K.iM) > phi;    
% %% Find the meet-irreducibles and the join irreducibles.
% %newg = length(Kout.iG);
% %newm = length(Kout.iM);
% [newg newm]= size(K);
% %Find all join irreducibles providing unitary obj ROWS to mpfca_gamma
% %[gamma_ext,gamma_int]=gamma_concept(phi,K,spmp_eye(newg));
% %[gamma_ext,gamma_int]=gamma_concept(Kout,phi,mmp.l.eye(newg));
% [gamma_ext]=gamma_concept(K,phi,mmp.l.eye(newg));
% %Find all meet irreducibles providing unitary att COLS to mpfca_mu
% %[mu_ext,mu_int]=mu_concept(phi,K,spmp_eye(newm));
% %[mu_ext,mu_int]=mu_concept(K,phi,mmp.l.eye(newm));
% [mu_ext]=mu_concept(K,phi,mmp.l.eye(newm));
% %mu_ext=mpfca_extent(phi,K,mp_eye(newm));%Just work out the extents!
% gamma_ext
% mu_ext
% 
% %% Produce the binary incidence matrix
% I=logical(sparse(newg,newm));
% for i=1:newg
% %    gexti=gamma_ext(:,i);
%     gexti=gamma_ext(i,:);
%     for j=1:newm
%         %Compare intents or extents (both produce the same results) Both
%         %are column vectors, remember
%         %I(i,j)=(any(gexti >= mu_ext(:,j)));%this is <=^op!%FVA hasta antes
%         %de Paris
% %        I(i,j)=all(gexti <= mu_ext(:,j));
%         I(i,j)=all(gexti <= mu_ext(j,:));
%         %I(i,j)=all(gamma_int(:,i) >= mu_int(:,j));%This is for <=!
%         %I(i,j)=all(gamma_ext(:,i) <= mu_ext(:,j));%this is for <=!
%         %debug [gamma_ext(:,i) mu_ext(:,j) gamma_ext(:,i) <=mu_ext(:,j)]
%         %debug [gamma_int(:,i) mu_int(:,j) gamma_int(:,i) >=mu_int(:,j)]
%     end
% end
% full(I)
% %I=not(I);%This is for <=!
% %I=mp_ldiv(gamma_ext,mu_ext);%This is the mp operation

%% Append this structural lattice to the output context
[vG, vM]=concat_labels(K);
name = sprintf('%s_structural_%f',K.Name,phi);
Ks=fca.Context(vG,vM,I,name);
% if ~any(mmp_l_eq(Kout.Phis,phi))%If previously unexplored
%     Kout.Ks{end+1}=Ks;
%     Kout.Phis(end+1)=phi;
% end
end
return
