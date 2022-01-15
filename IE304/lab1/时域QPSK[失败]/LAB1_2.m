clear;
%%%%%%%%%%%% 生成随机序列作为原始信号  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = 1;          % 信号周期（宽度）
num = 10^6;     % 随机序列长度（必须是偶数）
t = T*num;      %总时长
signal = rand(1,num);
signal(signal<0.5)=0;
signal(signal>0)=1;
%%%%%%%%%%%% QPSK调制  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 载波频率 f(Hz)
f_c = 2/T;        

% 采样频率 f(Hz)
f_s = 16/T;
% QPSK modulate
modulated_signal = LAB1_QPSK_modulate(signal,f_c,f_s);  % sampled
% channel: Rayleigh fading & White Gaussian Noise
% SNR = 0;    % -30 : 5 : 20
% signal_receive = LAB1_channel(modulated_signal,SNR);
% % QPSK demodulate (using an ideal low pass filter)
% demodulated_signal = LAB1_QPSK_demodulate(signal_receive,f_c,f_s);    % size(demodulated_signal)=size(signal)
% SER = [SER,size(signal(signal~=demodulated_signal),2)/num];
SNR =-10:1:15;
SER=zeros(size(SNR));
for i=1:size(SNR,2)
    signal_receive = LAB1_channel(modulated_signal,SNR(i));
    demodulated_signal = LAB1_QPSK_demodulate(signal_receive,f_c,f_s);
    SER(i) = size(signal(signal~=demodulated_signal),2)/num;
end
semilogy(SNR,SER,'*');
hold on;
SNR1 = 0.5*(10.^(SNR/10)); 
QPSK_t_Ray = -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));
semilogy(SNR,QPSK_t_Ray,'*');

grid on;


