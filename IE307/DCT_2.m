%读取图片
img=imread('IMG.PNG');
%img=imread('666.png');
%% 输入图像
img_1=im2double(rgb2gray(img));
%% 分块dct
fun=@my_dct2;
img_2=blkproc(img_1,[8,8],fun);

%% 分块idct
fun=@my_idct2;
img_3=blkproc(img_2,[8,8],fun);
%% show
figure;
subplot(2,2,1);imshow(img),title('原图');hold on;
subplot(2,2,2);imshow(img_1),title('灰度图');hold on;
subplot(2,2,3);imshow(real(img_2)),title('分块DCT');hold on;
subplot(2,2,4);imshow(real(img_3)),title('分块IDCT');hold on;

function X= my_dct2(IMG)
w=zeros(8);
for i=1:6
    for j=1:6
        if i+j<8
            w(i,j)=1;
        end
    end
end
N=8;
a=[0:1:N-1];
A=a'*(2*a+1);
x=2/N*cos(A*pi/2/N)*IMG*cos(A'*pi/2/N);
x(1,:)=x(1,:)/sqrt(2);
x(:,1)=x(:,1)/sqrt(2);
X=w.*x;
end

function X= my_idct2(IMG)
N=8;
a=[0:1:N-1];
A=a'*(2*a+1);
IMG(1,:)=IMG(1,:)/sqrt(2);
IMG(:,1)=IMG(:,1)/sqrt(2);
X=2/N*cos(A'*pi/2/N)*IMG*cos(A*pi/2/N);
end
