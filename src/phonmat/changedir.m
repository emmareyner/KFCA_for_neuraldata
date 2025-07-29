function [changed,present] = changedir (filename, dirname)

% dinoj@cs.uchicago.edu 11/22/02
%
% I'm using the same files when they are on different machines and
% therefore have different paths.
% This changes filename so that it refers to the same file but is
% the directory referred to by dirname instead.
% eg. if filename = '/home/dinoj/CDROM/timit/train/dr1/fcfj0/sa2'
%     and dirname = '/var/tmp/timit/' then
%     changed = '/var/tmp/timit/dr1/fcfj0'
%  Actually, in the above case we can't always be sure if there is
%  a /test/ or /train/ to be inserted somewhere.
% dirname must be up to and not including the directory dr?.
% present = 1 if file found.
% 

z = stripfname (filename,3,'/');
algs = {'train/','test/',''};
present = 0;
for i = 1 : length (algs)
   changed = dircat (dirname,algs{i});
   changed = dircat (changed,z);
   if exist(addwav(changed)), present=1; break;end;
end;
     