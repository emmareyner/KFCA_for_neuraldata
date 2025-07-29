function c = numbers2strings(nums)
% writes a cell of numbers into a cell of strings 
% encoding numbers in base 26, using the alphabet letters 

%nums=encodebase26(nums)+double('a');
c = arrayfun(@encodebase26,nums,...
    'UniformOutput',false);
return
end
function str = encodebase26(n)
    digits = ceil(log(n+eps)/log(26));
    quo = ones(1,digits);
    %dividend(:)=n;
    %divisor=26.^((digits-1):-1:0);
    %quo = mod(dividend,divisor)
    for i=digits:-1:1
        quo(i)=(floor(n/26^(i-1)));
        n=mod(n,26);
    end
    str=char(quo+double('a')-1);
end

