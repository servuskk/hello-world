function out = demodulate(in,len)
%DEMODULATE 此处显示有关此函数的摘要
%   QPSK 2-并串变换
out = zeros(1,2*len);
r=real(in);
i=imag(in);
for j=1:len
    if(r(j)>0)
        out(2*j-1)=1;
    end
    if(i(j)>0)
        out(2*j)=1;
    end
end
end

