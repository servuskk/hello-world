def prepare(s):
    for ch in ",.":
        s.replace(ch," ")
    return s
def main():
    f = open("data.txt","r")    
    s=f.readline()
    a=[]
    while s!="":
        s = prepare(s)
        w=s.split()

        if not w[0] in a:
            a.append(w[0])
            print w[0]
            
        s = f.readline()
    
main()
#0年龄，1工作，x，3教育程度，x，5婚姻状况，6工作性质，x，8种族，9性别，x，x，x，13国籍
