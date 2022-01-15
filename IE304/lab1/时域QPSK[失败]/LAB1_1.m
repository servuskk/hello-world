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
f_s = 5/T;
% QPSK modulate
modulated_signal = LAB1_QPSK_modulate(signal,f_c,f_s);  % sampled
% QPSK demodulate (using an ideal low pass filter)
demodulated_signal = LAB1_QPSK_demodulate(modulated_signal,f_c,f_s);    % size(demodulated_signal)=size(signal)

SER = size(signal(signal~=demodulated_signal),2)/num;
hold on;
scatter(demodulated_signal(1:2:num),demodulated_signal(2:2:num),'*');
scatter(signal(1:2:num),signal(2:2:num));
legend("demodulated","signal")
