% mmwave_ general simluation world
% for different algorithms, parameters, channels and metrics
% Author : Lin Tian    2018. 08. 09 for paper revision
% this one is for easier case narrowband, but can be extended to
% broadband easily.

clear all;  close all; clc;
disp(datestr(now));

% set up simulation parameters;
SNR_dB = (-22:2:-20);

%numbers of antennas, streams, RF chains, block
global Nt Nr Ns Nrf Nsym;   %all functions can use these paras without passing
Nt = 64;
Nr = 64;

Ns = 2;
Nrf = 2;
Nsym = 64;

global Metric;
%set the metric you want to get, now only support rate,mse and ber.
Metric.rate = true;
Metric.mse = true;
Metric.ber = true;

global N_loop;
N_loop = 20;   %iteration number
A_num = 1; %number of all algortihms

% state noise power and channel as global variables to
% avoid parameters passing

global Vn H Codebook_v Codebook_w n;

%using QPSK modulation
global hMod hDemod;

hMod = comm.PSKModulator(4,'BitInput',true,'PhaseOffset',pi/4);
hDemod = comm.PSKDemodulator('ModulationOrder',4,'BitOutput',true,'PhaseOffset',pi/4);


%Algorithms, use cell to save different algorithms to run
Algorithms = { 'MMSE','Mrate','GEVD','Yuwei','PE' ,'OMP', 'JZMO'};
%Algorithms  = {'MMSE','GEVD'};
for i = 1 : length(Algorithms)
    eval([Algorithms{i},'=Init_struct(i);']);
end

%global initialization (optimal based on MMSE or rate)
global  V_mopt W_mopt V_ropt W_ropt ;

for snr_index = 1 : length(SNR_dB)
    
    Vn = 1 / 10^(SNR_dB(snr_index)/10);   % Noise Power
    t1 = clock;
    
    for  n = 1 : N_loop
        
        % generate channel matrix, codebooks for OMP
        [H ,Codebook_v, Codebook_w]  = OMPH(Nt,Nr);

        %run different algorithms
        for i = 1:length(Algorithms)
            eval([Algorithms{i},'=',Algorithms{i},'_method(',Algorithms{i},');']);
        end
       
        if (n==10)
            mytoc(t1);
        end
    end
    
   
    for i = 1:length(Algorithms)
          disp(['AlgorithmName: ',Algorithms{i}]);
        eval(['Show(',Algorithms{i},');']);
    end
    disp(datestr(now));
end


