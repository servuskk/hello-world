%% 读取图片
img1=imread('3_1_1.png');
img2=imread('3_2_1.png');
%% 预处理
img1_1=im2double(rgb2gray(img1));
img2_1=im2double(rgb2gray(img2));
[M,N]=size(img1_1);
%% DFT矩阵生成
a=[0:1:M-1];
b=[0:1:N-1];
X=a'*a;
Y=b'*b;
W1=exp(-2*pi*1i*X/M);
W2=exp(-2*pi*1i*Y/N);
%% DFT
img1_2=W1*img1_1*W2;
img2_2=W1*img2_1*W2;
%% IDFT
img1_3=1/M/N*W1'*(abs(img1_2).*exp(1i*angle(img2_2)))*W2';
img2_3=1/M/N*W1'*(abs(img2_2).*exp(1i*angle(img1_2)))*W2';
%% show
subplot(2,2,1);imshow(img1_1),title('图一原始图像');
subplot(2,2,3);imshow(img2_1),title('图二原始图像');
subplot(2,2,2);imshow(real(img1_3)),title('图一幅值、图二相位IDFT');
subplot(2,2,4);imshow(real(img2_3)),title('图二幅值、图一相位IDFT');
