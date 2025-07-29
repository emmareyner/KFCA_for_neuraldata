function k = elementof (list, element, eq_handle)
% returns index of element in list, 0 if not present
% list is a string array or a row/col vector
% eq_handle is a handle to a function used to see if two elements equal be. 

l = length(list);
k = 0;
tmp = 0;

if l
 for i = 1:l
  if strcmp ('cell',class(list))
    tmp = list{i};
  else
    tmp = list(i);
  end;

  if feval (eq_handle, tmp, element)
   k = i;
   break;
  end;
 end;
end;