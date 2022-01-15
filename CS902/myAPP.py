#-*- coding: utf-8 -*
from Tkinter import *

class myAPP:
    a = ['United-States,', 'Ireland,', 'Germany,', 'Japan,', 'England,', 'Italy,', 'Canada,', 'Portugal,',
         'Scotland,', 'Greece,', 'Outlying-US(Guam-USVI-etc),']

    def __init__ (self,inter):
        self.interface=inter

    def prepare(self,s):
        for ch in ",.":
            s.replace(ch," ")
        return s

    def drawBar(self,c,v,t):
        k = len(v)
        n=v[k-1]#总人数
        gap=560/(k-2)
        i=0

        while (k/2-i):
            x0 = 450+(i)*gap       # 某指标a类高收入柱的左上角x
            y0 = 200-v[i]*200/n      # 某指标a类高收入柱的左上角y
            x1 = x0+20               # 某指标a类高收入柱的右下角x
            y1 = 200                 # 某指标a类高收入柱的右下角y
            c.create_rectangle(x0,y0,x1,y1,fill='red')    # 某指标a类高收入柱
            c.create_text(x0,204,text=t[i],anchor=NW)

            y2 = y0-v[i+k/2]*200/n        # 某指标a类低收入柱的左上角y
            y3 = y0                  # 某指标a类低收入柱的右下角y
            c.create_rectangle(x0,y2,x1,y3,fill='green')  # 某指标a类低收入柱
            pct = unicode("%d%%" % (100*v[i+k/2]/(v[i]+v[i+k/2])),'gbk')    # 某指标a类低收入占比
            c.create_text(x0,y2-13,text=pct,anchor=NW)
            i=i+1
        c.create_text(460,220,text="[The Numbers represent the percentage of \nlow-income people in this category.]",anchor=NW)


    def callback(self,event):

        # print(event.x,event.y)
        if event.x>227 and event.x<340:
            for i in range (6):
                if event.y>37+24*i and event.y<50+24*i:
                    self.drawpie(self.cv,datas,t,i)



    def drawpie(self,cv,datas,t,p):
        k=len(datas)
        if p<k/2:
            a=datas[p]
            b=datas[p+k/2]
            cc = (200,250,320,370)
            ea=360.0*a/(a+b)
            eb=359.9-ea
            sa=0
            sb=ea
            pie0 = self.cv.create_arc(cc,start=sa,extent=ea,fill="SandyBrown")
            pie1 = self.cv.create_arc(cc,start=sb,extent=eb,fill="PaleGreen")
            self.cv.create_rectangle(20,170,150,336,outline="white",fill="white")
            self.cv.create_rectangle(70,290,90,300,fill="SandyBrown")
            self.cv.create_rectangle(70,310,90,320,fill="PaleGreen")
            self.cv.create_text(20,290,text="HIGH",anchor=NW)
            self.cv.create_text(20,310,text="LOW",anchor=NW)
            self.cv.create_text(20,270,text=t[p],anchor=NW)
            self.cv.create_text(110,288,text="%5.1f%%"%(100.0*a/(a+b)),anchor=N)
            self.cv.create_text(110,308,text="%5.1f%%"%(100.0*b/(a+b)),anchor=N)




    def getData(self):
        age=[0]*6
        workClass=[0]*4
        edu=[0]*3
        marry=[0]*3
        nation=[0]*5
        country=[0]*2
        gender=[0]*2

        f = open("data.txt","r")
        s=f.readline()

        while s!="":
            s = self.prepare(s)
            w=s.split()


            if int(w[0][0]+w[0][1])<20:             # 指标age：0:U20，1:20-30,2:30-40以此类推
                age[0]=age[0]+1                     # age[5]：大于60
            elif int(w[0][0]+w[0][1])<30:
                age[1]=age[1]+1
            elif int(w[0][0]+w[0][1])<40:
                age[2]=age[2]+1
            elif int(w[0][0]+w[0][1])<50:
                age[3]=age[3]+1
            elif int(w[0][0]+w[0][1])<60:
                age[4]=age[4]+1
            else:
                age[5]=age[5]+1


            if w[13]in self.a:                          # 指标country：0发达，1发展中
                country[0]=country[0]+1
            else:
                country[1]=country[1]+1

            if "Fe"in w[9]:                          # 指标gender：0female，1male
                gender[0]=gender[0]+1
            else:
                gender[1]=gender[1]+1

            if "Nev" in w[5] :                     # 指标marriage：0没结过婚1婚姻幸福2婚姻不幸
                marry[0]=marry[0]+1
            elif "civ" in w[5] or "AF"in w[5] :
                marry[1]=marry[1]+1
            else :
                marry[2]=marry[2]+1


            if "gov"in w[1]:                        # 指标workClass：0政府，1无企业，2个体，3企业
                workClass[0]=workClass[0]+1
            elif"not" in w[1]:
                workClass[1]=workClass[1]+1
            elif "Private" in w[1]:
                workClass[2]=workClass[2]+1
            else:
                workClass[3]=workClass[3]+1


            if ("Bac"in w[3] or "Mas"in w[3] or"Doc" in w[3]):
                edu[0]=edu[0]+1                    # 指标edu：0学士及以上，1高中以上学士以下，2中学及以下
            elif ("HS"in w[3] or "Ass"in w[3] or "Som" in w[3] or "Pro"in w[3]):
                edu[1]=edu[1]+1
            else:
                edu[2]=edu[2]+1

            if "Whi"in w[8]:                       # 指标nation：0白，1黑，2亚洲，3印第安，4其他
                nation[0]=nation[0]+1
            elif "Bla"in w[8]:
                nation[1]=nation[1]+1
            elif "Asi"in w[8]:
                nation[2]=nation[2]+1
            elif "Ame"in w[8]:
                nation[3]=nation[3]+1
            else:
                nation[4]=nation[4]+1
            s=f.readline()
        SUM=country[0]+country[1]
        return age,workClass,edu,marry,nation,country,gender,SUM

    def draw(self,v,n,SUM):
        f = open("data.txt","r")
        s=f.readline()

        self.cv.pack()
        bb = (90,40,210,160)

        if n==0:#age

            datas=[0]*12
            e=[0]*12
            se=[0]*12
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if int(w[0][0]+w[0][1])<20:
                        datas[0]=datas[0]+1
                    elif int(w[0][0]+w[0][1])<30:
                        datas[1]=datas[1]+1
                    elif int(w[0][0]+w[0][1])<40:
                        datas[2]=datas[2]+1
                    elif int(w[0][0]+w[0][1])<50:
                        datas[3]=datas[3]+1
                    elif int(w[0][0]+w[0][1])<60:
                        datas[4]=datas[4]+1
                    else:
                        datas[5]=datas[5]+1
                s=f.readline()
            for i in range (6):
                datas[6+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (12):
                e[i]=360.0*datas[i]/SUM
                if i<11:
                    se[i+1]=se[i]+e[i]
    #绘制饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="Orange")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="LightCoral")
            pie4 = self.cv.create_arc(bb,start=se[4],extent=e[4],fill="red")
            pie5 = self.cv.create_arc(bb,start=se[5],extent=e[5],fill="FireBrick")
            pie6 = self.cv.create_arc(bb,start=se[6],extent=e[6],fill="green")
            pie7 = self.cv.create_arc(bb,start=se[7],extent=e[7],fill="PaleGreen")
            pie8 = self.cv.create_arc(bb,start=se[8],extent=e[8],fill="blue")
            pie9 = self.cv.create_arc(bb,start=se[9],extent=e[9],fill="LightBlue")
            pie10= self.cv.create_arc(bb,start=se[10],extent=e[10],fill="gray")
            pie11= self.cv.create_arc(bb,start=se[11],extent=e[11],fill="Honeydew")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(260,40+48,280,50+48,fill="Orange")
            self.cv.create_rectangle(260,40+72,280,50+72,fill="LightCoral")
            self.cv.create_rectangle(260,40+96,280,50+96,fill="red")
            self.cv.create_rectangle(260,40+120,280,50+120,fill="FireBrick")

            self.cv.create_rectangle(320,40,340,50,fill="green")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="PaleGreen")
            self.cv.create_rectangle(320,40+48,340,50+48,fill="blue")
            self.cv.create_rectangle(320,40+72,340,50+72,fill="LightBlue")
            self.cv.create_rectangle(320,40+96,340,50+96,fill="gray")
            self.cv.create_rectangle(320,40+120,340,50+120,fill="Honeydew")
    #显示百分比
            for i in range (6):
                self.cv.create_text(293,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+6]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(227,12,text="age",anchor=N)

            t=["<20","20-30","30-40","40-50","50-60",">60"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)
            datas.append(SUM)

            return datas,t

        elif n==1:#workClass
            datas=[0]*8
            e=[0]*8
            se=[0]*8
            print v
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if "gov" in  w[1]:
                        datas[0]=datas[0]+1
                    elif "not" in w[1]:
                        datas[1]=datas[1]+1
                    elif "Pri" in w[1]:
                        datas[2]=datas[2]+1
                    else:
                        datas[3]=datas[3]+1
                s=f.readline()
            for i in range (4):
                datas[4+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (8):
                e[i]=360.0*datas[i]/SUM
                if i<7:
                    se[i+1]=se[i]+e[i]
    #绘制饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="red")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="orange")
            pie4 = self.cv.create_arc(bb,start=se[4],extent=e[4],fill="green")
            pie5 = self.cv.create_arc(bb,start=se[5],extent=e[5],fill="LightBlue")
            pie4 = self.cv.create_arc(bb,start=se[6],extent=e[6],fill="gray")
            pie5 = self.cv.create_arc(bb,start=se[7],extent=e[7],fill="blue")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(260,40+48,280,50+48,fill="red")
            self.cv.create_rectangle(260,40+72,280,50+72,fill="orange")

            self.cv.create_rectangle(320,40,340,50,fill="green")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="lightBlue")
            self.cv.create_rectangle(320,40+48,340,50+48,fill="gray")
            self.cv.create_rectangle(320,40+72,340,50+72,fill="blue")
    #显示百分比
            for i in range (4):
                self.cv.create_text(297,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+4]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(223,12,text="WorkClass",anchor=N)

            t=["gov","no inc","private","inc"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)


            datas.append(SUM)
            return datas,t

        elif n==2:#edu
            datas=[0]*6
            e=[0]*6
            se=[0]*6
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if ("Bac"in w[3] or "Mas"in w[3] or"Doc" in w[3]):
                        datas[0]=datas[0]+1
                    elif ("HS"in w[3] or "Ass"in w[3] or "Som" in w[3] or "Pro"in w[3]):
                        datas[1]=datas[1]+1
                    else:
                        datas[2]=datas[2]+1
                s=f.readline()
            for i in range (3):
                datas[3+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (6):
                e[i]=360.0*datas[i]/SUM
                if i<5:
                    se[i+1]=se[i]+e[i]
    #绘制饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="red")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="gray")
            pie4 = self.cv.create_arc(bb,start=se[4],extent=e[4],fill="green")
            pie5 = self.cv.create_arc(bb,start=se[5],extent=e[5],fill="LightBlue")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(260,40+48,280,50+48,fill="red")

            self.cv.create_rectangle(320,40,340,50,fill="gray")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="green")
            self.cv.create_rectangle(320,40+48,340,50+48,fill="LightBlue")
    #显示百分比
            for i in range (3):
                self.cv.create_text(297,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+3]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(227,12,text="edu",anchor=N)

            t=["HIGH","MID","LOW"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)
            datas.append(SUM)
            return datas,t


        elif n==3:#marry
            datas=[0]*6
            e=[0]*6
            se=[0]*6
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if "Nev" in w[5] :
                        datas[0]=datas[0]+1
                    elif "civ" in w[5] or "AF"in w[5] :
                        datas[1]=datas[1]+1
                    else :
                        datas[2]=datas[2]+1
                s=f.readline()
            for i in range (3):
                datas[3+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (6):
                e[i]=360.0*datas[i]/SUM
                if i<5:
                    se[i+1]=se[i]+e[i]
    #绘制饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="red")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="gray")
            pie4 = self.cv.create_arc(bb,start=se[4],extent=e[4],fill="green")
            pie5 = self.cv.create_arc(bb,start=se[5],extent=e[5],fill="LightBlue")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(260,40+48,280,50+48,fill="red")

            self.cv.create_rectangle(320,40,340,50,fill="gray")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="green")
            self.cv.create_rectangle(320,40+48,340,50+48,fill="LightBlue")
    #显示百分比
            for i in range (3):
                self.cv.create_text(297,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+3]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(223,12,text="marriage",anchor=N)
            t=["never","happy","fail"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)
            datas.append(SUM)
            return datas,t


        elif n==4:#nation
            datas=[0]*10
            e=[0]*10
            se=[0]*10
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if "Whi"in w[8]:
                        datas[0]=datas[0]+1
                    elif "Bla"in w[8]:
                        datas[1]=datas[1]+1
                    elif "Asi"in w[8]:
                        datas[2]=datas[2]+1
                    elif "Ame"in w[8]:
                        datas[3]=datas[3]+1
                    else:
                        datas[4]=datas[4]+1
                s=f.readline()
            for i in range (5):
                datas[5+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (10):
                e[i]=360.0*datas[i]/SUM
                if i<9:
                    se[i+1]=se[i]+e[i]
    #绘制饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="Orange")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="LightCoral")
            pie4 = self.cv.create_arc(bb,start=se[4],extent=e[4],fill="red")
            pie5 = self.cv.create_arc(bb,start=se[5],extent=e[5],fill="gray")
            pie6 = self.cv.create_arc(bb,start=se[6],extent=e[6],fill="green")
            pie7 = self.cv.create_arc(bb,start=se[7],extent=e[7],fill="PaleGreen")
            pie8 = self.cv.create_arc(bb,start=se[8],extent=e[8],fill="blue")
            pie9 = self.cv.create_arc(bb,start=se[9],extent=e[9],fill="LightBlue")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(260,40+48,280,50+48,fill="Orange")
            self.cv.create_rectangle(260,40+72,280,50+72,fill="LightCoral")
            self.cv.create_rectangle(260,40+96,280,50+96,fill="red")

            self.cv.create_rectangle(320,40,340,50,fill="gray")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="green")
            self.cv.create_rectangle(320,40+48,340,50+48,fill="PaleGreen")
            self.cv.create_rectangle(320,40+72,340,50+72,fill="blue")
            self.cv.create_rectangle(320,40+96,340,50+96,fill="LightBlue")
    #显示百分比
            for i in range (5):
                self.cv.create_text(297,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+5]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(227,12,text="nation",anchor=N)
            t=["White","Black","Asia","Indian","else"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)

            datas.append(SUM)
            return datas,t

        elif n==5:#country
            datas=[0]*4
            e=[0]*4
            se=[0]*4
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if w[13]in self.a:
                        datas[0]=datas[0]+1
                    else:
                        datas[1]=datas[1]+1
                s=f.readline()
            for i in range (2):
                datas[2+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (4):
                e[i]=360.0*datas[i]/SUM
                if i<3:
                    se[i+1]=se[i]+e[i]

    #饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="green")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="Lightblue")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(320,40,340,50,fill="green")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="Lightblue")

    #显示百分比
            for i in range (2):
                self.cv.create_text(297,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+2]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(223,12,text="country",anchor=N)
            t=["developed","developing"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)

            datas.append(SUM)
            return datas,t


        elif n==6:#gender
            datas=[0]*4
            e=[0]*4
            se=[0]*4
            while s!="":
                s = self.prepare(s)
                w=s.split()
                if ">" in w[14]:
                    if "Fe"in w[9]:
                        datas[0]=datas[0]+1
                    else:
                        datas[1]=datas[1]+1
                s=f.readline()
            for i in range (2):
                datas[2+i]=v[i]-datas[i]

    #计算角度及百分比
            for i in range (4):
                e[i]=360.0*datas[i]/SUM
                if i<3:
                    se[i+1]=se[i]+e[i]
    #饼图
            pie0 = self.cv.create_arc(bb,start=se[0],extent=e[0],fill="SandyBrown")
            pie1 = self.cv.create_arc(bb,start=se[1],extent=e[1],fill="Tomato")
            pie2 = self.cv.create_arc(bb,start=se[2],extent=e[2],fill="green")
            pie3 = self.cv.create_arc(bb,start=se[3],extent=e[3],fill="Lightblue")
    #图例
            self.cv.create_rectangle(260,40,280,50,fill="SandyBrown")
            self.cv.create_rectangle(260,40+24,280,50+24,fill="Tomato")
            self.cv.create_rectangle(320,40,340,50,fill="green")
            self.cv.create_rectangle(320,40+24,340,50+24,fill="Lightblue")

    #显示百分比
            for i in range (2):
                self.cv.create_text(297,37+24*i,text="%5.1f%%"%(100.0*datas[i]/SUM),anchor=N)
                self.cv.create_text(358,37+24*i,text="%5.1f%%"%(100.0*datas[i+2]/SUM),anchor=N)

    #显示解释文字
            self.cv.create_text(275,12,text="HIGH",anchor=N)
            self.cv.create_text(335,12,text="LOW",anchor=N)
            self.cv.create_text(223,12,text="gender",anchor=N)
            t=["female","male"]
            for i in range (len(t)):
                self.cv.create_text(227,37+24*i,text=t[i],anchor=N)

            datas.append(SUM)
            return datas,t


    def run(self):


        global datas, t
        datas = []
        t = []
        age, workClass, edu, marry, nation, country, gender, SUM = self.getData()



        while True :
            gFlag,factor=self.interface.getInfo()

            if gFlag:
                break

            if factor == 'AGE':
                self.win = Tk()
                self.win.title("AGE")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(age, 0, SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()
            elif factor =='WorkClass':
                self.win = Tk()
                self.win.title("WorkClass")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(workClass,1,SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()
            elif factor =='EDU':
                self.win = Tk()
                self.win.title("EDU")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(edu,2,SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()
            elif factor =='Marriage':
                self.win = Tk()
                self.win.title("Marriage")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(marry,3,SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()
            elif factor=='Nation':
                self.win = Tk()
                self.win.title("Nation")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(nation,4,SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()
            elif factor== 'Country':
                self.win = Tk()
                self.win.title("Country")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(country,5,SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()
            elif factor =='Gender':
                self.win = Tk()
                self.win.title("Gender")
                self.cv = Canvas(self.win, width=800, height=450, bg="white")
                datas, t = self.draw(gender,6,SUM)
                self.drawBar(self.cv, datas, t)
                self.win.bind("<Button-1>", self.callback)
                self.win.mainloop()

