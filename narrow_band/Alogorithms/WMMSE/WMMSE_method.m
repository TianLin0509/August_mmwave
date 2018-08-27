function [obj] = WMMSE_method(obj)

%the algorithm for fully_digital design
%cite the paper Generalized linear precoder and decoder design for MIMO channels using the
%weighted mmse criterion

 global Ns Vn H V_ropt 
t1 = clock

B = V_ropt;
A = B'*H'*(H*B*B'*H' + eye(Ns))^(-1);
E = (eye(Ns) + B'*H'*H*B)^(-1);
W = E^(-1);
B = (H'*A'*W* A*H + trace(O

 
 
 
   %% save results  
   t2 = clock;
   runtime  = etime(t2,t1);
   obj.V_B = V_mopt;
   obj.W_B = W_mopt;
   obj.runtime = obj.runtime + runtime;
   obj = get_metric(obj);