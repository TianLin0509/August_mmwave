function [W_RF, W_B] = w_w_mo_algorithm(W_RF, Vn, H1, O)

global manifold;
[Nr, Nrf] = size(W_RF);
problem.M = manifold;

problem.cost = @(x)W_w_MMSE_cost(x,H1,Vn, O);
problem.egrad = @(x)W_w_MMSE_egrad(x,H1,Vn, O);

[x,cost] = conjugategradient(problem,W_RF(:));

W_RF = reshape(x,Nr,Nrf);
W_B = inv(W_RF'*H1 * H1'* W_RF+  Vn *(W_RF)'*W_RF)*W_RF'*H1;