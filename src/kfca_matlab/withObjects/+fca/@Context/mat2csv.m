function mat2csv(K, outputdir)
% mat2csv(K, outputdir)
% Outputs to file system a Comma Separated Values (CSV) file ready to use
% with conexp.
% Input:
% - K is a boolean context 
% - outputdir is the name of the output directory where the CSV file will
% be written. The full name of the file is:
% outputname = fullfile(outputdire,[K.name,'.csv'])
% 
% Output:
% - nconcp: number of concepts of concept lattice.
%
% WARNING! The use of mat2csv to calculate the number of concepts is
% discouraged, since it also calculates the whole lattice before doing so.
% It is thus very costly.
% WARNING, since mat2csv does NOT return a context, all clarification/ 
% reduction operations are not stored! -> MEND!


%Check number of input args
%error(nargchk(2, 2, nargin))

% %FVA: I don't understand what's being done here!
% if isfield(K,'iG_conf')
%     Koux=create_context(K.G(K.iG_conf),K.M(K.iM_conf),K.I(K.iG_conf,K.iM_conf),K.Name);
%     if isfield(K,'qG')%%i.e. does it have a quotient on Gs.
%         K=clarify(Koux);
%     else
%         K=Koux;
%     end
% end
%clarify context before writing!

%Concat labels for clarified objects and attrs
[vG, vM]=concat_labels(K);

%write the csv file
%outputfile=fullfile(outputdir, [K.Name,'.csv']);
outputfile=[outputdir,'/', [K.Name,'.csv']];
disp(['Writing: ', outputfile])
fid = fopen(outputfile,'w');

%first write the attributes list
fprintf(fid,';');
% if islogical(K.iM)
%     atts=find(K.iM);
% else
%     atts=K.iM;
% end
%fprintf(fid,'%s;',vM);
m=length(vM);
for i=1:m
	fprintf(fid,'%s;',vM{i});%This also works on lists!
end
fprintf(fid,'\n');

%then write each object followed by each row of the matrix
I=full(K.I(K.iG,K.iM));
g=length(vG);
if (g>0)
 	fprintf(fid,'%s;',vG{1});
    fprintf(fid,'%d;',(I(1,:)));
end
for i=2:g
 	fprintf(fid,'\n%s;',vG{i});
     fprintf(fid,'%d;',(I(i,:)));
 % 	for j=1:m
 %             fprintf(fid, '%d;', K.I(i,j));%Also works on lists!
 % 	end
% 	fprintf(fid,'\n');
end
fprintf(fid,'\n');
fclose(fid);

% %Maybe the concept intents should be stored in K, so as not to repeat any
% %work in later processing.
% if nargout~=0
%     if ~isfield(K, 'qG'), K=clarify(K);end
%     B=concepts(K);
%     nconcp=size(B,1);
%     Kout=K;
% end
return
