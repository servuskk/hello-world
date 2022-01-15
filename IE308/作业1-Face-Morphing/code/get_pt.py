import cv2
import sys, os

PATH = r'C:/Users/admin/Desktop/'
IMG_PATH = PATH + '/DFB/9.jpg'


def OnMouse(event, x, y, flags, param):
    #EVENT_LBUTTONDOWN 左键点击
    if event == cv2.EVENT_LBUTTONDOWN:
        pts_2d.append([x, y])
        cv2.circle(img, (x, y), 1, (0, 255, 0), -1)


if __name__ == '__main__':
    pts_2d = []

    img = cv2.imread(IMG_PATH)
    cv2.namedWindow('image',cv2.WINDOW_NORMAL)
    #setMouseCallback 用来处理鼠标动作的函数
    #当鼠标事件触发时，OnMouse()回调函数会被执行 
    cv2.setMouseCallback('image',OnMouse)

    while 1:
        cv2.imshow("image", img)
        k = cv2.waitKey(1)
        if k == 27:
            break

    print(pts_2d)
