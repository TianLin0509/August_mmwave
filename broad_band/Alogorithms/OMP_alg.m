function [V_RF,V_D] = OMP_alg (H,AT,Vn)
global Nrf;
V_RF =[];
[Nt, Ns,N_k] = size(H);
for i = 1:N_k
    VRES(:,:,i)  = eye(Ns);
end
for l = 1 : Nrf
    Vi = [];
    vi = [];
    for m = 1:N_k
        vi(:,:,m) = AT'*H(:,:,m)*VRES(:,:,m);
        Vi(:,:,m) = vi(:,:,m)*vi(:,:,m)';
    end
    Vi = sum(Vi,3);
    Vi = diag(Vi);
    [a,k] = max(Vi);
    V_RF =[V_RF AT(:,k)];
    AT(:,k) = [];
    V_D = [];
    for i = 1:N_k
        M = V_RF'*(H(:,:,i))*H(:,:,i)'*V_RF+ Vn(i)*(V_RF)'*V_RF;
        V_D(:,:,i) = inv(M)*V_RF'*H(:,:,i);
        RES = eye(Ns)-H(:,:,i)'*V_RF*V_D(:,:,i);
        VRES(:,:,i) = RES/norm(RES,'fro');
    end
end



