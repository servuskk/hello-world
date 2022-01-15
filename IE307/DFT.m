%读取图片
img=imread('IMG.PNG');
img_1=im2double(rgb2gray(img));
%% DFT
[M,N]=size(img_1);

a=[0:1:M-1];
b=[0:1:N-1];

X=a'*a;
Y=b'*b;
W1=exp(-2*pi*1i*X/M);
W2=exp(-2*pi*1i*Y/N);

img_2=W1*img_1*W2;
%% IDFT
W1=exp(2*pi*1i*X/M);
W2=exp(2*pi*1i*Y/N);

img_3=1/M/N*W1*img_2*W2;

%% imshow
subplot(2,2,1);imshow(img),title('原图');hold on;
subplot(2,2,2);imshow(img_1),title('灰度图');hold on;
subplot(2,2,3);imshow(real(img_2)),title('DFT');hold on;
subplot(2,2,4);imshow(real(img_3)),title('IDFT');hold on;