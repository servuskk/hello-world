function demodulated_signal = LAB1_QPSK_demodulate(signal,fc,fs)
% 采样频率 f(Hz)
f_s = fs ;
t_s = 1/f_s;
% 载波频率 f(Hz)
f_c = fc;     
% omega
omega_c = 2*pi*f_c;
num = size(signal,2);
% 载波
time = [0 : num-1]*t_s;
carry_1 = cos(omega_c.*time);
carry_2 = sin(omega_c.*time);
% LPF
signal_odd = LAB1_lpf(signal.*carry_1,fc,fs);
signal_even = LAB1_lpf(signal.*carry_2,fc,fs);
demodulated_signal = zeros(1,2*num/fs);
for i=1:num/fs
    if sum(signal_odd((i-1)*fs+fs/2))>0
        demodulated_signal(2*i-1)= 1;
    end
    if sum(signal_even((i-1)*fs+fs/2))>0
        demodulated_signal(2*i)= 1;
    end
end
end



