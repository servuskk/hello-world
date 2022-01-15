% 实现 MIMO通信仿真系统设计；
% 采用 LMMSE接收机， 绘制误码率曲线；
% 采用 MIMO空时码或其他技术，分析其对误码率的改进；
% 加入信道编解码，分析其对误码率的改进。

% Author：   王寒
% Time：     2021/6/27 20:51
% File:      lab2_2.m

% 系统参数可有如下参考：可考虑4x4MIMO且仅采用空分复用技术 、 AWGN或瑞利衰落信道
% 在最基本的系统实现里可以不考虑信道估计等其他条件。
%-----------------------------------------------------------------------%
% 串并变换
% 4x4 MIMO
num_tx = 4; %发送天线x4
num_rx = 4; %接收天线x4

% 生成随机数
num = 16000;   %样本数
signal = randi([0 1],1,num);
%串并变换(4x4)
input4=zeros(num_tx,num/num_tx);
for i =1:num/num_tx
    input4(1,i)=signal((i-1)*num_tx+1);
    input4(2,i)=signal((i-1)*num_tx+2);
    input4(3,i)=signal((i-1)*num_tx+3);
    input4(4,i)=signal((i-1)*num_tx+4);
end
%QPSK
modulated_signal=modulate(input4);
%4发射空时码编码
[tx,len]=size(modulated_signal);
STBC_signal=[];
for i=1:len
    x=modulated_signal(:,i);
    X1=[x(1) -x(2) -x(3) -x(4)];
    X2=[x(2) x(1) x(4) -x(3)];
    X3=[x(3) -x(4) x(1) x(2)];
    X4=[x(4) x(3) -x(2) x(1)];
    X=[X1;X2;X3;X4];
    STBC_signal=[STBC_signal X conj(X)];
end
%channel
[~,len]=size(STBC_signal);
SER=[];
SNRS=-15:10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for SNR=SNRS
    snr = 10^(SNR/10);
    X=[];
    STBC_out=[];
    for i=1:8:len
        ray_channel=ray(num_tx,num_rx);
        Ray_signal=zeros(4,8);
        for j=1:8
            Ray_signal(:,j)=ray_channel*STBC_signal(:,i-1+j);
        end
        %Gsussian
        AWGN_size = size(Ray_signal);
        r = (randn(AWGN_size)+1i*randn(AWGN_size)); %产生高斯白噪声
        r_p = mean(abs(r.*r)); %计算随机噪声平均功率
        p = mean(abs(Ray_signal.*Ray_signal))/snr; %根据SNR计算噪声平均功率
        receive=Ray_signal+r*sqrt(p/r_p);
        %receiver&demodulate
        %接收机
        H=ray_channel;
        Z=zeros(4,4);
        for j=1:4
            Habs(:,j)=sum(abs(H(j,:)).^2,2);
            z11(j)=receive(j,1).*conj(H(j,1))+receive(j,2).*conj(H(j,2))+receive(j,3).*conj(H(j,3))+receive(j,4).*conj(H(j,4));
            z12(j)=conj(receive(j,5)).*H(j,1)+conj(receive(j,6)).*H(j,2)+conj(receive(j,7)).*H(j,3)+conj(receive(j,8)).*H(j,4);
            Z(j,1)=z11(j)+z12(j);
            z21(j)=receive(j,1).*conj(H(j,2))-receive(j,2).*conj(H(j,1))-receive(j,3).*conj(H(j,4))+receive(j,4).*conj(H(j,3));
            z22(j)=conj(receive(j,5)).*H(j,2)-conj(receive(j,6)).*H(j,1)-conj(receive(j,7)).*H(j,4)+conj(receive(j,8)).*H(j,3);
            Z(j,2)=z21(j)+z22(j);
            z31(j)=receive(j,1).*conj(H(j,3))+receive(j,2).*conj(H(j,4))-receive(j,3).*conj(H(j,1))-receive(j,4).*conj(H(j,2));
            z32(j)=conj(receive(j,5)).*H(j,3)+conj(receive(j,6)).*H(j,4)-conj(receive(j,7)).*H(j,1)-conj(receive(j,8)).*H(j,2);
            Z(j,3)=z31(j)+z32(j);
            z41(j)=receive(j,1).*conj(H(j,4))-receive(j,2).*conj(H(j,3))+receive(j,3).*conj(H(j,2))-receive(j,4).*conj(H(j,1));
            z42(j)=conj(receive(j,5)).*H(j,4)-conj(receive(j,6)).*H(j,3)+conj(receive(j,7)).*H(j,2)-conj(receive(j,8)).*H(j,1);
            Z(j,4)=z41(j)+z42(j);
        end   
        % 顺便做QPSK解调
        s_table=exp(1i*pi/4*[-3 3 1 -1]);
        s_table=s_table([0 1 3 2]+1);
        for m=1:4
            tmp = (-1+sum(Habs,2))*abs(s_table(m))^2;
            for j=1:4
                d(m,j) = abs(sum(Z(:,j),1)-s_table(m)).^2 + tmp;
            end
        end
        Xd=[];
        for n=1:4
            [yn,in]=min(d(:,n),[],1); 
            Xd = [Xd s_table(in).'];
        end
        STBC_out=[STBC_out;Xd];
        %每行有四个复数数据，是QPSK解调之后的，在4个天线上同时发送，每个时刻发送一行（分八个符号）；每一列是一个天线！
    end
    %4-并串变换
    out=zeros(size(signal));
    for i=1:len/8   %每次处理一行（同时发送的）
        r4=real(STBC_out(i,:));
        i4=imag(STBC_out(i,:));
        out(8*(i-1)+1)=r4(1)>0;
        out(8*(i-1)+2)=r4(2)>0;
        out(8*(i-1)+3)=r4(3)>0;
        out(8*(i-1)+4)=r4(4)>0;
        out(8*(i-1)+5)=i4(1)>0;
        out(8*(i-1)+6)=i4(2)>0;
        out(8*(i-1)+7)=i4(3)>0;
        out(8*(i-1)+8)=i4(4)>0;      
    end
    %误码分析
    [~,n]=size(out(out~=signal));
    SER=[SER,n/num];
end

% 画图
semilogy(SNRS,SER,'r--*');
hold on;
title("4X4MIMO瑞利衰落和高斯信道下的LMMSE接收机和STBC误码率")
ylabel('SER')
xlabel('SNR(dB)')
legend("LMMSE接收机","STBC")
