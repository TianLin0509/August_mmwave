MO_sumqber = sum(MO.qber,2)/(2*N_loop*Nk*Ns);
SIPEVD_sumqber = sum(SIPEVD.qber,2)/(2*N_loop*Nk*Ns);
OMP_sumqber = sum(OMP.qber,2)/(2*N_loop*Nk*Ns);
plot(1:5,OMP_sumqber);
hold on 
plot(1:5,ones(5,1)*OMP.Ber);
plot(1:5,SIPEVD_sumqber);
plot(1:5,ones(5,1)*SIPEVD.Ber);
plot(1:5,MO_sumqber);
plot(1:5,ones(5,1)*MO.Ber);

