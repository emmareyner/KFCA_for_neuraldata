function [Z]=mtimes(X,Y)
% upper Matrix multiply for minplus encoding: "multiplies" with upper
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
[mX nX]=size(X);
%sizX=size(X);
[mY nY]=size(Y);
%sizY=size(Y);
if (nX ~= mY)
    error('mmp:n:sparse:mtimesu','wrong dimensions!')
end

%% 1) Both sparse: massage arguments before actual multiplication
%this procedure is strange. Maybe it would be better to try to handle
%mixed-encoding cases explicitly-> TODO
if isa(Y,'mmp.sparse')
    if isa(Y, 'mmp.x.sparse'), Y=mmp.n.sparse(Y); end
else%don't allow mixed full/sparse multiplications!
    error('mmp:n:sparse:mtimesu','wrong input parameter. Use mmp.l.mtimes');
end
%Invariant: isa(X, 'mmp.x.sparse') && isa(Y, 'mmp.x.sparse')


%% 2 Do the actual multiplication
%mX=sizX(1);
%nY=sizY(2);
Z=mmp.u.zeros(mX,nY);
%transpose: not so negligible?
X=X.';%transpose NOT conjugate
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
                        resij=min(rowX(finpij)+colY(finpij));
                        %if resij==0.0%Detect generated units
                        if abs(resij) <= eps%detect generated units
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

return%Z
% end of file 
