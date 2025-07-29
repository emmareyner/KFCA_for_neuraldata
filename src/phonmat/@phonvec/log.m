function logpv = log (pv)

logpv = pv;
v = pv.vec;
FF = find (v>0);
ph = pv.labels.phones;

set (logpv, 'vec', log (v (FF)));
set (logpv, 'labels', labels ( ph (FF)));
