function output = add_noise(signal,SNR)
%NOISE 此处显示有关此函数的摘要
%   此处显示详细说明
n = size(signal,2);
r = randn(1,n); %产生均值为0、方差为1的高斯白噪声
% mean(r.*r)  1.00
% mean(r)  0
snr = 10^(SNR/10);
p = mean(signal.*signal);
n_p = p/snr;
output = signal+r*sqrt(n_p);
end

