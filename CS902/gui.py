#-*- coding: utf-8 -*
from Tkinter import *
class GUIInterface:
    def __init__(self):

        self.root=Tk()
        self.root.title("Income Analysis")


        self.qFlag=False
        self.factor=StringVar()
        self.factor.set('AGE')

        self.f = Frame(self.root)
        self.f.grid(row=0,column=0,rowspan=6,columnspan=3)

        self.r1 = Radiobutton(self.f, text='AGE',variable=self.factor,value='AGE')
        self.r2 = Radiobutton(self.f, text='WorkClass', variable=self.factor, value='WorkClass')
        self.r3 = Radiobutton(self.f, text='EDU', variable=self.factor, value='EDU')
        self.r4 = Radiobutton(self.f, text='Marriage', variable=self.factor, value='Marriage')
        self.r5 = Radiobutton(self.f, text='Nation', variable=self.factor, value='Nation')
        self.r6 = Radiobutton(self.f, text='Country', variable=self.factor, value='Country')
        self.r7 = Radiobutton(self.f, text='Gender', variable=self.factor, value='Gender')

        self.r1.grid(row=0, column=0,sticky=W)
        self.r2.grid(row=1, column=0,sticky=W)
        self.r3.grid(row=2, column=0,sticky=W)
        self.r4.grid(row=3, column=0,sticky=W)
        self.r5.grid(row=4, column=0,sticky=W)
        self.r6.grid(row=5, column=0,sticky=W)
        self.r7.grid(row=6, column=0,sticky=W)

        self.m = Menu(self.root)
        self.root.config(menu=self.m)
        self.m.add_command(label="Help", command=self.help)

        self.b = Button(self.root, text='Draw', command=self.quit, width=20)
        self.qb = Button(self.root,text='Quit',command=self.close, width=20)
        self.qb.grid(row=7,column=1)
        self.b.grid(row=7, column=0)

    def help(self):

        self.master = Tk()
        self.w = Canvas(self.master, width=330, height=230,bg="white")
        self.master.title("Introduction")
        self.w.create_text(20, 20, text="本程序用于分析收入与\n"
                                        "年龄、教育水平、工作性质、婚姻状况、国家发展程度、\n"
                                      "种族以及性别的关系，并用图表的形式展示结果。\n\n\n"
                                      "选择要分析的指标，双击“Draw”即可获得数据的图表,\n"
                                      "点击相应的图例可以获得该指标该分类下的饼图。",
                    anchor=NW)
        self.w.pack()
        mainloop()



    def quit(self):
        self.root.quit()

    def getInfo(self):
        self.root.mainloop()
        return self.qFlag,self.factor.get()

    def close(self):
        self.qFlag = True
        self.root.quit()
        self.root.destroy()
