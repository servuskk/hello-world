clear;
%%%%%%%%%%%% 生成随机序列作为原始信号  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = 1;          % 信号周期（宽度）
num = 10^4;     % 随机序列长度（必须是偶数）
t = T*num;      %总时长
signal = rand(1,num);
signal(signal<0.5)=0;
signal(signal>0)=1;
%%%%%%%%%%%% (7,4)汉明码编码%%%%%%%%%%%%%%%%%%%%%%%%%%%
encoded_signal = LAB1_encode(signal);
%%%%%%%%%%%% QPSK调制  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 载波频率 f(Hz)
f_c = 2/T;        
% 采样频率 f(Hz)
f_s = 5/T;
% QPSK modulate
modulated_signal = LAB1_QPSK_modulate(encoded_signal,f_c,f_s);  % sampled
SNR = -30:1:20;
SER=zeros(size(SNR));
for i=1:size(SNR,2)
    % 瑞丽衰减+高斯白噪声
    signal_receive = LAB1_channel(modulated_signal,SNR(i));
    % 解调
    demodulated_signal = LAB1_QPSK_demodulate(signal_receive,f_c,f_s);
    % 解码
    decoded_signal = LAB1_decode(demodulated_signal);
    SER(i) = size(signal(signal~=decoded_signal),2)/num;
end

semilogy(SNR,SER,'*');
hold on;
grid on;


