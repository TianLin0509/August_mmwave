%semilogy(-24:2:-12, BitErr(3,:),'LineWidth',2);

semilogy(SNR_dB, Total_Ber(:,7),'LineWidth',2);
hold on
semilogy(SNR_dB, Total_Ber(:,5),'LineWidth',2);
semilogy(SNR_dB, Total_Ber(:,4),'LineWidth',2);
semilogy(SNR_dB, Total_Ber(:,3),'LineWidth',2);
semilogy(SNR_dB, Total_Ber(:,6),'LineWidth',2);
semilogy(SNR_dB, Total_Ber(:,1),'LineWidth',2);