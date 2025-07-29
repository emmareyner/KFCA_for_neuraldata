function thisK=loadConceptFromCSV(Kout,phi,path)


[fo,phiLoc]=min(abs(phi-Kout.Phis));
[g,m]=size(Kout.R);
if (nargin<4)
    force=false;
end

if (isempty(Kout.Ks))
    fileName=sprintf('%s/%s/%s_structural_%1.20f.csv',path,Kout.Name,Kout.Name,Kout.Phis(phiLoc));
    fid=fopen(fileName);
    if (fid~=-1)
        fclose(fid);
        I=dlmread(fileName, ';', 1, 1);
        I=logical(I(1:g,1:m));
        thisK=fca.Context(Kout.G,Kout.M,I,sprintf('%s_structural_%1.20f',Kout.Name,Kout.Phis(phiLoc)));   
    else
       disp(['File not found: ' fileName]);
       thisK=[]; 
    end
else        
    thisK=Kout.Ks{phiLoc};       
end

