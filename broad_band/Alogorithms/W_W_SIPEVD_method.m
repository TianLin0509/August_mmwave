function [W_RF,W_B] = W_W_SIPEVD_method(H, Vn, O)

global Nrf;
[Nt, Ns, Nk] = size(H);
X = zeros(Nt,Nt,Nk);
W_B = zeros(Nrf,Ns,Nk);

for k = 1:Nk
     X(:,:,k) = (1/Vn(k)/Nt * H(:,:,k)*H(:,:,k)' + eye(Nt))^(-1);
end

X = sum(X,3);
[V,D] = eig(X);
% get the Nrf largest eigenvector
[~,IX] = sort(diag(D),'descend');
V = V(:,IX);
W_RFO =  exp(1i*angle(V(:,1:Nrf)));
W_RF = W_RFO*O^(-0.5);

for k = 1:Nk
    W_B(:,:,k) = inv(W_RF'*H(:,:,k) * H(:,:,k)'* W_RF+  Vn(k) *(W_RF)'*W_RF)*W_RF'*H(:,:,k);
end
