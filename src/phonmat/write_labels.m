function labelset=write_labels(list,nlabels)

fid=fopen(list,'r');
labelset=cell(1,nlabels);
pat= '[^\s]*';
for i=1:nlabels
    line=fgets(fid);
    m = regexp(line, pat, 'match');
    labelset{i}=m{1};
end



