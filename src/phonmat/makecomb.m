function combinations = makecomb (v)

% v is a set of distinct numbers
% combinations{i} is a vector, a subset of v, i = 1:2^(length v) - 1

N = length(v);

for k = 0 : (2^N-1)
    % Enumerate the binary  numbers from 0 to 2^length(v)-1
    % use these to choose subsets of v
    
    b = dec2bin (k);

    % b is an array representing a binary number -- add some zeros to it so it has N elements

    bb = length(b);
    for i = 1 : bb
        a = N-bb+i;
	combin (a) = b (i);
    end;
    for i = (bb+1) : N
	combin (i-bb) = 0;
    end;

    % not sure what the type of combin is -- weird floor+49 thing works.
    combinations{k+1} = v (logical (floor(combin*1/49)));
end;



    
