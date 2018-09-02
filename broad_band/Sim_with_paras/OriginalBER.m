% mmwave_ general simluation world
% for different algorithms, parameters, channels and metrics
% Author : Lin Tian    2018. 08. 11 for paper revision
% this one is for broadband case.

clear all;  close all; clc;
disp(datestr(now));

% set up simulation parameters;
%this .m is for BER,MSE,rate v.s. SNR
SNR_dB = (-27:3:-9);

%numbers of antennas, streams, RF chains, sub_carriers
global Nt Nr Ns Nrf  Nk;   %all functions can use these paras without passing
Nt = 64;
Nr =64;

Ns = 2;
Nrf = 2;
Nk = 64;

global Metric;
%set the metric you want to get, now only support rate,mse and ber.
Metric.rate = 1;
Metric.mse = 0;
Metric.ber = 1;
Metric.qber = 0;  %quantiazed analog beamformer

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
%Algorithms = { 'MMSE','Mrate','SIPEVD','WMO','Yuwei','JZMO','MO'};
%Algorithms  = {'MMSE','Mrate','EVD','SIPEVD'};
Algorithms = { 'MMSE','Mrate','SIPEVD','Yuwei','JZMO','MO','WMO'};

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

fprintf('params: \n Nt: %d  Nr: %d  Ns: %d N_loop: %d Nrf: %d \n SNR: %d : %d \n',...
    Nt,Nr,Ns,N_loop,Nrf,SNR_dB(1),SNR_dB(end));

for snr_index = 1 : length(SNR_dB)
    Vn = 1 / 10^(SNR_dB(snr_index)/10);   % Noise Power
    t1 = clock;
    if (SNR_dB(snr_index) > -15)
        N_loop = 2000;
    end
    for  n = 1 : N_loop
        
        % generate channel matrix, codebooks for OMP
        [H ,Codebook_v, Codebook_w]  = OMPHWB(Nt,Nr);
        %H = H_fixed(:,:,n);
        
        %run different algorithms
        for i = 1:length(Algorithms)
            eval([Algorithms{i},'=',Algorithms{i},'_wbmethod(',Algorithms{i},');']);
        end
        
        if (n==10)
            mytoc(t1);
        end
    end
    
    disp (['Now SNR:', num2str(SNR_dB(snr_index))]);
    for i = 1:length(Algorithms)
        eval([Algorithms{i},'=Show(',Algorithms{i},');']);
        eval(['total_datas{snr_index,i}=',Algorithms{i},';']);
    end
    
    
    disp(datestr(now));
end

%plot figures for different metrics
simulation_plot(total_datas,SNR_dB, Algorithms);


