function Show(obj)
global Nsym N_loop Ns;
            
            obj.Rate =  sum(obj.rate)/N_loop;
            
            obj.Mse = sum(obj.mse)/N_loop;
            
            obj.Ber = sum(obj.ber)/(2*N_loop*Nsym*Ns);
            
            disp(['Rate: ', num2str(real(obj.Rate))]);
            
            disp(['Mse: ',num2str(real(obj.Mse))]);
            
            disp(['Ber: ',num2str(obj.Ber)]);
            
            disp(' ');