function H_fixed = gen_H(Nt,Nr,N)

for i = 1: N
    H_fixed(:,:,i) = OMPH(Nt,Nr);
end
