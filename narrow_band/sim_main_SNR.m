% mmwave_ general simluation world
% for different algorithms, parameters, channels and metrics
% Author : Lin Tian    2018. 08. 09 for paper revision
% this one is for easier case narrowband, but can be extended to
% broadband easily.

clear all;  close all; clc;
disp(datestr(now));

% set up simulation parameters;
%this .m is for BER,MSE,rate v.s. SNR
SNR_dB = (-21:3:-12);

%numbers of antennas, streams, RF chains, block
global Nt Nr Ns Nrf Nsym;   %all functions can use these paras without passing
Nt = 144;
Nr = 36;

Ns = 3;
Nrf = 3;
Nsym = 64;

global Metric;
%set the metric you want to get, now only support rate,mse and ber.
Metric.rate = 1;
Metric.mse = 1;
Metric.ber = 1;

global N_loop;
N_loop = 1000;   %iteration number

% state noise power and channel as global variables to
% avoid parameters passing

global Vn H Codebook_v Codebook_w n;

%using QPSK modulation
global hMod hDemod;

hMod = comm.PSKModulator(4,'BitInput',true,'PhaseOffset',pi/4);
hDemod = comm.PSKDemodulator('ModulationOrder',4,'BitOutput',true,'PhaseOffset',pi/4);


%Algorithms, use cell to save different algorithms to run
Algorithms = { 'MMSE','Mrate','GEVD','Yuwei','JZMO','MO','OMP'};
%Algorithms  = {'MMSE','Mrate','GEVD','WGEVD','WMO','MO','PE','Yuwei','JZMO'};
Algorithms = {'MMSE','OMP'};
%simulation results cell
total_datas = cell(length(SNR_dB),length(Algorithms));

for i = 1 : length(Algorithms)
    eval([Algorithms{i},'=Init_struct(Algorithms{i});']);
end

%global initialization (optimal based on MMSE or rate)
global  V_mopt W_mopt V_ropt W_ropt ;
global manifold;
manifold = complexcirclefactory(Nt*Nrf);

%fixed channel
%H_fixed = gen_H(Nt,Nr,N_loop);
%load('JZH.mat')

fprintf('params: \n Nt: %d  Nr: %d  Ns: %d N_loop: %d Nrf: %d \n SNR: %d : %d \n',...
    Nt,Nr,Ns,N_loop,Nrf,SNR_dB(1),SNR_dB(end));

for snr_index = 1 : length(SNR_dB)
    
    if (SNR_dB(snr_index) > -15)
        N_loop = 10000;
    end
    
    Vn = 1 / 10^(SNR_dB(snr_index)/10);   % Noise Power
    t1 = clock;
    
    for  n = 1 : N_loop
        
        % generate channel matrix, codebooks for OMP
        [H ,Codebook_v, Codebook_w]  = OMPH(Nt,Nr);
        %H = JZH(:,:,n);
        
        %run different algorithms
        for i = 1:length(Algorithms)
            eval([Algorithms{i},'=',Algorithms{i},'_method(',Algorithms{i},');']);
        end
        
        if (n==10)
            mytoc(t1);
        end
    end
    
    
    for i = 1:length(Algorithms)
        eval([Algorithms{i},'=Show(',Algorithms{i},');']);
        eval(['total_datas{snr_index,i}=',Algorithms{i},';']);
    end
    
    disp(datestr(now));
end

%plot figures for different metrics
%[Total_Rate, Total_Mse, Total_Ber] = simulation_plot(total_datas,SNR_dB, Algorithms);


