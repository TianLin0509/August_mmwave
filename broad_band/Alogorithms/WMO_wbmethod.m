function obj = WMO_wbmethod(obj)

global  H  Vn V_ropt Nt  Nrf Nr Nk Ns;
t1 = clock;
n = 0;

w = zeros(Nk,1);
v = zeros(Nk,1);
%init
V_equal = V_ropt;
W_equal = zeros(Nr,Ns,Nk);
H_equal = zeros(Ns,Ns,Nk);
m_mse = zeros(Nk,1);
for i = 1:Nk
    v(i) = trace(V_equal(:,:,i)'*V_equal(:,:,i));
end
%random initialization
V_RF = exp( 1i*unifrnd(0,2*pi,Nt,Nrf));
W_RF = exp( 1i*unifrnd(0,2*pi,Nr,Nrf));
%iteration trigger, the normal initialization just for pass into functions

H1 = zeros(Nr,Ns,Nk);
H2 = zeros(Nt,Ns,Nk);
trigger = 1;
m_MSE_new = 100;

O = zeros(Ns,Ns,Nk);
for i = 1:Nk
    O(:,:,i) = eye(Ns);
end
%limit the iterations number by i<10
while (  trigger > 1e-4 && n<10)
    
     Vn1 = Vn * v;
    for i = 1: Nk
        H1(:,:,i) = H(:,:,i)*V_equal(:,:,i);
    end
    [W_RF,W_B] = wwmo_algorithm(W_RF, Vn1, H1,O);
    
    %weighted matrix
    for k = 1:Nk
        W_equal(:,:,k) = W_RF * W_B(:,:,k);
        H2(:,:,k) = H(:,:,k)'*W_equal(:,:,k);
        H_equal(:,:,k) = W_equal(:,:,k)'*H1(:,:,k);
        E = (H_equal(:,:,k) * H_equal(:,:,k)' - H_equal(:,:,k) - H_equal(:,:,k)')...
            + Vn * (W_equal(:,:,k))'*W_equal(:,:,k) +eye(Ns);
        O(:,:,k) = E^(-1)/v(k);
        w(k) = trace(O(:,:,k)*W_equal(:,:,k)'*W_equal(:,:,k));
    end
    
    %precoding
    Vn2 = Vn * w;
    [V_RF, V_U] = wmo_algorithm(V_RF,Vn2, H2, O);
    
    m_MSE_old = m_MSE_new;
    
    for k = 1:Nk
        V_equal(:,:,k) = V_RF * V_U(:,:,k);
        v(k) = trace(V_equal(:,:,k)*V_equal(:,:,k)');
        H_equal(:,:,k) = H2(:,:,k)'*V_equal(:,:,k);
         wmse(k) = trace(O(:,:,k)*(H_equal(:,:,k) * H_equal(:,:,k)' - H_equal(:,:,k)...
             - H_equal(:,:,k)'+ Vn * W_equal(:,:,k)'*W_equal(:,:,k) +eye(Ns)))...
        - log2(det(O(:,:,k)));
    end
    m_MSE_new = sum(wmse)/Nk;
    trigger = m_MSE_old - m_MSE_new;
    n = n + 1;
end

for i = 1:Nk
    V_B(:,:,i)= V_U(:,:,i) /sqrt(v(i));
end

t2 = clock;
runtime  = etime(t2,t1);
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj.runtime = obj.runtime + runtime;
obj = get_wbmetric(obj);
