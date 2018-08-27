function [V_RF, V_U] = Wmo_algorithm(V_RF, Vn, H1,O)

global manifold;
[Nt, Nrf] = size(V_RF);
problem.M = manifold;

problem.cost = @(x)WMMSE_cost(x,H1,Vn,O);
problem.egrad = @(x)WMMSE_egrad(x,H1,Vn,O);

[x,cost] = conjugategradient(problem,V_RF(:));

V_RF = reshape(x,Nt,Nrf);
V_U = inv(V_RF'*H1 * O * H1'* V_RF+ 1 * Vn *(V_RF)'*V_RF)*V_RF'*H1*O;