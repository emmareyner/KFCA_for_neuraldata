function [yes] = whichobj (object1, object2)

% object1 is the object you seek, which is a list of lists of objects
% of type <t> e.g. {{'aa'},{'r'}}
% object2 is an object of type <t>
% yes is the index of the element of object1 in whose elements 
% object2 appears. is 0 if not in any.
% For example, if object1 = {{'tcl','t'},{'tcl'},{'t'}} and object2='tcl'
%  then yes = [1 2]. If object2='d' then yes = 0 (or [0])

if iscell(object2), object2=object2{1};end; % input shouldnt be a cell anyway.
yes = [];
for i = 1:length(object1)
    for j = 1:length(object1{i})
     strcmp (object1{i}{j}, object2)
       yes = append (yes,i);
       break;
     end;
    end;
end;

if ~length(yes), yes=0; end;