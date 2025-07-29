function c = findcommon (a,b)

% FINDCOMMON finds common part of two strings or 1dim arrays
%	 c = findcommon (a,b)
%	
%

if class(a) ~= class (b)
  error ('inputs should be of same type');
end;


   c = empty (a);
   for i = 1 : length(a)
     if findinvec (b, elem(a,i))
       c = append (c, elem(a,i));
       b = remove (b, elem(a,i));
     end;
   end;

