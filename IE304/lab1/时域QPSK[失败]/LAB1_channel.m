% function signal_receive = LAB1_channel(input,SNR)
% n=size(input, 2);
% % 瑞利衰减
% ray_size = [2,n];
% ray_para = 1/sqrt(2);
% ray=sqrt(randn(ray_size,'like',ray_para).^2 + randn(ray_size,'like',ray_para).^2) .* ray_para;
% % 处理信号
% signal_r_real=ray(1).*real(input);
% signal_r_image=ray(2).*imag(input);
% 
% % 高斯白噪声
% signal_r_n_real = add_noise(signal_r_real, SNR);
% signal_r_n_image = add_noise(signal_r_image, SNR);
% 
% signal_receive = signal_r_n_real+1i*signal_r_n_image;
% end

function signal_receive = LAB1_channel(input,SNR)
n=size(input, 2);
% 瑞利衰减
ray_size = [1,n];
ray_para = 1/sqrt(2);
ray=sqrt(randn(ray_size,'like',ray_para).^2 + randn(ray_size,'like',ray_para).^2) .* ray_para;
% ray = raylrnd(ray_para,ray_size);
% 处理信号
signal_r=ray.*input;

% 高斯白噪声
% signal_receive = add_noise(signal_r, SNR);
signal_receive = awgn(signal_r,SNR);
end