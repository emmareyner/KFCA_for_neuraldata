function a=extent(K,b)
% function a=extent(K,b)
% Works out the extent for [b], a colum set of attributes (or sets), in context K.
% cpm 2003

% TODO fva: change extent to accept matrices of columns and return matrices
% of columns.
I=K.I(K.iG,K.iM);
a=ones(1,size(I,2));
for i=1:size(I,1)
    if b(i)
        a=and(a,I(i,:));
    end
end
    
