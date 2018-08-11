function egrad = MMSE_egrad(x,H1,Vn)

global Nr Nrf Ns;
W = reshape(x,Nr,Nrf);
WW = (W'*W)^(-1);
A = (1/Vn*H1'*W*WW*W'*H1+eye(Ns))^(-2);
B = H1'*W*WW;
C = B';
M = 1/Vn*W*C*A*B;
N = 1/Vn*H1*A*B;
egrad = M-N;
egrad = egrad(:);



        