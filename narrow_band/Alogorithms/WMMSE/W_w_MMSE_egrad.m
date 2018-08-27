function egrad = W_w_MMSE_egrad(x,H1,Vn,O)

global  Nrf Ns;
Nr = size(H1,1);
W = reshape(x,Nr,Nrf);
WW = (W'*W)^(-1);
A = (1/Vn*H1'*W*WW*W'*H1+eye(Ns))^(-1)*O*(1/Vn*H1'*W*WW*W'*H1+eye(Ns))^(-1);
B = H1'*W*WW;
C = B';
M = 1/Vn*W*C*A*B;
N = 1/Vn*H1*A*B;
egrad = M-N;
egrad = egrad(:);



        