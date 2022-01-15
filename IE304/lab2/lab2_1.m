% 实现 MIMO通信仿真系统设计；
% 采用 LMMSE接收机， 绘制误码率曲线；
% 采用 MIMO空时码或其他技术，分析其对误码率的改进；
% 加入信道编解码，分析其对误码率的改进。

% Author：   王寒
% Time：     2021/6/27 15:12
% File:      lab2_1.m

% 系统参数可有如下参考：可考虑4x4MIMO且仅采用空分复用技术 、 AWGN或瑞利衰落信道
% 在最基本的系统实现里可以不考虑信道估计等其他条件。
%-----------------------------------------------------------------------%
% 串并变换
% 4x4 MIMO
num_tx = 4; %发送天线x4
num_rx = 4; %接收天线x4

% 生成随机数
num = 40000;   %样本数
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
%channel
[~,len]=size(modulated_signal);
SER=[];
SNRS=-15:10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for SNR=SNRS
    snr = 10^(SNR/10);
    X=[];
    for i=1:len
        ray_channel=ray(num_tx,num_rx);
        Ray_signal=ray_channel*modulated_signal(:,i);
        %Gsussian
        AWGN_size = size(Ray_signal);
        r = (randn(AWGN_size)+1i*randn(AWGN_size)); %产生高斯白噪声
        r_p = mean(abs(r.*r)); %计算随机噪声平均功率
        p = mean(abs(Ray_signal.*Ray_signal))/snr; %根据SNR计算噪声平均功率
        receive=Ray_signal+r*sqrt(p/r_p);
        %receiver&demodulate
        %LMMSE接收机
        H=ray_channel;
        conH=H';
        Im=eye(4);
        D=conH*(H*conH+p*Im)^(-1);
        X=[X,D*receive];
    end
    %每一行都是一个QPSK信号，应该先对QPSK解调，2-并串变换后进行MIMO解码，4-并串变换
    output_QPSK=zeros(num_tx,len*2);
    for i=1:num_tx
        output_QPSK(i,:)=demodulate(X(i,:),len);
    end
    out=zeros(size(signal));
    for i=1:2*len
        out(4*(i-1)+1)=output_QPSK(1,i);
        out(4*(i-1)+2)=output_QPSK(2,i);
        out(4*(i-1)+3)=output_QPSK(3,i);
        out(4*(i-1)+4)=output_QPSK(4,i);
    end
    %误码分析
    [~,n]=size(out(out~=signal));
    SER=[SER,n/num];
end
% 画图
semilogy(SNRS,SER,'b--^');
hold on;
title("4X4MIMO瑞利衰落和高斯信道下的LMMSE接收机误码率")
ylabel('SER')
xlabel('SNR(dB)')
%MIMO空时码-这是下一阶段才要考虑的问题
