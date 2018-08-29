function obj = JZMO_wbmethod(obj)

global V_ropt W_ropt Nk Nrf Ns;
t1 = clock;
[V_RF, V_U] =  MO_AltMinWB(V_ropt);
[W_RF, W_B] =  MO_AltMinWB(W_ropt);
v = zeros(Nk,1);
V_B = zeros(Nrf,Ns,Nk);
for i = 1:Nk
    v(i) = trace(V_U(:,:,i)'*V_RF'*V_RF*V_U(:,:,i));
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


