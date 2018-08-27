function [W_RF, W_B] = Wgevd_W_algorithm(W_RF, v, H1, O)

global Ns  Nrf Vn;
Nr = size(W_RF,1);
theta = 1/(Vn * v * Nr);  % for simplification

for m = 1: 2  %outer iteration
    for j = 1: Nrf
        V_m = W_RF;
        V_m(:,j) = [];
        Am = eye(Ns) + theta * H1' * V_m * V_m' * H1;
        Um = theta * H1 * Am^(-1)*O*Am^(-1) * H1';
        Wm = 1/Nr * eye(Nr) + theta * H1 * Am^(-1) * H1';
        [V,D] = eig(Um, Wm);
        % get the largest eigenvector
        [~,max_index] = max(diag(D));
        W_RF(:,j) = exp(1i * angle(V(:,max_index)));
    end
end

W_B = inv(W_RF'*H1 * H1'* W_RF+  Vn *  v *(W_RF)'*W_RF)*W_RF'*H1 ;
