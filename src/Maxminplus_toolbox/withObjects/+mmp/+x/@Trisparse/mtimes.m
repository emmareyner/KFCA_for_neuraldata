function [Z]=mtimes(X,Y)
%  lower matrix multiply for maxplus encoded matrices:
%  "multiplies" with lower addition and accumulates with max.
%
% (C) CPM, FVA

%CPM: substitued  for k=1:size(m) by  for k=1:length(m)
%FVA: revamped algorithm: be as lazy as possible.
%FVA: 10/02/9. Again written for MATLAB 7.6
%FVA: 27/26/09. package and oo version

%% conformance analysis
sizX=size(X);
sizY=size(Y);
if (sizX(2) ~= sizY(1))
    error('mmp:x:sparse:mtimes','wrong dimensions!')
end

%% 1) Both sparse: massage arguments before actual multiplication
%this procedure is strange. Maybe it would be better to try to handle
%mixed-encoding cases explicitly-> TODO
if ~isa(Y,'mmp.x.sparse'), Y=mmp.x.sparse(Y);end
%Invariant: isa(X, 'mmp.x.sparse') && isa(Y, 'mmp.x.sparse')

%% 2 Do the actual multiplication of maxplus * maxplus encoded
mX=sizX(1);
nY=sizY(2);
Z=mmp.l.zeros(mX,nY);%in maxplus encoding?
%transpose: not so negligible?
X=X.';%transpose NOT conjugate
% %Both sparse and maxplus: be as lazy as possible
% if isa(X,'mmp.x.sparse') && isa(Y, 'mmp.x.sparse')
for i=1:mX%go over X's rows
    rowX = X.Reg(:,i);%Extract as much work out of the loop as possible
    Xfinp= logical(rowX)|X.Unitp(:,i);
    Xtopp= X.Topp(:,i);
    if any(Xfinp)||any(Xtopp)%don't do anything on empty row i
        for j=1:nY%go over columns for row i.
            colY=Y.Reg(:,j);%Just one extraction
            Yfinp=logical(colY)|Y.Unitp(:,j);
            Ytopp=Y.Topp(:,j);
            if any(Yfinp)||any(Ytopp)%Don't do anything on empty col j
                if any(Xtopp&Ytopp)||any(Xtopp&Yfinp)||any(Xfinp&Ytopp)%tops
                    %if any(Xtopp&Yfinp)||any(Xfinp&Ytopp)%detect tops
                    Z.Topp(i,j)=true;
                else%Just ignore zero X or Y coordinates
                    finpij = Xfinp & Yfinp;
                    if any(finpij)
                        resij=max(rowX(finpij)+colY(finpij));
                        if abs(resij)<=eps%Detect generated units
                            Z.Unitp(i,j)=true;
                        else
                            Z.Reg(i,j)=resij;
                        end
                    end
                end
            end
        end
    end
end
% else%Both sparse and minplus: be as lazy as possible
% end

return%Z
% end of file 
