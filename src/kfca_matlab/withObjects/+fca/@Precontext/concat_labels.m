function [vG, vM]=concat_labels(K)
%function [vG, vM]=concat_labels(K)
%
%Works out a list of object and attrs names concatenating the names of clarified
%objects and attrs belonging to the same class
%
%K is the input context
%vG is the list of concatenated object labels
%vM is the list of concatenated attrs labels

if K.clarified%On clarified objects, the quotient set of atts and objects. 
%if isfield(K,'qG')%If clarified, build new representation
    %First with objects
    [g m] = size(K);
    vG=cell(1,g);
    if islogical(K.iG)
        objs=find(K.iG);
    else
        objs=K.iG;
    end
    %k=0;
    %for i=K.iG
    for i=1:g
        %k=k+1;
        iclass=find(K.qG==objs(i));%At least has element i
        if ~isempty(iclass)
            vG{i}=K.G{K.qG(iclass(1))};%select representative
            if length(iclass)>1%If more than one element, concat with commas
                %vG{i}=strcat(vG{i}, sprintf(': %s',K.G{K.qG(iclass(2:end))}));
                vG{i}=strcat(vG{i}, sprintf(': %s',K.G{iclass(2:end)}));
            end
        end
    end
% if isfield(K,'qM')
    % %Same with attrs
    vM=cell(1,m);
    if islogical(K.iM)
        atts=find(K.iM);
    else
        atts=K.iM;
    end
    %k=0;
    %for j=K.iM
    for j=1:m
        %k=k+1;
        jclass=find(K.qM==atts(j));%At least has att j
        vM{j}=K.M{K.qM(jclass(1))};%select representative
        if length(jclass)>1%If more than one element, concat with commas
            vM{j}=strcat(vM{j}, sprintf(': %s', K.M{jclass(2:end)'}));
        end
    end
else%No clarification, no problem.
    vG=K.G;
    vM=K.M;
end
return%vG, vM
