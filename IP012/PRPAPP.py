# 导入各种库
import numpy as np
import random		                                    # 包含了常见的随机生成函数
import pandas as pd
import scipy
import math
import pylab as pl
import tkinter as tk                                    # UI界面
from sklearn.model_selection import train_test_split    # 用于划分数据集
from sklearn.mixture import GaussianMixture             # GMM
from sklearn.preprocessing import StandardScaler        # 用于标准化
from sklearn.neighbors import KNeighborsClassifier      # knn
from sklearn import svm                                 # svm
from sklearn.naive_bayes import GaussianNB              # 贝叶斯
from sklearn import tree                                # 决策树
import io  
from PIL import Image, ImageTk  
import tkinter as tk
import time

class PRPAPP:
    def __init__ (self,inter):
        self.interface=inter
    def getData(self,n):
        #load
        if n==1:
            firstrecord =   np.loadtxt("record1_psignal.txt")
            annotation  =   np.loadtxt("annotation1_sample.txt")
            secondrecord=   np.loadtxt("record2_1_psignal.txt")
        elif n==2:
            firstrecord =   np.loadtxt("record2_psignal.txt")
            annotation  =   np.loadtxt("annotation2_sample.txt")
            secondrecord=   np.loadtxt("record2_2_psignal.txt")
        elif n==3:
            firstrecord =   np.loadtxt("record3_psignal.txt")
            annotation  =   np.loadtxt("annotation3_sample.txt")
            secondrecord=   np.loadtxt("record2_3_psignal.txt")
        elif n==4:
            firstrecord =   np.loadtxt("record4_psignal.txt")
            annotation  =   np.loadtxt("annotation4_sample.txt")
            secondrecord=   np.loadtxt("record2_4_psignal.txt")
        elif n==5:
            firstrecord =   np.loadtxt("record5_psignal.txt")
            annotation  =   np.loadtxt("annotation5_sample.txt")
            secondrecord=   np.loadtxt("record2_5_psignal.txt")
        elif n==6:
            firstrecord =   np.loadtxt("record6_psignal.txt")
            annotation  =   np.loadtxt("annotation6_sample.txt")
            secondrecord=   np.loadtxt("record2_6_psignal.txt")
        elif n==7:
            firstrecord =   np.loadtxt("record7_psignal.txt")
            annotation  =   np.loadtxt("annotation7_sample.txt")
            secondrecord=   np.loadtxt("record2_7_psignal.txt")
        elif n==8:
            firstrecord =   np.loadtxt("record8_psignal.txt")
            annotation  =   np.loadtxt("annotation8_sample.txt")
            secondrecord=   np.loadtxt("record2_8_psignal.txt")
        elif n==9:
            firstrecord =   np.loadtxt("record9_psignal.txt")
            annotation  =   np.loadtxt("annotation9_sample.txt")
            secondrecord=   np.loadtxt("record2_9_psignal.txt")
        elif n==10:
            firstrecord =   np.loadtxt("record10_psignal.txt")
            annotation  =   np.loadtxt("annotation10_sample.txt")
            secondrecord=   np.loadtxt("record2_10_psignal.txt")
        elif n==11:
            firstrecord =   np.loadtxt("record11_psignal.txt")
            annotation  =   np.loadtxt("annotation11_sample.txt")
            secondrecord=   np.loadtxt("record2_11_psignal.txt")
        elif n==12:
            firstrecord =   np.loadtxt("record12_psignal.txt")
            annotation  =   np.loadtxt("annotation12_sample.txt")
            secondrecord=   np.loadtxt("record2_12_psignal.txt")
        elif n==13:
            firstrecord =   np.loadtxt("record13_psignal.txt")
            annotation  =   np.loadtxt("annotation13_sample.txt")
            secondrecord=   np.loadtxt("record2_13_psignal.txt")
        elif n==14:
            firstrecord =   np.loadtxt("record14_psignal.txt")
            annotation  =   np.loadtxt("annotation14_sample.txt")
            secondrecord=   np.loadtxt("record2_14_psignal.txt")
        elif n==15:
            firstrecord =   np.loadtxt("record15_psignal.txt")
            annotation  =   np.loadtxt("annotation15_sample.txt")
            secondrecord=   np.loadtxt("record2_15_psignal.txt")
        elif n==16:
            firstrecord =   np.loadtxt("record16_psignal.txt")
            annotation  =   np.loadtxt("annotation16_sample.txt")
            secondrecord=   np.loadtxt("record2_16_psignal.txt")
        elif n==17:
            firstrecord =   np.loadtxt("record17_psignal.txt")
            annotation  =   np.loadtxt("annotation17_sample.txt")
            secondrecord=   np.loadtxt("record2_17_psignal.txt")
        elif n==18:
            firstrecord =   np.loadtxt("record18_psignal.txt")
            annotation  =   np.loadtxt("annotation18_sample.txt")
            secondrecord=   np.loadtxt("record2_18_psignal.txt")
        elif n==19:
            firstrecord =   np.loadtxt("record19_psignal.txt")
            annotation  =   np.loadtxt("annotation19_sample.txt")
            secondrecord=   np.loadtxt("record2_19_psignal.txt")
        elif n==20:
            firstrecord =   np.loadtxt("record20_psignal.txt")
            annotation  =   np.loadtxt("annotation20_sample.txt")
            secondrecord=   np.loadtxt("record2_20_psignal.txt")
        #调整数据结构
        class subject:
                def __init__(self):
                    self.ax=[]
                    self.ay=[]
                    self.az=[]
                    self.temp=[]
                    self.eda=[]
                    self.spo2=[]
                    self.hr=[]
        allsubject=subject()
        allsubject.ax   =   firstrecord[:,0]
        allsubject.ay   =   firstrecord[:,1]
        allsubject.az   =   firstrecord[:,2]
        allsubject.temp =   firstrecord[:,3]
        allsubject.eda  =   firstrecord[:,4]
        allsubject.spo2 =   secondrecord[:,0]
        allsubject.hr   =   secondrecord[:,1]

        class relax_subject:
                def __init__(self):
                    self.ax=[]
                    self.ay=[]
                    self.az=[]
                    self.temp=[]
                    self.eda=[]
                    self.spo2=[]
                    self.hr=[]
        allrelax_subject=relax_subject()
        class physical_subject:
                def __init__(self):
                    self.ax=[]
                    self.ay=[]
                    self.az=[]
                    self.temp=[]
                    self.eda=[]
                    self.spo2=[]
                    self.hr=[]
        allphysical_subject=physical_subject()
        class emotional_subject:
                def __init__(self):
                    self.ax=[]
                    self.ay=[]
                    self.az=[]
                    self.temp=[]
                    self.eda=[]
                    self.spo2=[]
                    self.hr=[]
        allemotional_subject=emotional_subject()
        class cognitive_subject:
                def __init__(self):
                    self.ax=[]
                    self.ay=[]
                    self.az=[]
                    self.temp=[]
                    self.eda=[]
                    self.spo2=[]
                    self.hr=[]
        allcognitive_subject=cognitive_subject()

        allrelax_subject.ax =   allsubject.ax[range(int(annotation[0])-1,int(annotation[1])-1)]
        allrelax_subject.ay =   allsubject.ay[range(int(annotation[0])-1,int(annotation[1])-1)]
        allrelax_subject.az =   allsubject.az[range(int(annotation[0])-1,int(annotation[1])-1)]
        allrelax_subject.temp=  allsubject.temp[range(int(annotation[0])-1,int(annotation[1])-1)]
        allrelax_subject.eda=   allsubject.eda[range(int(annotation[0])-1,int(annotation[1])-1)]
        allrelax_subject.spo2=  allsubject.spo2[range(int((int(annotation[0])-1)/8),int((int(annotation[1])-1)/8))]
        allrelax_subject.hr =   allsubject.hr[range(int((int(annotation[0])-1)/8),int((int(annotation[1])-1)/8))]

        allrelax_subject.spo2=  pd.Series(allrelax_subject.spo2)
        allrelax_subject.hr=    pd.Series(allrelax_subject.hr)

        allphysical_subject.ax  =   allsubject.ax[range(int(annotation[1])-1,int(annotation[2])-1)]
        allphysical_subject.ay  =   allsubject.ay[range(int(annotation[1])-1,int(annotation[2])-1)]
        allphysical_subject.az  =   allsubject.az[range(int(annotation[1])-1,int(annotation[2])-1)]
        allphysical_subject.temp=   allsubject.temp[range(int(annotation[1])-1,int(annotation[2])-1)]
        allphysical_subject.eda=    allsubject.eda[range(int(annotation[1])-1,int(annotation[2])-1)]
        allphysical_subject.spo2=   allsubject.spo2[range(int((int(annotation[1])-1)/8),int((int(annotation[2])-1)/8))]
        allphysical_subject.hr  =   allsubject.hr[range(int((int(annotation[1])-1)/8),int((int(annotation[2])-1)/8))]

        allphysical_subject.spo2=   pd.Series(allphysical_subject.spo2)
        allphysical_subject.hr  =   pd.Series(allphysical_subject.hr)

        allcognitive_subject.ax   =   allsubject.ax[range(int(annotation[4])-1,int(annotation[5])-1)]
        allcognitive_subject.ay  =   allsubject.ay[range(int(annotation[4])-1,int(annotation[5])-1)]
        allcognitive_subject.az  =   allsubject.az[range(int(annotation[4])-1,int(annotation[5])-1)]
        allcognitive_subject.temp=   allsubject.temp[range(int(annotation[4])-1,int(annotation[5])-1)]
        allcognitive_subject.eda=    allsubject.eda[range(int(annotation[4])-1,int(annotation[5])-1)]
        allcognitive_subject.spo2=   allsubject.spo2[range(int((int(annotation[4])-1)/8),int((int(annotation[5])-1)/8))]
        allcognitive_subject.hr  =   allsubject.hr[range(int((int(annotation[4])-1)/8),int((int(annotation[5])-1)/8))]

        allcognitive_subject.spo2=  pd.Series(allcognitive_subject.spo2)
        allcognitive_subject.hr =   pd.Series(allcognitive_subject.hr)

        allemotional_subject.ax  =   allsubject.ax[range(int(annotation[6])-1,int(annotation[7])-1)]
        allemotional_subject.ay  =   allsubject.ay[range(int(annotation[6])-1,int(annotation[7])-1)]
        allemotional_subject.az  =   allsubject.az[range(int(annotation[6])-1,int(annotation[7])-1)]
        allemotional_subject.temp=   allsubject.temp[range(int(annotation[6])-1,int(annotation[7])-1)]
        allemotional_subject.eda=    allsubject.eda[range(int(annotation[6])-1,int(annotation[7])-1)]
        allemotional_subject.spo2=   allsubject.spo2[range(int((int(annotation[6])-1)/8),int((int(annotation[7])-1)/8))]
        allemotional_subject.hr  =   allsubject.hr[range(int((int(annotation[6])-1)/8),int((int(annotation[7])-1)/8))]

        allemotional_subject.spo2=  pd.Series(allemotional_subject.spo2)
        allemotional_subject.hr =   pd.Series(allemotional_subject.hr)

        #downsample
        relax_rng=[None]
        physical_rng=[None]
        cognitive_rng=[None]
        emotional_rng=[None]
        relax_rng   =   pd.date_range(start='2020-1-1',periods=len(allrelax_subject.ax),freq="0.125S")
        physical_rng=   pd.date_range(start='2020-1-1',periods=len(allphysical_subject.ax),freq="0.125S")
        cognitive_rng=  pd.date_range(start='2020-1-1',periods=len(allcognitive_subject.ax),freq="0.125S")
        emotional_rng=  pd.date_range(start='2020-1-1',periods=len(allemotional_subject.ax),freq="0.125S")
        allrelax_subject.ax=    pd.Series(allrelax_subject.ax,index=relax_rng)
        allrelax_subject.ay=    pd.Series(allrelax_subject.ay,index=relax_rng)
        allrelax_subject.az=    pd.Series(allrelax_subject.az,index=relax_rng)
        allrelax_subject.temp=  pd.Series(allrelax_subject.temp,index=relax_rng)
        allrelax_subject.eda=   pd.Series(allrelax_subject.eda,index=relax_rng)
        allphysical_subject.ax  = pd.Series(allphysical_subject.ax,index=physical_rng)
        allphysical_subject.ay  = pd.Series(allphysical_subject.ay,index=physical_rng)
        allphysical_subject.az  = pd.Series(allphysical_subject.az,index=physical_rng)
        allphysical_subject.temp=   pd.Series(allphysical_subject.temp,index=physical_rng)
        allphysical_subject.eda=    pd.Series(allphysical_subject.eda,index=physical_rng)
        allcognitive_subject.ax =   pd.Series(allcognitive_subject.ax,index=cognitive_rng)

        allcognitive_subject.ax =   pd.Series(allcognitive_subject.ax,index=cognitive_rng)
        allcognitive_subject.ay =   pd.Series(allcognitive_subject.ay,index=cognitive_rng)
        allcognitive_subject.az =   pd.Series(allcognitive_subject.az,index=cognitive_rng)
        allcognitive_subject.temp=  pd.Series(allcognitive_subject.temp,index=cognitive_rng)
        allcognitive_subject.eda=   pd.Series(allcognitive_subject.eda,index=cognitive_rng)
            
        allemotional_subject.ax =   pd.Series(allemotional_subject.ax,index=emotional_rng)
        allemotional_subject.ay =   pd.Series(allemotional_subject.ay,index=emotional_rng)
        allemotional_subject.az =   pd.Series(allemotional_subject.az,index=emotional_rng)
        allemotional_subject.temp=  pd.Series(allemotional_subject.temp,index=emotional_rng)
        allemotional_subject.eda=   pd.Series(allemotional_subject.eda,index=emotional_rng)

        allrelax_subject.ax =   allrelax_subject.ax.resample('1S').mean()
        allrelax_subject.ay =   allrelax_subject.ay.resample('1S').mean()
        allrelax_subject.az =   allrelax_subject.az.resample('1S').mean()
        allrelax_subject.temp=  allrelax_subject.temp.resample('1S').mean()
        allrelax_subject.eda=   allrelax_subject.eda.resample('1S').mean()
        allphysical_subject.ax  =   allphysical_subject.ax.resample('1S').mean()
        allphysical_subject.ay  =   allphysical_subject.ay.resample('1S').mean()
        allphysical_subject.az  =   allphysical_subject.az.resample('1S').mean()
        allphysical_subject.temp=   allphysical_subject.temp.resample('1S').mean()
        allphysical_subject.eda=    allphysical_subject.eda.resample('1S').mean()
        allcognitive_subject.ax =   allcognitive_subject.ax.resample('1S').mean()
        allcognitive_subject.ay =   allcognitive_subject.ay.resample('1S').mean()
        allcognitive_subject.az =   allcognitive_subject.az.resample('1S').mean()
        allcognitive_subject.temp=  allcognitive_subject.temp.resample('1S').mean()
        allcognitive_subject.eda=   allcognitive_subject.eda.resample('1S').mean()
        allemotional_subject.ax =   allemotional_subject.ax.resample('1S').mean()
        allemotional_subject.ay =   allemotional_subject.ay.resample('1S').mean()
        allemotional_subject.az =   allemotional_subject.az.resample('1S').mean()
        allemotional_subject.temp=  allemotional_subject.temp.resample('1S').mean()
        allemotional_subject.eda=   allemotional_subject.eda.resample('1S').mean()

        #data cleaning（盖帽法）
        def cap(x,quantile=[0.01,0.99]):
            Q01,Q99=x.quantile(quantile).values.tolist()
            if Q01 > x.min():
                x=x.copy()
                x.loc[x<Q01] = Q01
            if Q99 < x.max():
                x = x.copy()
                x.loc[x>Q99] = Q99
            return x

        allrelax_subject.ax =   cap(allrelax_subject.ax)
        allrelax_subject.ay =   cap(allrelax_subject.ay)
        allrelax_subject.az =   cap(allrelax_subject.az)
        allrelax_subject.eda=   cap(allrelax_subject.eda)
        allrelax_subject.temp=  cap(allrelax_subject.temp)
        allrelax_subject.spo2=  cap(allrelax_subject.spo2)
        allrelax_subject.hr =   cap(allrelax_subject.hr)
        allphysical_subject.ax  =   cap(allphysical_subject.ax)
        allphysical_subject.ay  =   cap(allphysical_subject.ay)
        allphysical_subject.az  =   cap(allphysical_subject.az)
        allphysical_subject.eda =   cap(allphysical_subject.eda)
        allphysical_subject.temp=   cap(allphysical_subject.temp)
        allphysical_subject.spo2=   cap(allphysical_subject.spo2)
        allphysical_subject.hr  =   cap(allphysical_subject.hr)
        allcognitive_subject.ax =   cap(allcognitive_subject.ax)
        allcognitive_subject.ay =   cap(allcognitive_subject.ay)
        allcognitive_subject.az =   cap(allcognitive_subject.az)
        allcognitive_subject.eda=   cap(allcognitive_subject.eda)
        allcognitive_subject.temp=  cap(allcognitive_subject.temp)
        allcognitive_subject.spo2=  cap(allcognitive_subject.spo2)
        allcognitive_subject.hr =   cap(allcognitive_subject.hr)
        allemotional_subject.ax =   cap(allemotional_subject.ax)
        allemotional_subject.ay =   cap(allemotional_subject.ay)
        allemotional_subject.az =   cap(allemotional_subject.az)
        allemotional_subject.eda=   cap(allemotional_subject.eda)
        allemotional_subject.temp=  cap(allemotional_subject.temp)
        allemotional_subject.spo2=  cap(allemotional_subject.spo2)
        allemotional_subject.hr =   cap(allemotional_subject.hr)

        allphysical_subject.temp=   np.delete(allphysical_subject.temp.values,0,axis=0)
        allphysical_subject.ax  =   np.delete(allphysical_subject.ax.values,0,axis=0)
        allphysical_subject.ay  =   np.delete(allphysical_subject.ay.values,0,axis=0)
        allphysical_subject.az  =   np.delete(allphysical_subject.az.values,0,axis=0)
        allphysical_subject.eda =   np.delete(allphysical_subject.eda.values,0,axis=0)

        allemotional_subject.temp=   np.delete(allemotional_subject.temp.values,0,axis=0)
        allemotional_subject.ax  =   np.delete(allemotional_subject.ax.values,0,axis=0)
        allemotional_subject.ay  =   np.delete(allemotional_subject.ay.values,0,axis=0)
        allemotional_subject.az  =   np.delete(allemotional_subject.az.values,0,axis=0)
        allemotional_subject.eda =   np.delete(allemotional_subject.eda.values,0,axis=0)

        allcognitive_subject.temp=   np.delete(allcognitive_subject.temp.values,0,axis=0)
        allcognitive_subject.ax  =   np.delete(allcognitive_subject.ax.values,0,axis=0)
        allcognitive_subject.ay  =   np.delete(allcognitive_subject.ay.values,0,axis=0)
        allcognitive_subject.az  =   np.delete(allcognitive_subject.az.values,0,axis=0)
        allcognitive_subject.eda =   np.delete(allcognitive_subject.eda.values,0,axis=0)



        #将处理好的数据合到一起
        alldata_c=[None]
        tmp=[None]*7
        tmp[0]  =   np.r_[allrelax_subject.temp,allphysical_subject.temp,allcognitive_subject.temp,allemotional_subject.temp]
        tmp[1]  =   np.r_[allrelax_subject.hr,allphysical_subject.hr,allcognitive_subject.hr,allemotional_subject.hr]
        tmp[2]  =   np.r_[allrelax_subject.spo2,allphysical_subject.spo2,allcognitive_subject.spo2,allemotional_subject.spo2]
        tmp[3]  =   np.r_[allrelax_subject.ax,allphysical_subject.ax,allcognitive_subject.ax,allemotional_subject.ax]
        tmp[4]  =   np.r_[allrelax_subject.ay,allphysical_subject.ay,allcognitive_subject.ay,allemotional_subject.ay]
        tmp[5]  =   np.r_[allrelax_subject.az,allphysical_subject.az,allcognitive_subject.az,allemotional_subject.az]
        tmp[6]  =   np.r_[allrelax_subject.eda,allphysical_subject.eda,allcognitive_subject.eda,allemotional_subject.eda]
        alldata_c=  np.c_[tmp[0],tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6]]
        #标签
        Y_all=[None]
        Y_all=np.zeros((len(alldata_c), 1), dtype=np.int32)
        l1=len(allrelax_subject.hr)
        l2=l1+len(allphysical_subject.hr)
        l3=l2+len(allcognitive_subject.hr)
        l4=l3+len(allemotional_subject.hr)
        for j in range(l1,l2):
            Y_all[j]=1
        for j in range(l2,l3):
            Y_all[j]=2
        for j in range(l3,l4):
            Y_all[j]=3

        return alldata_c,Y_all

    #背景图缩放
    def resize(self,w, h, w_box, h_box, pil_image):
        f1 = 1.0*w_box/w  
        f2 = 1.0*h_box/h  
        factor = min([f1, f2])  
        width = int(w*factor)  
        height = int(h*factor)  
        return pil_image.resize((width, height), Image.ANTIALIAS) 

    def run(self):
        # 建立字典，记录类型
        State = {0: 'Relax',1: 'PhysicalStress',2:'CognitiveStress',3:'EmotionalStress'}

        while True:
            gFlag,number=self.interface.getInfo()   #控制程序中断和获取指针信息

            if gFlag:
                break
            self.win    =   tk.Toplevel()
            #获取所选受试者的数据
            if number == 'NO.1':
                alldata,Y_all=self.getData(1)
                self.win.title("NO.1")
            elif number == 'NO.2':
                alldata,Y_all=self.getData(2)
                self.win.title("NO.2")
            elif number == 'NO.3':
                alldata,Y_all=self.getData(3)
                self.win.title("NO.3")
            elif number == 'NO.4':
                alldata,Y_all=self.getData(4)
                self.win.title("NO.4")
            elif number == 'NO.5':
                alldata,Y_all=self.getData(5)
                self.win.title("NO.5")
            elif number == 'NO.6':
                alldata,Y_all=self.getData(6)
                self.win.title("NO.6")
            elif number == 'NO.7':
                alldata,Y_all=self.getData(7)
                self.win.title("NO.7")
            elif number == 'NO.8':
                alldata,Y_all=self.getData(8)
                self.win.title("NO.8")
            elif number == 'NO.9':
                alldata,Y_all=self.getData(9)
                self.win.title("NO.9")
            elif number == 'NO.10':
                alldata,Y_all=self.getData(10)
                self.win.title("NO.10")
            elif number == 'NO.11':
                alldata,Y_all=self.getData(11)
                self.win.title("NO.11")
            elif number == 'NO.12':
                alldata,Y_all=self.getData(12)
                self.win.title("NO.12")
            elif number == 'NO.13':
                alldata,Y_all=self.getData(13)
                self.win.title("NO.13")
            elif number == 'NO.14':
                alldata,Y_all=self.getData(14)
                self.win.title("NO.14")
            elif number == 'NO.15':
                alldata,Y_all=self.getData(15)
                self.win.title("NO.15")
            elif number == 'NO.16':
                alldata,Y_all=self.getData(16)
                self.win.title("NO.16")
            elif number == 'NO.17':
                alldata,Y_all=self.getData(17)
                self.win.title("NO.17")
            elif number == 'NO.18':
                alldata,Y_all=self.getData(18)
                self.win.title("NO.18")
            elif number == 'NO.19':
                alldata,Y_all=self.getData(19)
                self.win.title("NO.19")
            else :
                alldata,Y_all=self.getData(20)
                self.win.title("NO.20")
            self.cv = tk.Canvas(self.win, width=800, height=450, bg="white")   #创建画布
            global tk_image
            #期望图像显示的大小  
            w_box = 800  
            h_box = 450  
            #以一个PIL图像对象打开  
            pil_image = Image.open(r'2.jpg')  
            #获取图像的原始大小  
            w, h = pil_image.size  
            #缩放图像让它保持比例，同时限制在一个矩形框范围内  
            pil_image_resized = self.resize(w, h, w_box, h_box, pil_image)
            # 把PIL图像对象转变为Tkinter的PhotoImage对象  
            tk_image = ImageTk.PhotoImage(pil_image_resized)  
            loading=self.cv.create_image(400,225,image = tk_image)
            self.cv.pack()
            self.cv.update()
            self.cv.delete(loading)
            pil_image = Image.open(r'1.jpg')  
            #获取图像的原始大小  
            w, h = pil_image.size  
            #缩放图像让它保持比例，同时限制在一个矩形框范围内  
            pil_image_resized = self.resize(w, h, w_box, h_box, pil_image)
            # 把PIL图像对象转变为Tkinter的PhotoImage对象  
            tk_image = ImageTk.PhotoImage(pil_image_resized) 
            self.cv.create_image(400,225,image = tk_image) 
            
            #划分
            x_train, x_test, y_train, y_test = train_test_split(alldata, Y_all, test_size=0.2, random_state=666)

            #fit
            accuracy=[0]*5
            #归一化
            standarscaler = StandardScaler()
            standarscaler.fit(x_train)
            standarscaler.mean_
            standarscaler.scale_
            x_train = standarscaler.transform(x_train)

            #supervised clf
            #KNN
            knn_clf = KNeighborsClassifier()
            knn_clf.fit(x_train, y_train)
            accuracy[1]=knn_clf.score(x_train,y_train)
            #SVM
            svm_clf = svm.SVC(C=1.0, kernel='rbf', decision_function_shape='ovr', gamma=0.01)
            svm_clf.fit(x_train, y_train)
            accuracy[2]=svm_clf.score(x_train,y_train)
            #BAYES
            gnb_clf = GaussianNB()
            gnb_clf.fit(x_train, y_train)
            accuracy[3]=gnb_clf.score(x_train,y_train)
            #决策树
            tree_clf = tree.DecisionTreeClassifier()
            tree_clf = tree_clf.fit(x_train, y_train)
            accuracy[4]=tree_clf.score(x_train,y_train)

            #unsupervised clf
            gmm=GaussianMixture(n_components=4,covariance_type='full', random_state=0)
            gmm.fit(x_train)

            #记录各个类别的对应关系,计算准确率
            # x=np.arange(0,len(data),1)
            # plt.subplot(211)
            y_hat2=gmm.predict(x_train)
            num=0
            ann=[0]*3

            for i in range (0,4):
                a=y_train[y_hat2==i]
                if (a.mean()<0.5):
                    ann[0]=i
                    for j in (0,len(a)):
                        if y_train[j]!=0:
                            num=num+1
                elif a.mean()<1.5:
                    ann[1]=i
                    for j in (0,len(a)):
                        if y_train[j]!=1:
                            num=num+1
                elif a.mean()<2.5:
                    ann[2]=i
                    for j in (0,len(a)):
                        if y_train[j]!=2:
                            num=num+1
                else :
                    for j in (0,len(a)):
                        if y_train[j]!=3:
                            num=num+1
            accuracy[0]=1-num/len(x_train)



            #NN
            random.seed(0)		# 只要我们设置相同的seed,就能确保每次生成的随机数相同。如果不设置seed，则每次会生成不同的随机数
            
            #生成区间[a, b)内的随机数
            def rand(a, b):		
                return (b - a) * random.random() + a		# random.random() 生成0—1之间的随机数
            
            # 生成大小 I*J 的矩阵，默认零矩阵
            def makeMatrix(I, J, fill=0.0):    # fill = 0.0为默认值参数，调用函数可修改默认值
                m = []		# 创建一个空列表
                for i in range(I):		# range()函数产生一个整数列表，以完成计数循环
                    m.append([fill] * J)		# m.append列表尾部追加成员; [0.0]是一个列表，列表支持乘法运算，[0.0]*5 的结果是[0.0 0.0 0.0 0.0 0.0 0.0]。
                return m	 # 在列表尾部追加成员也是列表，所以返回的是个矩阵
            
            
            # 函数 sigmoid，bp神经网络前向传播的激活函数
            def sigmoid(x):
                return 1.0 / (1.0 + math.exp(-x))       
            
            
            # 函数 sigmoid 的导数，反向传播时使用
            def dsigmoid(x):
                return x * (1 - x)
            
            """ 三层反向传播神经网络 """
            class NN:
            
                """创建神经网络结构。 定义构造方法，初始化输入层、隐藏层、输出层的节点（数）"""
                def __init__(self, ni, nh, no):
                    self.ni = ni + 1  	# 输入层增加一个偏置节点；定义一个实例属性self.ni记录输入节点个数
                    self.nh = nh + 1		# 隐藏层增加一个偏置节点
                    self.no = no			# 输出层个数即种类数
            
                    self.ai = [1.0] * self.ni		#  输入层神经元的激活项其实就是输入的特征数，这样设计是为了向量化前向传播过程。
                    self.ah = [1.0] * self.nh		# [1.0]是一个列表，列表支持乘法运算，[1.0]*5 的结果是[1.0 1.0 1.0 1.0 1.0 1.0]。偏置节点必定为1，也就是列表中第一个数为1，其他数依次记录隐藏层节点的激活项
                    self.ao = [1.0] * self.no		# 输出层输出的结果为，预测该样本属于某一类的概率，概率最大者，则预测为该类
            
                    # 建立权重（矩阵）
                    self.wi = makeMatrix(self.ni, self.nh)		# 定义一个实例属性self.wi记录输出层到隐藏层的映射矩阵
                    self.wo = makeMatrix(self.nh, self.no)		# python中类中可以直接调用全局函数makeMatrix()生成矩阵，默认零矩阵；隐藏层到输出层的映射矩阵。
            
                    # 设为随机值。在做线性回归和逻辑回归时，一般将权重都初始化为0；但在神经网络中需要设为随机值，是因为如果权重矩阵为零矩阵的话，那么经过前向传播下一层神经元的激活项均相同
                    for i in range(self.ni):	# 上层循环控制行
                        for j in range(self.nh):		# 下层循环控制列
                            self.wi[i][j] = rand(-0.2, 0.2)		# 调用全局函数rand(),生成区间[-0.2, 0.2)内的随机数
            
                    for j in range(self.nh):
                        for k in range(self.no):
                            self.wo[j][k] = rand(-2, 2)		 # 生成区间[-2, 2)内的随机数
            
            
                    
                """前向传播，激活神经网络的所有节点（向量）"""
                def update(self, inputs):
                    if len(inputs) != self.ni - 1:		# 输入的样本特征量数等于神经网络输入层数-1，因为有一个是偏置节点
                        raise ValueError('与输入层节点数不符！')		# 使用raise手工抛出异常，若引发该异常，中断程序
            
                    # 激活输入层
                    for i in range(self.ni - 1):		# 输入层中的偏置节点 = 1，不用激活
                        self.ai[i] = inputs[i]		# 将输入样本的特征量赋值给神经网络输入层的其他节点
            
                    # 激活隐藏层
                    for j in range(self.nh):	# self.nh表示隐藏层的节点数，包括隐藏层的第一个节点，也就是我们人为加的偏置节点，偏置节点恒为1，是不需要激活的；应该是self.nh -1,但原代码也并不影响结果
                        sum = 0.0		# 激活项a = g(z)  z = Θ^T x ;sum相当于z，每次循环归零
                        for i in range(self.ni):	#通过循环z = Θ^T x ，因为Θ、x均为向量
                            sum = sum + self.ai[i] * self.wi[i][j]		#〖 Z〗^((2))=Θ^((1)) a^((1))
                        self.ah[j] = sigmoid(sum)		# a^((2))=g(z^((2)))，这里使用sigmoid()函数作为激活函数
            
                    # 激活输出层
                    for k in range(self.no):
                        sum = 0.0
                        for j in range(self.nh):
                            sum = sum + self.ah[j] * self.wo[j][k]		#〖 Z〗^((3))=Θ^((2)) a^((2))
                        self.ao[k] = sigmoid(sum)		# a^((3))=g(z^((3)))
            
                    return self.ao[:]			# 返回输出值，即为某样本的预测值
            


                """反向传播，激活神经网络的所有节点（向量）"""
                def backPropagate(self, targets, lr):		# targets为某样本实际种类分类，lr为梯度下降算法的学习率
                    
                    # 计算输出层的误差
                    output_deltas = [0.0] * self.no		#记录方向传播的误差；输出层误差容易求，把样本的实际值减去我们当前神经网络预测的值，δ^((3))=〖y-a〗^((3) );但是输出层的误差是由前面层一层一层累加的结果，我们将误差方向传播的过程叫方向传播算法。由算法知：δ^((2))=〖(Θ^((2)))〗^T δ^((3)).*g^' (z^((2)))
                    for k in range(self.no):
                        error = targets[k] - self.ao[k]	#δ^((3))=〖y-a〗^((3) ),得到输出层的误差
                        output_deltas[k] = dsigmoid(self.ao[k]) * error      # dsigmoid()函数的功能是求公式中 g^' (z^((2))) 项，而output_deltas记录的是δ^((3)).*g^' (z^((2)))的值
            
                    # 计算隐藏层的误差
                    hidden_deltas = [0.0] * self.nh		#记录的是δ^((2)).*g^' (z^((1)))的值
            
                    for j in range(self.nh):
                        error = 0.0
                        for k in range(self.no):
                            error = error + output_deltas[k] * self.wo[j][k]		#求δ^((2))，隐藏层的误差
                        hidden_deltas[j] = dsigmoid(self.ah[j]) * error
            
                    # 更新输出层权重
                    for j in range(self.nh):		# 反向传播算法，求出每个节点的误差后，反向更新权重；由算法知Δ(_ij ^((L)))=Δ(_ij ^((L)))+a(_j  ^((L)))δ(_i      ^((L+1)))    ,而∂/(∂Θ_ij^((L) ) ) J(Θ)=Δ_ij^((L))   (λ=0) λ为正则化系数。代入梯度下降算法中：Θ_ij^((L))=Θ_ij^((L))+α  ∂/(∂Θ_ij^((L) ) ) J(Θ)即可更新权重
                        for k in range(self.no):
                            change = output_deltas[k] * self.ah[j]		# 求 a(_j  ^((L)))δ(_i      ^((L+1)))  项
                            self.wo[j][k] = self.wo[j][k] + lr * change 	# 用于梯度下降算法
            
                    # 更新输入层权重
                    for i in range(self.ni):		# 与上同理
                        for j in range(self.nh):
                            change = hidden_deltas[j] * self.ai[i]
                            self.wi[i][j] = self.wi[i][j] + lr * change
            
                    # 计算误差
                    error = 0.0		# 每调用一次先归零，不停地进行迭代
                    error += 0.5 * (targets[k] - self.ao[k]) ** 2		# 神经网络的性能度量，其实就是均方误差少了除以整数，但不影响度量
                    return error	# 返回此时训练集的误差
            
                #用测试集来测试训练过后的神经网络，输出准确率
                def test(self, patterns):		# patterns为测试样本数据
                    for p in patterns:
                        # target = State[(p[1].index(1))] 		# p[1].index(1)：返回p[1]列表中值为1的序号；而这序号正对应字典中的键值。target存储的是样本实际种类类别
                        result = self.update(p[0])		#输入测试样本的特征值，返回的是对每种种类预测的概率
                        index = result.index(max(result))		 # 求出result列表中最大数值的序号
                    # print(p[0], ':', target, '->', State[index])		# 输出测试样本的特征值，实际输出，预测输出
                
                    return index
            
                #输出训练过后神经网络的权重矩阵
                def weights(self):
                    print('输入层权重:')
                    for i in range(self.ni):
                        print(self.wi[i])
                    print()
                    print('输出层权重:')
                    for j in range(self.nh):
                        print(self.wo[j])
            
                #用训练集训练神经网络
                def train(self, patterns, iterations=1000, lr=0.1):		# patterns:训练集数据 iterations:迭代次数，默认值为1000；lr: 梯度下降算法中的学习速率(learning rate)
                    for i in range(iterations):	  	#这里默认规定了梯度下降算法迭代的次数
                        error = 0.0		#记录每次迭代后的误差
                        for p in patterns:		#将训练集的数据依次喂入神经网络输入层
                            inputs = p[0]		# inputs获取该样本的特征值
                            targets = p[1]		# targets获取该样本的种类类别
                            self.update(inputs)	# 前向传播，激活神经网络每个节点
                            error = error + self.backPropagate(targets, lr)	# 反向传播，算出每个节点的误差，并通过反向传播算法更新权重，算出此时的样本误差
                        # if i % 100 == 0:		# 方便我们观看样本误差变化情况
                        #     print('error: %-.9f' % error)



            #为神经网络建立合适的数据结构
            data_train=[]
            for i in range(len(x_train)):	  # 将数据保存在列表中，方便后面操作
                    ele = []		# 定义了一个空列表ele
                    ele.append(list(x_train[i]))		# ele列表第一个元素保存该样本特征值
                    if y_train[i] == 0: 	# 用向量表示种类类型
                        ele.append([1, 0, 0, 0])		# ele列表第二个元素该样本的种类
                    elif y_train[i]==1:
                        ele.append([0, 1, 0, 0])		
                    elif y_train[i]==2:
                        ele.append([0, 0, 1, 0])
                    else:
                        ele.append([0, 0, 0, 1])
                    data_train.append(ele)		# 将ele列表作为一个元素加入到data列表中

            #实例化NN
            bp = NN(7, 7, 4)			   #实例化NN类，同时调用构造函数建立bp神经网络结构
            bp.train(data_train, iterations=100)		# 调用类中方法train(),通过反向传播算法训练权重 
            #训练集准确率
            for i in range(5):
                accuracy[i]=format(accuracy[i], '.4f')
            self.cv.create_text(288,180, text=accuracy[1])
            self.cv.create_text(288,220, text=accuracy[2])
            self.cv.create_text(288,260, text=accuracy[3])
            self.cv.create_text(288,300, text=accuracy[4])
            self.cv.create_text(288,94,  text=accuracy[0])
            self.cv.create_text(288,410, text="----")
            #时钟
            self.cv.create_text(625, 430, text="/")
            self.cv.create_text(640, 430, text=len(y_test))
            self.cv.create_text(655, 430, text="S")
            self.cv.update()
            
            # predict
            #错误率计算参数
            num_NN      =   0
            num_knn     =   0
            num_svm     =   0
            num_bayes   =   0
            num_tree    =   0
            num_gmm     =   0
            #读取数据
            l=len(x_test)
            for k in range (l):
                s=self.cv.create_text(610, 430, text=k)
                self.cv.update()
                #归一化
                x_test_standard = standarscaler.transform(x_test[k:k+1])#x_text[0]就不行，维数不对
                #NN predict
                ele = []		# 定义了一个空列表ele
                ele.append(list(x_test_standard[0]))	#要写成[0],否则格式不对	
                if y_test[k] == 0: 	# 用向量表示种类类型
                    ele.append([1, 0, 0, 0])		# ele列表第二个元素该样本的种类
                elif y_test[k]==1:
                    ele.append([0, 1, 0, 0])		
                elif y_test[k]==2:
                    ele.append([0, 0, 1, 0])
                else:
                    ele.append([0, 0, 0, 1])
                data_test  = [] #调整格式
                data_test.append(ele)
                p  =  bp.test(data_test)	# 调用类中方法test(),用测试集来测试训练过后的神经网络
                bpnn    =   self.cv.create_text(440, 410, text=State[p])
                self.cv.update()
                if p!=y_test[k]:
                    num_NN=num_NN+1

                #KNN predict
                p=knn_clf.predict(x_test_standard)
                knn=self.cv.create_text(440, 180, text=State[p[0]])
                self.cv.update()
                if p!=y_test[k]:
                    num_knn=num_knn+1

                #SvM predict
                p=svm_clf.predict(x_test_standard)
                svm1=self.cv.create_text(440, 220, text=State[p[0]])
                self.cv.update()
                if p!=y_test[k]:
                    num_svm=num_svm+1

                #BAYES predict
                p=gnb_clf.predict(x_test_standard)
                bayes=self.cv.create_text(440, 260, text=State[p[0]])
                self.cv.update()
                if p!=y_test[k]:
                    num_bayes=num_bayes+1

                #TREE predict
                p=tree_clf.predict(x_test_standard)
                tree1=self.cv.create_text(440, 300, text=State[p[0]])
                self.cv.update()
                if p!=y_test[k]:
                    num_tree=num_tree+1
                #GMM 
                t=gmm.predict(x_test_standard)
                num_gmm=0
                if t==ann[0]:
                    gmm1=self.cv.create_text(440, 94, text=State[0])
                    if y_test[k]!=0:
                        num_gmm=num_gmm+1
                elif t==ann[1]:
                    gmm1=self.cv.create_text(440, 94, text=State[1])
                    if y_test[k]!=1:
                        num_gmm=num_gmm+1
                elif t==ann[2]:
                    gmm1=self.cv.create_text(440, 94, text=State[2])
                    if y_test[k]!=2:
                        num_gmm=num_gmm+1
                else :
                    gmm1=self.cv.create_text(440, 94, text=State[3])
                    if y_test[k]!=3:
                        num_gmm=num_gmm+1
                self.cv.update()
                time.sleep(1)
                self.cv.delete(gmm1)
                self.cv.delete(knn)
                self.cv.delete(svm1)
                self.cv.delete(bayes)
                self.cv.delete(tree1)
                self.cv.delete(bpnn)
                self.cv.delete(s)

            #显示准确率
            num_NN=format(1-num_NN/l, '.4f')
            num_knn=format(1-num_knn/l, '.4f')
            num_svm=format(1-num_svm/l, '.4f')
            num_bayes=format(1-num_bayes/l, '.4f')
            num_tree=format(1-num_tree/l, '.4f')
            num_gmm=format(1-num_gmm/l, '.4f')
            #显示准确率
            self.cv.create_text(580, 410, text=num_NN)            
            self.cv.create_text(580, 180, text=num_knn)
            self.cv.create_text(580, 220, text=num_svm)
            self.cv.create_text(580, 260, text=num_bayes)
            self.cv.create_text(580, 300, text=num_tree)
            self.cv.create_text(580, 94,  text=num_gmm)
            self.cv.update()
            self.win.mainloop()


