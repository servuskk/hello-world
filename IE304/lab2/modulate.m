function out = modulate(inputsignal)
%MODULATE 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n]=size(inputsignal);
%电平变换
inputsignal=inputsignal*2-1;
inputsignal=inputsignal./sqrt(2);
%串并变换
out = zeros(m,n/2);
for k=1:n/2
    for j=1:m
        out(j,k)=inputsignal(j,2*k-1)+1i*inputsignal(j,2*k);
    end
end

