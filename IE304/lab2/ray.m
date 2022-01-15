function out = ray(tx,rx)
%RAY 此处显示有关此函数的摘要
ray_para = 1/sqrt(2);
ray_size = [tx rx];
% ray_channel=sqrt(randn(ray_size,'like',ray_para).^2 + 1i*randn(ray_size,'like',ray_para).^2) .* ray_para;
ray_channel=(normrnd(0,sqrt(ray_para),ray_size)+1i*normrnd(0,sqrt(ray_para),ray_size))/sqrt(2);
out = ray_channel;
end
