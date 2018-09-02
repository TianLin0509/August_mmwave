function obj = WSIPEVD_wbmethod(obj)

global H V_mopt Nk Nt Nr  Ns Vn;
t1 = clock;
n = 0;
w = zeros(Nk,1);
v = zeros(Nk,1);
%init
V_equal = V_mopt;
W_equal = zeros(Nt,Ns,Nk);
H_equal = zeros(Ns,Ns,Nk);
wmse = zeros(Nk,1);
for i = 1:Nk
    v(i) = trace(V_equal(:,:,i)'*V_equal(:,:,i));
end

H1 = zeros(Nt,Ns,Nk);
H2 = zeros(Nr,Ns,Nk);
trigger = 1;
m_MSE_new = 100;
O = zeros(Ns,Ns,Nk);
for i = 1:Nk
    O(:,:,i) = eye(Ns);
end
%limit the iterations number by i<10
while ( n<10)
    %combining
    Vn1 = Vn * v;
    for i = 1: Nk
        H1(:,:,i) = H(:,:,i)*V_equal(:,:,i);
    end
    [W_RF,W_B] = W_W_SIPEVD_method(H1,Vn1,O);
    
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
    [V_RF, V_U] = WSIPEVD_method(H2,Vn2,O);
    
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

