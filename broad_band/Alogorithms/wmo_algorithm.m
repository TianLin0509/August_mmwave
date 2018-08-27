function [V_RF, V_U] = wmo_algorithm(V_RF, Vn, H1, O)

global manifold Ns Nk;
[Nt, Nrf] = size(V_RF);
V_U = zeros(Nrf,Ns,Nk);
problem.M = manifold;

problem.cost = @(x)wMMSE_cost(x,H1,Vn,O);
problem.egrad = @(x)wMMSE_egrad(x,H1,Vn,O);

[x] = conjugategradient(problem,V_RF(:));

V_RF = reshape(x,Nt,Nrf);

for k = 1:Nk
    V_U(:,:,k) = inv(V_RF'*H1(:,:,k)*O(:,:,k) * H1(:,:,k)'* V_RF+  Vn(k) *(V_RF)'*V_RF)...
        *V_RF'*H1(:,:,k)*O(:,:,k);
end