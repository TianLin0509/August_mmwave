function [obj] = Mrate_method(obj)
% traditional SVD algorithm for rate maximization

global  H Ns V_ropt W_ropt;

[U,~,V] = svd(H);
V_ropt = V(:,1:Ns);
%power constraint
V_ropt = V_ropt / norm(V_ropt,'fro');
W_ropt = U(:,1:Ns);

obj.V_B = V_ropt;
obj.W_B = W_ropt;
obj = get_metric(obj);