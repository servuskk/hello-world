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
#0���䣬1������x��3�����̶ȣ�x��5����״����6�������ʣ�x��8���壬9�Ա�x��x��x��13����
