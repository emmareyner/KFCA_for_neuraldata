function [Z]=mtimesu(X,Y)
% upper Matrix multiply for maxplus encoding: "multiplies" with upper
% addition and accumulates with min.
%
% (C) CPM, FVA

%CPM: substitued  for k=1:size(m) by  for k=1:length(m)
%FVA: revamped algorithm: be as lazy as possible.
%FVA: 10/02/9. Again written for MATLAB 7.6
%FVA: 25/03/09: OO version

%% conformance analysis
% if ~isa(X,'mmp.sparse') || ~isa(Y,'mmp.sparse')
%     error('mmp.x.mtimes: wrong argument type!')
% end
sizX=size(X);
sizY=size(Y);
if (sizX(2) ~= sizY(1))
    error('mmp:x:sparse:mtimesu','wrong dimensions!')
end

%% 2 Do the actual multiplication
mX=sizX(1);
nY=sizY(2);
Z=mmp.l.zeros(mX,nY);%in maxplus encoding?
%transpose: not so negligible?
X=X.';%transpose NOT conjugate
% %Both sparse and maxplus: be as lazy as possible
% if isa(X,'mmp.x.sparse') && isa(Y, 'mmp.x.sparse')
    for i=1:mX%go over X's rows
        Xtopp = X.Topp(:,i);
        if all(Xtopp)%a null row annihilates all colums
            Z.Topp(i,1:nY)=true;
            continue
        end
        rowX = X.Reg(:,i);%Extract as much work out of the loop as possible
        Xfinp= logical(rowX)|X.Unitp(:,i);
        %Xnbotp=Xfinp|Xtopp;
        %Xbotp= ~(Xfinp|Xtopp);%these saturate xp sums
        for j=1:nY%go over columns for row i.
            if Z.Topp(i,j), continue; end%Early detection of maxtops
            Ytopp=Y.Topp(:,j);
            if all(Ytopp),%a null column annihilates all rows
                Z.Topp(1:mX,j)=true;
            else%on non null columns, find non top elements and operate
                colY=Y.Reg(:,j);%Just one extraction
                Yfinp=logical(colY)|Y.Unitp(:,j);
                finpij = Xfinp & Yfinp;%detect places with finite res
                %only work were necessary: although Xtops and Ytops won't be
                %resij, they squeeze out Infs.
                if any(finpij) && all(finpij|Xtopp|Ytopp)
                    resij=min(rowX(finpij)+colY(finpij));
                    %if resij==0.0%Detect generated units
                    if abs(resij) <= eps%detect generated units
                        Z.Unitp(i,j)=true;
                    else
                        Z.Reg(i,j)=resij;
                    end
                end%Else just don't insert bottoms
                continue
            end
        end%for j
    end%for i

return%Z
% end of file 