import tkinter as tk
import io  
from PIL import Image, ImageTk  
# UI
class GUIInterface:             # 说明页面的结构
    def __init__(self):

        self.root=tk.Tk()
        self.root.title("Status Recognition")


        self.qFlag=False
        self.factor=tk.StringVar()
        self.factor.set('No.1')     #默认值

        self.f = tk.Frame(self.root)
        self.f.grid(row=0,column=0,rowspan=6,columnspan=3)

        self.r1 = tk.Radiobutton(self.f, text='No.1 ', variable=self.factor, value='NO.1')
        self.r2 = tk.Radiobutton(self.f, text='No.2 ', variable=self.factor, value='NO.2')
        self.r3 = tk.Radiobutton(self.f, text='No.3 ', variable=self.factor, value='NO.3')
        self.r4 = tk.Radiobutton(self.f, text='No.4 ', variable=self.factor, value='NO.4')
        self.r5 = tk.Radiobutton(self.f, text='No.5 ', variable=self.factor, value='NO.5')
        self.r6 = tk.Radiobutton(self.f, text='No.6 ', variable=self.factor, value='NO.6')
        self.r7 = tk.Radiobutton(self.f, text='No.7 ', variable=self.factor, value='NO.7')
        self.r8 = tk.Radiobutton(self.f, text='No.8 ', variable=self.factor, value='NO.8')
        self.r9 = tk.Radiobutton(self.f, text='No.9 ', variable=self.factor, value='NO.9')
        self.r10= tk.Radiobutton(self.f, text='No.10', variable=self.factor, value='NO.10')
        self.r11= tk.Radiobutton(self.f, text='No.11', variable=self.factor, value='NO.11')
        self.r12= tk.Radiobutton(self.f, text='No.12', variable=self.factor, value='NO.12')
        self.r13= tk.Radiobutton(self.f, text='No.13', variable=self.factor, value='NO.13')
        self.r14= tk.Radiobutton(self.f, text='No.14', variable=self.factor, value='NO.14')
        self.r15= tk.Radiobutton(self.f, text='No.15', variable=self.factor, value='NO.15')
        self.r16= tk.Radiobutton(self.f, text='No.16', variable=self.factor, value='NO.16')
        self.r17= tk.Radiobutton(self.f, text='No.17', variable=self.factor, value='NO.17')
        self.r18= tk.Radiobutton(self.f, text='No.18', variable=self.factor, value='NO.18')
        self.r19= tk.Radiobutton(self.f, text='No.19', variable=self.factor, value='NO.19')
        self.r20= tk.Radiobutton(self.f, text='No.20', variable=self.factor, value='NO.20')

        self.r1 .grid(row=0 , column=0,sticky=tk.W)
        self.r2 .grid(row=1 , column=0,sticky=tk.W)
        self.r3 .grid(row=2 , column=0,sticky=tk.W)
        self.r4 .grid(row=3 , column=0,sticky=tk.W)
        self.r5 .grid(row=4 , column=0,sticky=tk.W)
        self.r6 .grid(row=0 , column=1,sticky=tk.W)
        self.r7 .grid(row=1 , column=1,sticky=tk.W)
        self.r8 .grid(row=2 , column=1,sticky=tk.W)
        self.r9 .grid(row=3 , column=1,sticky=tk.W)
        self.r10.grid(row=4 , column=1,sticky=tk.W)
        self.r11.grid(row=0, column=2,sticky=tk.W)
        self.r12.grid(row=1, column=2,sticky=tk.W)
        self.r13.grid(row=2, column=2,sticky=tk.W)
        self.r14.grid(row=3, column=2,sticky=tk.W)
        self.r15.grid(row=4, column=2,sticky=tk.W)
        self.r16.grid(row=0, column=3,sticky=tk.W)
        self.r17.grid(row=1, column=3,sticky=tk.W)
        self.r18.grid(row=2, column=3,sticky=tk.W)
        self.r19.grid(row=3, column=3,sticky=tk.W)
        self.r20.grid(row=4, column=3,sticky=tk.W)
        self.m = tk.Menu(self.root)
        self.root.config(menu=self.m)
        self.m.add_command(label="Readme", command=self.help)

        self.b = tk.Button(self.root, text='Begin', command=self.quit, width=20)
        self.qb = tk.Button(self.root,text='Quit',command=self.close, width=20)
        self.qb.grid(row=7,column=1)
        self.b.grid(row=7, column=0)

    def help(self):

        self.master = tk.Toplevel()
        self.w = tk.Canvas(self.master, width=1112, height=690,bg="white")
        w_box = 1112 
        h_box = 690 
        pil_image = Image.open(r'3.jpg')  
        w, h = pil_image.size 
        pil_image_resized = self.resize(w, h, w_box, h_box, pil_image)
        tk_image = ImageTk.PhotoImage(pil_image_resized)  
        self.w.create_image(556,345,image = tk_image)
        self.master.title("Readme")
        # self.w.create_text(20, 20, text="本程序用于展示本组PRP的部分成果。\n"
        #                                 "我们分析了20名受试者\n首页可以根据编号选取一位受试者的数据。\n"

        #                               "使用了6种不同的机器学习方法，\n\n\n"
        #                               "选择要分析的受试者\n点击“Begin”即可获得数据的分析结果\n"
        #                                 ,
        #             anchor=tk.NW)
        self.w.pack()
        tk.mainloop()
    
    def quit(self):
        self.root.quit()

    def getInfo(self):
        self.root.mainloop()
        return self.qFlag,self.factor.get()

    def close(self):
        self.qFlag = True
        self.root.quit()
        self.root.destroy()
        #背景图缩放
    def resize(self,w, h, w_box, h_box, pil_image):
        f1 = 1.0*w_box/w  
        f2 = 1.0*h_box/h  
        factor = min([f1, f2])  
        width = int(w*factor)  
        height = int(h*factor)  
        return pil_image.resize((width, height), Image.ANTIALIAS) 