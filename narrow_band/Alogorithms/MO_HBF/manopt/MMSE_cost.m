function cost = MMSE_cost(x,H1,Vn)

global Nrf  Ns;
Nr = size(H1,1);

x = reshape(x,Nr,Nrf);

cost = trace((H1'*x*(x'*x)^(-1)*x'*H1/Vn+eye(Ns))^(-1));

end