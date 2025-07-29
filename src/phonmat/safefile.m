function yes = safefile (filename,throwerror)

% SAFEFILE checks if file is safe to use
%
%  yes = safefile (filename,throwerror)
%
%     yes = 1 iff file filename exists and thus safe to use, and 0 else.
%     If file not found 
%        If throwerror is 1 (default 0) then an error is thrown 
%        If throwerror is 0, and error message is output to screen saying file not found.

if nargin < 2
  throwerror = 0;
end
yes = exist (filename) > 0;

if ~ yes
   errormsg = ['file ' filename ' not found'] ;

   if (2 == nargin)  &  ( 1 == throwerror )
     error ( errormsg );
   else
     disp ( ['ERROR ----> ' errormsg] );
   end;
end;

