function out = modulate(inputsignal)
%MODULATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[m,n]=size(inputsignal);
%��ƽ�任
inputsignal=inputsignal*2-1;
inputsignal=inputsignal./sqrt(2);
%�����任
out = zeros(m,n/2);
for k=1:n/2
    for j=1:m
        out(j,k)=inputsignal(j,2*k-1)+1i*inputsignal(j,2*k);
    end
end

