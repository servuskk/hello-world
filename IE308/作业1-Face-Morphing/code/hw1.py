# HW1: Face Morphing
import cv2
import os
import dlib
import numpy as np


PATH = r'C:/Users/admin/Desktop/'
IMG_PATH_1 = PATH + '/DFB/7.jpg'
IMG_PATH_2 = PATH + '/DFB/9.jpg'
PREDICTOR_PATH = PATH + "shape_predictor_68_face_landmarks.dat"

# part1: 特征点提取
def draw_points(img, points):
    for pt in points:
        cv2.circle(img, pt, 1, (255,0, 0), 2)
    cv2.imwrite(PATH+'2333.jpg',img)
    

def outline_points(img, points):
    size = img.shape    # [1536,1024]
    points.append((0,0))
    points.append((size[1]-1, size[0]-1))
    points.append((0, size[0]-1))
    points.append((size[1]-1, 0))

    points.append((0, size[0]//2))
    points.append((size[1]-1, size[0]//2))
    points.append((size[1]//2, 0))
    points.append((size[1]//2, size[0]-1))

    # points.append((size[1]//4, 0))
    # points.append((size[1]//4, size[0]-1))
    # points.append((3*size[1]//4, 0))
    # points.append((3*size[1]//4, size[0]-1))

    points.append((0, size[0]//4))
    points.append((size[1]-1, size[0]//4))
    points.append((0, 3*size[0]//4))
    points.append((size[1]-1, 3*size[0]//4))
    return points 

def addition_points(points):
    # 仅手动标注时使用
    f = open(PATH+"DFB/7.txt","r")
    lines = f.readlines()
    f.close()
    line = lines[0]
    addition = line.replace('\n','')
    addition = addition.replace('[','')
    addition = addition.replace(']','')
    addition = addition.split(',')
    for i in range(0, len(addition),2):
        points.append((int(addition[i]),int(addition[i+1])))
    if len(lines)>1 :
        f = open(PATH+"DFB/7.txt","w")
        f.write(lines[1])
    return points
    

def get_points(img):
    points = []
    # img = cv2.imread(img_path)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    detector = dlib.get_frontal_face_detector()
    predictor = dlib.shape_predictor(PREDICTOR_PATH)
    faces = detector(gray, 1)
    for _, face in enumerate(faces):
        # 获取人脸特征点
        shape = predictor(img, face)
        # 遍历所有点
        for pt in shape.parts():
            # 特征点
            points.append((pt.x,pt.y))
    points = outline_points(img, points)
    # points = addition_points(points)  # 仅手动标注时使用
    # draw_points(img, points)  # 绘制点图
    return points


# part2: 三角信息提取
# 解决insert报错
def check_before_insert(rect, p):
    if (p[0]>=rect[0]) and (p[0]<=rect[2]) and (p[1]>=rect[1]) and (p[1]<=rect[3]):
        return True
    return False

# 获取Delaunay Triangulation的顶点信息
def get_tri(img, points):
    size = img.shape
    rect = (0,0,size[1],size[0])
    subdiv = cv2.Subdiv2D(rect)

    for p in points:
        if check_before_insert(rect, p):
            subdiv.insert(p)

    trangle_list = subdiv.getTriangleList()
    point_list = []
    index_list = []
    for trangle in trangle_list:
        p1 = (int(trangle[0]), int(trangle[1]))
        p2 = (int(trangle[2]), int(trangle[3]))
        p3 = (int(trangle[4]), int(trangle[5]))
        point_list.append((p1, p2, p3))
        index_list.append((points.index(p1),points.index(p2),points.index(p3)))
    # (facets,centers) = subdiv.getVoronoiFacetList([])
    return index_list


# part3: 仿射融合
def applyAffineTransform(src,srcTri,dstTri,size):
    #Given a pair of triangles,find the affine transform.
    warpMat = cv2.getAffineTransform(np.float32(srcTri),np.float32(dstTri))
    #Apply the Affine Transform just foundto the src image
    dst = cv2.warpAffine(src,warpMat,(size[0],size[1]),None,flags=cv2.INTER_LINEAR,borderMode=cv2.BORDER_REFLECT_101)
    return dst

def morphTriangle(img1,img2,img,t1,t2,t,alpha):
    #Find bounding rectangle for each triangle
    r1 = cv2.boundingRect(np.float32([t1]))
    r2 = cv2.boundingRect(np.float32([t2]))
    r = cv2.boundingRect(np.float32([t]))
    # Offset points by left top corner of the respective rectangles
    t1Rect = []
    t2Rect = []
    tRect = []
    for i in range(0,3):
        tRect.append(((t[i][0] - r[0]),(t[i][1]-r[1])))
        t1Rect.append(((t1[i][0]-r1[0]),(t1[i][1]-r1[1])))
        t2Rect.append(((t2[i][0] -r2[0]),(t2[i][1]-r2[1])))

    # Get mask by filling triangles
    mask = np.zeros((r[3],r[2],3),dtype = np.float32)
    cv2.fillConvexPoly(mask,np.int32(tRect),(1.0,1.0,1.0),16,0)

    # Apply warpImage to small rectangular patched
    img1Rect = img1[r1[1]:r1[1]+r1[3],r1[0]:r1[0]+r1[2]]
    img2Rect = img2[r2[1]:r2[1]+r2[3],r2[0]:r2[0]+r2[2]]

    size = (r[2],r[3])
    warpImage1 = applyAffineTransform(img1Rect,t1Rect,tRect,size)
    warpImage2 = applyAffineTransform(img2Rect,t2Rect,tRect,size)

    # Alpha blend rectangular patches
    imgRect = (1.0-alpha) *warpImage1 +alpha*warpImage2

    # Copy triangular region of rectangular patch to tje output image
    # print(r[1],r[3],r[0],r[2])
    # print(imgRect.shape)
    img[r[1]:r[1]+r[3],r[0]:r[0]+r[2]] = img[r[1]:r[1]+r[3],r[0]:r[0]+r[2]]*(1-mask) +imgRect*mask

def morph_alpha(num, points1, points2, img1, img2, img):
    points = []
    alpha = num/100
    for i in range(0, len(points1)):
        x = ( 1 - alpha ) * points1[i][0] + alpha * points2[i][0]
        y = ( 1 - alpha ) * points1[i][1] + alpha * points2[i][1]
        points.append((x,y))

    index_list = get_tri(img1, points1)
    for index in index_list:
        trangle_1 = [points1[index[0]], points1[index[1]], points1[index[2]]]
        trangle_2 = [points2[index[0]], points2[index[1]], points2[index[2]]]
        trangle = [points[index[0]], points[index[1]], points[index[2]]]
        # Morph one triangle at a time.
        morphTriangle(img1, img2, img, trangle_1, trangle_2, trangle, alpha)
    cv2.imwrite(PATH+ 'test/{:0>2d}.jpg'.format(num),img)
    	

# part4: img2mp4
#定义图片转视频函数
def img2mp4(img_path,out_name):
    img = cv2.imread(img_path+'/00.jpg')  #读取第一张图片
    fps = 25
    imgInfo = img.shape
    size = (imgInfo[1],imgInfo[0])  #获取图片宽高度信息
    fourcc = cv2.VideoWriter_fourcc(*"XVID") #视频写入编码器
    videoWrite = cv2.VideoWriter(out_name,fourcc,fps,size)
    # 根据图片的大小，创建写入对象(文件名，支持的编码器，帧频，视频大小(图片大小))

    files = os.listdir(img_path) #获取文件夹下图片
    out_num = len(files) #图片个数
    for i,name in enumerate(files):
        fileName = img_path + '\\' + name #读取所有图片的路径
        img = cv2.imread(fileName)  #写入图片
        videoWrite.write(img) #将图片写入所创建的视频对象
    videoWrite.release() #释放内存


if __name__ == '__main__':
    img1 = cv2.imread(IMG_PATH_1)
    points1 = get_points(img1)
    img2 = cv2.imread(IMG_PATH_2)
    points2 = get_points(img2)
    img = np.zeros(img1.shape, dtype = img1.dtype)

    for i in range(100):
        morph_alpha(i, points1, points2, img1, img2, img)
    img_video_path = PATH + 'test'
    out_name = PATH + 'test.mp4'
    img2mp4(img_video_path,out_name)
    # 仅叠加
    # test_img = (0.5*img1 + 0.5*img2)
    # cv2.imwrite('C:/Users/admin/Desktop/test.jpg', test_img)