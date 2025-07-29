%test xp_ np_patterns
A=[0 -Inf -Inf; Inf 2 -Inf; Inf Inf 0]
Axpsp=xp_sparse(A);
Anpsp=np_sparse(A);

%% Check patterns in maxplus convention
[nzA,uA,tA]=xp_patterns(A);
[nzAxp,uAxp,tAxp]=xp_patterns(Axpsp);
if any(any(nzA~=nzAxp)), warning('A non-zero maxplus patterns strange'); end
if any(any(uA~=uAxp)), warning('A unit maxplus  patterns strange'); end
if any(any(tA~=tAxp)), warning('A top maxplus  patterns strange'); end

[nzAnp,uAnp,tAnp]=xp_patterns(Anpsp);
if any(any(nzA~=nzAnp)), warning('A non-zero maxplus  patterns strange'); end
if any(any(uA~=uAnp)), warning('A unit maxplus  patterns strange'); end
if any(any(tA~=tAnp)), warning('A top maxplus  patterns strange'); end

%Check patterns in minplus convention
[nzA,uA,tA]=np_patterns(A);
[nzAxp,uAxp,tAxp]=np_patterns(Axpsp);
if any(any(nzA~=nzAxp)), warning('A non-zero maxplus patterns strange'); end
if any(any(uA~=uAxp)), warning('A unit maxplus  patterns strange'); end
if any(any(tA~=tAxp)), warning('A top maxplus  patterns strange'); end

[nzAnp,uAnp,tAnp]=np_patterns(Anpsp);
if any(any(nzA~=nzAnp)), warning('A non-zero maxplus  patterns strange'); end
if any(any(uA~=uAnp)), warning('A unit maxplus  patterns strange'); end
if any(any(tA~=tAnp)), warning('A top maxplus  patterns strange'); end
