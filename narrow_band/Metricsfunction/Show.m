function obj = Show(obj)
global Nsym N_loop Ns;
            
            obj.Rate =  real(sum(obj.rate)/N_loop);
            
            obj.Mse = real(sum(obj.mse)/N_loop);
            
            obj.Ber = sum(obj.ber)/(2*N_loop*Nsym*Ns);
            
            disp(['Name: ', obj.Name]);
            
            disp(['Rate: ', num2str(obj.Rate)]);
            
            disp(['Mse: ',num2str(obj.Mse)]);
            
            disp(['Ber: ',num2str(obj.Ber)]);
            
            disp(['Total Time: ' num2str(obj.runtime)]);
            
            disp(' ');