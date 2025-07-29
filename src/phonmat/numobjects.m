function [counts] = numobjects (files, objects)
  
% objects is a Kx1 cell array with the list of acoustic objects
% that we want counts of. 
% files is a cell array of files where we shall make our counts
% counts is a Kx1 vector s.t. count(i) has the number of times
% objects{i} occurs in files.
  
  K = length(objects);
  objectlength = length(objects{1});
      
  counts = zeros (K,1);
  for i = 1:length(files)
    file = strcat( files{i}, '.phn');
    [herestarts, hereends, herephoneme] = textread (char(file), '%d %d %s', 'headerlines',0);
    for j = 1:length (herephoneme) - objectlength + 1
      for p = 1:objectlength
	  objectsaid{p} = herephoneme {j+p-1};
      end;
      for k = 1 : K
	objectsought = objects{k};            % this is an array like {{'aa'},{'r'}}
	if objectcmp (objectsought, objectsaid)  
	  counts(k) = counts(k) + 1;
	  break;
	end;
      end;
    end;
  end;
  
     
    