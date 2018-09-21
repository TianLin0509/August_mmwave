test_mse = OMP.mse;
x_hist = [0, 0.13, 0.23, 0.33 0.83];
histc(test_mse,x_hist)

test_ber = EVD.ber/Nk/Ns/2;

y_hist = [0 0.0001 0.001 0.01 0.02 0.1];
histc(test_ber,y_hist)