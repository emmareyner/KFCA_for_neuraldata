function blah = labels (varargin)

%LABELS  user-defined class to deal with labels for phone manipulation, 
%        especially in the context of classes PHONMAT and CONFMAT.
%
%	Their use is best explained by example. Supposed you have an
%	experiment with the English phones /t/, /d/, /th/ and /dh/.
%	For convenience, define 1-character labels (called ONELABELS)
%	for each, say t,d,T and D. This is the approach followed by
%	the DISC format in CELEX for example. You would still like to
%	remember that T stands for /th/ of course.
%
%	blah = labels ('tdTD','T th D dh');
%	blah{'th'}  --> 'T'  
%	blah('th')  --> 3    (position in original string definition)
%	blah{'D'}   --> 'D'
%	blah('D')   --> 4
%	blah{'dh'}  --> 'D'
%	blah{'zh'}  --> ''
%	blah('zh')  --> 0
%	blah.phones --> 'tdTD'
%	blah.allphones  --> 't d T (th) D (dh)'
%
%	The second argument in the initialization is optional. If you have
%	no labels other than your onelabels, "blah = labels('tdTD')" is ok.
%
%	At the moment there is no functionality to modify or delete labels as 
%	I have not needed it. Feel free to add and even freer to email
%	me and tell me about your improved version.
%
%	It is your responsibility to make sure that labels don't contradict
%	each other. Saying addlabels (blah, 'T th D th') is definitely a 
%	"Bad command! Go sit in the corner" kind of thing.
%
%	[author: Dinoj Surendran, dinoj@cs.uchicago.edu 01/2003]

%  Note: the only field actually stored here is called data, and is a 
%	 cell array. Say there are n onelabels. Then data{i} (i=1:n) is
%	 an array of strings with all possible representations of this
%	 phone. data{i}{1} is its onelabel. (Labels that are not onelabels
%        are called altlabels.)

switch nargin
 case 0
   blah.data = {};         
   blah = class (blah, 'labels');
 case 1
   if ischar (varargin{1})            % no altlabels
      blah = labels (varargin{1},'');
   elseif isa (varargin{1},'labels')
      blah.data = get (varargin{1}, 'data');
      blah = class (blah, 'labels');
   elseif isa (varargin{1},'struct')
      fie = fieldnames (varargin{1});
      if length (fie) >= 1 & cmp(fie{1},'data')
         blah.data = varargin{1}.data;
	 blah = class (blah, 'labels');
      else
         error ('in "blah = labels (onelabels)" where onelabels is a struct, it should be one created from a labels object.');
      end
   else
      error ('in "blah = labels (onelabels)", onelabels should be a string/labels-struct/labels object');
   end;
 case 2
   if ischar (varargin{1}) & ischar (varargin{2})
      blah.data = private_makelabels ( varargin{1} );
      blah.data = private_addlabels  (blah.data, varargin{2} );
      blah = class (blah, 'labels');
   else 
      error ('in "blah = labels (onelabels, altlabels)", both inputs should both be strings');
   end;
 otherwise
   error ('Wrong number of arguments; usage is "blah = labels (onelabels, altlabels)" or "blah = labels (onelabels)"');
end



