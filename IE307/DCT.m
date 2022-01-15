%读取图片
img=imread('IMG.PNG');
%显示原输入图像
%imshow(img),title('原输入图像');
%RGB转灰度图
img_10=im2double(rgb2gray(img));
%% DCT
[m,n]=size(img_10);
N=max(m,n);
if (N==n)
    img_1=[img_10;zeros(N-m,n)];
    flag=1;
else
    img_1=[img_10,zeros(m,N-n)];
    flag=0;
end

a=[0:1:N-1];
X=a'*(2*a+1);
img_2=2/N*cos(X*pi/2/N)*img_1*cos(X'*pi/2/N);
img_2(1,:)=img_2(1,:)/sqrt(2);
img_2(:,1)=img_2(:,1)/sqrt(2);
%% IDCT
W=X';
img_2(1,:)=img_2(1,:)/sqrt(2);
img_2(:,1)=img_2(:,1)/sqrt(2);
img_3=2/N*cos(W*pi/2/N)*img_2*cos(W'*pi/2/N);
if flag
    img_3=img_3(1:m,:);
else
    img_3=img_3(:,1:n);
end
%% SHOW
subplot(2,2,1);imshow(img),title('原图');hold on;
subplot(2,2,2);imshow(img_10),title('灰度图');hold on;
subplot(2,2,3);imshow(img_2),title('DCT');hold on;
subplot(2,2,4);imshow(img_3),title('IDCT');hold on;