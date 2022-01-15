% LAB1 QPSK
% Task 1 Modulate-Demodulate(QPSK)
% Task 2 Modulate-Noise(AGWN+Rayleigh)-Demodulate
% Task 3 Encode-Modulate-Noise-Demodulate-Decode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------生成随机信号---------------------------------------
num = 100000;   %样本数
signal = randi([0 3],1,num);
%----------------------转换为二进制---------------------------------------
str = dec2bin(signal);
input = reshape(str-'0',1,num*2);
%----------------------QPSK调制------------------------------------------
input = input.*2-1;
input = input./sqrt(2);
Modulated_signal = input(1:num)+1i*input(num+1:num*2);
%---------------------调制星座图-----------------------------------------
plot(real(Modulated_signal),imag(Modulated_signal),"*");
xlim([-1 1])
ylim([-1 1])
hold on;
title("QPSK调制解调星座图")
%--------------------------QPSK解调--------------------------------------
dis0 = abs(Modulated_signal*sqrt(2) - (-1-1i));
dis1 = abs(Modulated_signal*sqrt(2) - (-1+1i));
dis2 = abs(Modulated_signal*sqrt(2) - (1-1i));
dis3 = abs(Modulated_signal*sqrt(2) - (1+1i));
dis=[dis0; dis1; dis2; dis3];
Demodulated_signal = zeros(1,num);
for n =1:num
    [~,Demodulated_signal(n)] = min(dis(:,n)); 
end
Demodulated_signal = Demodulated_signal -1;
%---------------------解调星座图-----------------------------------------
str = dec2bin(Demodulated_signal);
output = reshape(str-'0',1,num*2);
output = output.*2-1;
output = output./sqrt(2);
De_signal = output(1:num)+1i*output(num+1:num*2);
plot(real(De_signal),imag(De_signal),"o");
legend("调制信号","解调信号");
%-------------------------误码率分析------------------------------------
SER = size(signal(Demodulated_signal~=signal),2)/num;
