function [nVI,nDHpxpy,n2MI]=entropic(Am)
%function [VI,DHpxpy,MI]=entropic(Am)
%
% Prints a non-split entropy triangle.

N=sum(sum(Am));
A=Am./N;
[n,p]=size(A);

Px=sum(A,2);
Py=sum(A);
Qxy=Px*Py;

Px_y=A./repmat(Py,n,1);
Py_x=A./repmat(Px,1,p);

MI=0;
Hx_y=0;
Hy_x=0;
Hpxpy=0;
Hxy=0;
for x=1:n
    for y=1:p
        if (A(x,y)>0)            
            MI=MI+A(x,y)*log2(A(x,y)/(Px(x)*Py(y)));
            Hxy=Hxy-A(x,y).*log2(A(x,y));
            Hx_y=Hx_y+A(x,y)*log2(Py(y)/A(x,y));
            Hy_x=Hy_x+A(x,y)*log2(Px(x)/A(x,y));
        end
        if (Qxy(x,y)>0)
            Hpxpy=Hpxpy-Qxy(x,y).*log2(Qxy(x,y));
        end
        
    end
end
Hu_xy=log2(n)+log2(p);
DHpxpy=Hu_xy-Hpxpy;

VI=Hx_y+Hy_x;
VI=Hxy-MI;

%Hu_xy=DHpxpy+2*MI+VI

nDHpxpy=DHpxpy/Hu_xy;
n2MI=2*MI/Hu_xy;
nVI=VI/Hu_xy;


%terplot;
%terlabel('$$VI_P_{XY}$$','$$\Delta H_P_{XY}$$','$$2\cdotMI_P_{XY}$$')
%ternaryc(nVI,nDHpxpy,n2MI);
return

