function modulated_signal = LAB1_QPSK_modulate(input,fc,fs)
% input (00 01 10 11)-> QPSK (-1,-1) (-1,+1) (1,-1) (1,1)

num = size(input,2);
% 采样频率 f(Hz)
f_s = fs;   %100
t_s = 1/f_s;
% 载波频率 f(Hz)
f_c = fc;  %2    
% omega
omega_c = 2*pi*f_c;

% 将01序列转换为1，-1（电平变换）
signal = 2*input-1;
% 奇偶序号分开(串并变换)
signal_odd = signal(1:2:num);
signal_even = signal(2:2:num);
% 采样
signal_s1 = zeros(1,num/2*f_s);
signal_s2 = zeros(1,num/2*f_s);
for i= 1:num/2
    signal_s1((i-1)*f_s+1:i*f_s) = signal_odd(i);
    signal_s2((i-1)*f_s+1:i*f_s) = signal_even(i);
end
% 载波调制
time = [0 : t_s : num/2-t_s];
carry_1 = cos(omega_c.*time);
carry_2 = sin(omega_c.*time);
signal_odd = signal_s1.*carry_1;
signal_even = signal_s2.*carry_2;
modulated_signal = signal_odd+signal_even;
end