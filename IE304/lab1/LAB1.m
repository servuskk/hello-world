% LAB1 QPSK
% Task 1 Modulate-Demodulate(QPSK)
% Task 2 Modulate-Noise(AGWN+Rayleigh)-Demodulate
% Task 3 Encode-Modulate-Noise-Demodulate-Decode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------生成随机信号---------------------------------------
num = 800;   %样本数
signal = randi([0 3],1,num);
%----------------------转换为二进制---------------------------------------
str = dec2bin(signal)-'0';
str = str'; %size [2,num]
input = zeros(1,2*num);
% 转成一串
for i=1:num
    input(2*(i-1)+1)=str(1,i);
    input(2*i)=str(2,i);
end
%----------------------（7，4）汉明码编码-------------------------------
encode_signal = zeros(1,num/2*7);
% G = [I Q];
G=[ 1 0 0 0 1 1 1;
    0 1 0 0 1 1 0;
    0 0 1 0 1 0 1;
    0 0 0 1 0 1 1;];
for i = 1:num/2
    code = mod([input(4*(i-1)+1),input(4*(i-1)+2),input(4*(i-1)+3),input(4*(i-1)+4)]*G,2);
    for j=1:7
        encode_signal(7*(i-1)+j)=code(j);
    end
end
%----------------------QPSK调制------------------------------------------
input = encode_signal.*2-1;
input = input./sqrt(2);
Modulated_signal = input(1:2:num/2*7)+1i*input(2:2:num/2*7);
%----------------------信道噪声：瑞利衰减---------------------------------
ray_para = 1/sqrt(2);
ray_size = size(Modulated_signal);
ray=sqrt(randn(ray_size,'like',ray_para).^2 + randn(ray_size,'like',ray_para).^2) .* ray_para;
Ray_signal = Modulated_signal.*ray;
% %----------------------信道噪声：高斯白噪声-------------------------------
SNR = 20;
AWGN_size = size(Modulated_signal);
r = (randn(AWGN_size)+1i*randn(AWGN_size)); %产生高斯白噪声
r_p = mean(abs(r.*r)); %计算随机噪声平均功率
snr = 10^(SNR/10);
p = mean(abs(Modulated_signal.*Modulated_signal))/snr; %根据SNR计算噪声平均功率
AWGN_signal = Ray_signal+r*sqrt(p/r_p);
%-------------------------接收星座图-------------------------------------
Received_signal = AWGN_signal;
% hold on;
% plot(real(Received_signal),imag(Received_signal),"bo");
% plot(real(Modulated_signal),imag(Modulated_signal),"r*");
% % xlim([-1 1])
% % ylim([-1 1])
% legend("接收端信号","发送端信号")
% title("瑞利高斯信道星座图para=0.7071 SNR=20dB")
%--------------------------QPSK解调->bin-----------------------------------
dis0 = abs(Received_signal*sqrt(2) - (-1-1i));
dis1 = abs(Received_signal*sqrt(2) - (-1+1i));
dis2 = abs(Received_signal*sqrt(2) - (1-1i));
dis3 = abs(Received_signal*sqrt(2) - (1+1i));
dis=[dis0; dis1; dis2; dis3];
encoded_signal = zeros(size(encode_signal));
for n =1:num/4*7
    [~,Demodulated_signal] = min(dis(:,n));
    Demodulated_signal=Demodulated_signal-1;
    if Demodulated_signal==0
        encoded_signal(2*(n-1)+1)=0;
        encoded_signal(2*(n-1)+2)=0;
    end
    if Demodulated_signal==1
        encoded_signal(2*(n-1)+1)=0;
        encoded_signal(2*(n-1)+2)=1;
    end
    if Demodulated_signal==2
        encoded_signal(2*(n-1)+1)=1;
        encoded_signal(2*(n-1)+2)=0;
    end
    if Demodulated_signal==3
        encoded_signal(2*(n-1)+1)=1;
        encoded_signal(2*n)=1;
    end
end
%----------------------（7，4）汉明码解码-------------------------------
% H = [ P I ] = [Q' I]
H=[ 1 1 1 0 1 0 0;
    1 1 0 1 0 1 0;
    1 0 1 1 0 0 1;];
out = zeros(1,num);
for i=1:num/2
    code = encoded_signal(7*(i-1)+1:7*i);
    O = mod(code*H',2);
    if O~=[0 0 0]
        for n=1:7
            if O==H(:,n)
                code(n)=~code(n);
            end
        end
    end  
    out(2*(i-1)+1)= 2*code(1)+code(2);
    out(2*i)=2*code(3)+code(4);
end
%-------------------------误码率分析------------------------------------
SER = size(signal(out~=signal),2)/num;

