function [W_RF,W_B] = W_W_EVD_method(H, Vn, O)

global Nrf;
[Nt, Ns, Nk] = size(H);
X = zeros(Nt,Nt,Nk);
W_B = zeros(Nrf,Ns,Nk);

for k = 1:Nk
    X(:,:,k) = 1/Vn(k)/Nt * H(:,:,k)* O(:,:,k) *H(:,:,k)';
end

X = sum(X,3);
[V,D] = eig(X);
% get the Nrf largest eigenvector
[~,IX] = sort(diag(D),'descend');
V = V(:,IX);
W_RF =  exp(1i*angle(V(:,1:Nrf)));

for k = 1:Nk
    W_B(:,:,k) = inv(W_RF'*H(:,:,k) * H(:,:,k)'* W_RF+  Vn(k) *(W_RF)'*W_RF)*W_RF'*H(:,:,k);
end
