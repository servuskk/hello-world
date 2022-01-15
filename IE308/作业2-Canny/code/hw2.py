import math
import numpy as np
from scipy import signal
import cv2
import os

# 1.读取图片文件
# 2.rgb2gray
# 3.高斯滤波器平滑图像
# 首先生成二维高斯分布矩阵
# 然后与灰度图像进行卷积实现滤波
# 4.一阶差分卷积
# 5.非极大值抑制
# 每个元素有8个相邻元素，选择其中两个进行比较
# 确定比较的对象纵向（theta = pi/2），横向（theta = 0），左上（theta = -pi/4），右上（theta = pi/4）

def get_NMS(d, theta):
    w, h = d.shape
    theta = np.round(theta/(math.pi/4)) # -2, -1, 0, 1, 2
    NMS = np.zeros((w-1, h-1))
    for i in range(1, w-1):
        for j in range(1, h-1):
            if theta[i][j]==0:
                # 竖直
                m = max(d[i][j-1],d[i][j],d[i][j+1])
                if m == d[i][j]:
                    NMS[i-1][j-1] = d[i][j]
            elif theta[i][j]==1:
                # 右上
                m = max(d[i-1][j-1],d[i][j],d[i+1][j+1])
                if m == d[i][j]:
                    NMS[i-1][j-1] = d[i][j]
            elif theta[i][j]==-1:
                # 右下
                m = max(d[i-1][j+1],d[i][j],d[i+1][j-1])
                if m == d[i][j]:
                    NMS[i-1][j-1] = d[i][j]
            else:
                # 水平
                m = max(d[i-1][j],d[i][j],d[i+1][j])
                if m == d[i][j]:
                    NMS[i-1][j-1] = d[i][j]
    return NMS
# NMS = get_NMS(d, theta)

# 6.阈值化
def check_neighbor(NMS, i, j):
    w, h = NMS.shape
    dots = np.zeros((8,1))
    if (i,j) == (0, 0):
        dots[4] = NMS[i][j+1]
        dots[6] = NMS[i+1][j]
        dots[7] = NMS[i+1][j+1]
    elif (i, j) == (0, h-1):
        dots[3] = NMS[i][j-1]
        dots[5] = NMS[i+1][j-1]
        dots[6] = NMS[i+1][j]
    elif (i, j) == (w-1, 0):
        dots[1] = NMS[i-1][j]
        dots[2] = NMS[i-1][j+1]
        dots[4] = NMS[i][j+1]
    elif (i, j) == (w-1, h-1):
        dots[0] = NMS[i-1][j-1]
        dots[1] = NMS[i-1][j]
        dots[3] = NMS[i][j-1]
    elif i == 0:
        dots[3] = NMS[i][j-1]
        dots[4] = NMS[i][j+1]
        dots[5] = NMS[i+1][j-1]
        dots[6] = NMS[i+1][j]
        dots[7] = NMS[i+1][j+1]
    elif j == 0:
        dots[1] = NMS[i-1][j]
        dots[2] = NMS[i-1][j+1]
        dots[4] = NMS[i][j+1]
        dots[6] = NMS[i+1][j]
        dots[7] = NMS[i+1][j+1]
    elif i == w-1:
        dots[0] = NMS[i-1][j-1]
        dots[1] = NMS[i-1][j]
        dots[2] = NMS[i-1][j+1]
        dots[3] = NMS[i][j-1]
        dots[4] = NMS[i][j+1]
    elif j == h-1:
        dots[0] = NMS[i-1][j-1]
        dots[1] = NMS[i-1][j]
        dots[3] = NMS[i][j-1]
        dots[5] = NMS[i+1][j-1]
        dots[6] = NMS[i+1][j]
    else :
        dots[0] = NMS[i-1][j-1]
        dots[1] = NMS[i-1][j]
        dots[2] = NMS[i-1][j+1]
        dots[3] = NMS[i][j-1]
        dots[4] = NMS[i][j+1]
        dots[5] = NMS[i+1][j-1]
        dots[6] = NMS[i+1][j]
        dots[7] = NMS[i+1][j+1]
    if np.max(dots) > 0.16*np.max(NMS):
        return 1
    else:
        return 0


def get_output(NMS):
    TL = 0.08 * np.max(NMS)
    TH = 0.16 * np.max(NMS)
    outline = np.zeros(NMS.shape)
    outline[NMS > TH] = 1
    w, h = NMS.shape
    for i in range(w):
        for j in range(h):
            if NMS[i][j] >= TL and NMS[i][j] <= TH:
                outline[i, j] = check_neighbor(NMS, i, j)
    return outline
# 7.结果保存


def my_canny(img_path, save_path):
    # 1.读取图片文件
    img = cv2.imread(img_path)
    # 2.rgb2gray
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # 3.高斯滤波器平滑图像
    blur = cv2.GaussianBlur(gray, (5, 5), 0)
    cv2.imwrite(save_path+'1_blur5x5.jpg', blur)
    # 4.一阶差分卷积
    H1 = np.array([(-1, -1),(1, 1)])
    H2 = np.array([(1, -1),(1, -1)])
    dy = signal.convolve2d(blur, H1)
    dx = signal.convolve2d(blur, H2)
    d = np.sqrt(dy*dy + dx*dx)
    theta = np.arctan(np.divide(dy,dx,out=np.zeros_like(dy, dtype=np.float64), where=dx!=0))
    cv2.imwrite(save_path+'2_d.jpg', d)
    # theta in [-pi/2, pi/2]
    # 5.非极大值抑制
    NMS = get_NMS(d, theta)
    cv2.imwrite(save_path+'3_NMS.jpg', NMS)
    # 6.阈值化
    output = get_output(NMS)*255
    cv2.imwrite(save_path+'4_final.jpg', output)
    test1 = (output + 255) % 510
    cv2.imwrite(save_path + '5_black.jpg', test1)
    test2 = img
    test2[output==0,:] = 255
    cv2.imwrite(save_path + '6_color.jpg', test2)
    # print("img", img.shape)
    # print("blur", blur.shape)
    # print("d", d.shape)
    # print("NMS", NMS.shape)
    # print("final", output.shape)

if __name__ == "__main__":
    img_name = './bastian.jpg'
    file_name = img_name.replace('.jpg','') + '/'
    if not os.path.exists(file_name):
        os.makedirs(file_name)
    my_canny(img_name,file_name)





