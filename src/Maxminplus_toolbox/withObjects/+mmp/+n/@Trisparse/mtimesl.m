function [Z]=mtimesl(X,Y)
%  lower Matrix multiply for minplus encoded matrices:
%  "multiplies" with lower addition and accumulates with max.
%
% (C) CPM, FVA

%CPM: substitued  for k=1:size(m) by  for k=1:length(m)
%FVA: revamped algorithm: be as lazy as possible.
%FVA: 10/02/9. Again written for MATLAB 7.6

%% conformance analysis
[mX nX]=size(X);
[mY nY]=size(Y);
% sizX=size(X);
% sizY=size(Y);
%if (sizX(2) ~= sizY(1))
if (nX ~= mY)
    error('mmp:n:sparse:mtimesl','wrong dimensions!')
end

%% 1) Both sparse: massage arguments before actual multiplication
%this procedure is strange. Maybe it would be better to try to handle
%mixed-encoding cases explicitly-> TODO
if ~isa(Y,'mmp.n.sparse'),Y=mmp.n.sparse(Y); end
%Invariant: isa(X, 'mmp.n.sparse') && isa(Y, 'mmp.n.sparse')

%% 2 Do the actual multiplication
%mX=sizX(1);
%nY=sizY(2);
Z=mmp.u.zeros(mX,nY);%result in MINPLUS encoding
%transpose: not so negligible?
X=X.';%transpose NOT conjugate
for i=1:mX%go over X's rows
    Xtopp = X.Topp(:,i);%This detects -Inf
    if all(Xtopp)%a null row annihilates all colums
        Z.Topp(i,1:nY)=true;
        continue
    end
    rowX = X.Reg(:,i);%Extract as much work out of the loop as possible
    Xfinp= logical(rowX)|X.Unitp(:,i);
    for j=1:nY%go over columns for row i.
        if Z.Topp(i,j), continue; end%Early detection of tops (see below)
        Ytopp=Y.Topp(:,j);
        if all(Ytopp),%a null column annihilates all rows
            Z.Topp(1:mX,j)=true;
        else%on non null columns, find non top elements and operate
            colY=Y.Reg(:,j);%Just one extraction
            Yfinp=logical(colY)|Y.Unitp(:,j);
            finpij = Xfinp & Yfinp;%detect places with finite res
            %only work were necessary: although Xtops and Ytops won't be
            %resij, they squeeze out -Infs.
            if any(finpij) && all(finpij|Xtopp|Ytopp)
                resij=max(rowX(finpij)+colY(finpij));
                if resij == Inf%
                    Z.Reg(i,j)=0.0;%Generate a null
                elseif abs(resij)<= eps%Detect generated units
                    Z.Unitp(i,j)=true;
                else
                    Z.Reg(i,j)=resij;
                end
            end%Else bottoms already taken care of.
        end
    end%for j
end%for i
return%Z
% end of file 
