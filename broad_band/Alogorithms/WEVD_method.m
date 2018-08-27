function [V_RF,V_U] = WEVD_method(H, Vn, O)

global Nrf;
[Nt, Ns, Nk] = size(H);
X = zeros(Nt,Nt,Nk);
V_U = zeros(Nrf,Ns,Nk);

for k = 1:Nk
    X(:,:,k) = 1/Vn(k)/Nt * H(:,:,k)*H(:,:,k)';
end

X = sum(X,3);
[V,D] = eig(X);
% get the Nrf largest eigenvector
[~,IX] = sort(diag(D),'descend');
V = V(:,IX);
V_RF =  exp(1i*angle(V(:,1:Nrf)));

for k = 1:Nk
    V_U(:,:,k) = inv(V_RF'*H(:,:,k)* O(:,:,k)* H(:,:,k)'* V_RF+  Vn(k) *(V_RF)'*V_RF)*V_RF'*H(:,:,k)*O(:,:,k);
end
