function output = add_noise(signal,SNR)
%NOISE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n = size(signal,2);
r = randn(1,n); %������ֵΪ0������Ϊ1�ĸ�˹������
% mean(r.*r)  1.00
% mean(r)  0
snr = 10^(SNR/10);
p = mean(signal.*signal);
n_p = p/snr;
output = signal+r*sqrt(n_p);
end

