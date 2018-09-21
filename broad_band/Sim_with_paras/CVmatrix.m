[m,n] = size(SIPEVD.modmse);
for i = 1:m
    for j = 1:n
        if(SIPEVD.modmse(i,j) ==0)
            SIPEVD.modmse(i,j) = SIPEVD.modmse(i-1,j);
        end
    end
end