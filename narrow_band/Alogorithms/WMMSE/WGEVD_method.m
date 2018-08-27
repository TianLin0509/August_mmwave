function [obj] = WGEVD_method(obj)

%the proposed GEVD-HBF scheme

global H Vn  Nrf Nt Nr V_ropt Ns;
t1 = clock;
i = 0;   %itertion index

%just to achieve W_RF*W_D = W_mopt
V_equal = V_ropt;
v = trace (V_equal' * V_equal);
%random initialization
V_RF = exp( 1i*unifrnd(0,2*pi,Nt,Nrf));
W_RF = exp( 1i*unifrnd(0,2*pi,Nr,Nrf));
%iteration trigger, the normal initialization just for pass into functions
trigger = 1;
m_MSE_new = 100;
O = eye(Ns);
%limit the iterations number by i<10
while (trigger > 1e-4 && i<10)
    
    %combining
    H2 = H * V_equal;
    [W_RF, W_B] = Wgevd_W_algorithm(W_RF, v, H2, O);
        
    W_equal = W_RF * W_B;
    w = trace (W_equal' * W_equal);
    %modified MSE
    H_equal = W_equal'*H2;
    
    
    
    %weighted matrix
    E = (H_equal * H_equal' - H_equal - H_equal') + Vn * (W_equal)'*W_equal +eye(Ns);
    O = E^(-1);
    
    % precoding
    H1 = H' * W_equal;
    ow = trace(O*W_equal'*W_equal);
    [V_RF, V_U] = Wgevd_algorithm(V_RF, ow, H1, O);
    V_equal = V_RF *V_U;
    v = trace (V_equal * V_equal');   %beta^(-2)
    H_equal = H1' * V_equal;
    m_MSE_old = m_MSE_new;
    m_MSE_new = trace(O*(H_equal * H_equal' - H_equal - H_equal' + Vn * W_equal'*W_equal +eye(Ns)))...
        - log2(det(O));
    trigger = m_MSE_old - m_MSE_new;
    
    i = i + 1;
end

V_B = V_U / sqrt(v);
t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj = get_metric(obj);


