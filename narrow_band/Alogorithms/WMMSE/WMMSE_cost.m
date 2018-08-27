function cost = WMMSE_cost(x,H1,Vn,O)

global Nrf  Ns;
Nr = size(H1,1);

x = reshape(x,Nr,Nrf);

cost = trace((H1'*x*(x'*x)^(-1)*x'*H1/Vn+O^(-1))^(-1));

end