function [nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hu_x,Hu_y]=coordinates(Am)
%function [nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hu_x,Hu_y]=coordinates(C)
%
% Returns values for the entropies related to n x p matrix
% [C] NORMALISED by the maximum entropies of the marginals [Hu_x + Hu_y]
% - for nVI, nDHpxpy and n2MI, the normalizing constant is log(n)+log(p). 
% - for nVIx, nDHpx, the normalizing constant is log(n)
% - for nVIy, nDHpy, the normalizing constant is log(p)
%
% And plots all those values in a split entropy ternary plot!!
%
% Authors: JMGC, FVA

% FVA: documented briefly. Changed labels in triangle.
% FVA 25/10/2012. Moved entropic_triangle into coordinates, using
% double/entropies.
error(nargchk(1,1,nargin));

%if (iscell(Am))
    [M P K] = size(Am);%Dimensions of experiment
    N=sum(sum(Am));
    if (K==1)%single matrix
        A=Am./N;%Normalize into a joint distribution
    else
        A = zeros([M P K]);
        for k = 1:K
            A(:,:,k) =Am(:,:,k)./N(:,:,k);
        end
    end

    [H_Pxy, Hp_x,Hp_y, MI]=entropies(A);

    Hu_x = log2(M);
    Hu_y = log2(P);
    Hu_xy=Hu_x + Hu_y;
    DHpx = Hu_x - Hp_x;
    DHpy = Hu_y - Hp_y;
    DHpxpy = DHpx + DHpy;
    VIx = H_Pxy - Hp_y;%=Hp_u - MI;
    VIy = H_Pxy - Hp_x;%=Hp_y - MI;
    VI = VIy + VIx;

    %All quantities are normalized
    nDHpxpy=DHpxpy/Hu_xy;
    nDHpx=DHpx/Hu_x;
    nDHpy=DHpy/Hu_y;
    n2MI=2*MI/Hu_xy;
    nVI=VI/Hu_xy;
    nVIx=VIx/Hu_x;
    nVIy=VIy/Hu_y;
return
