%初始化种群
%种群大小
num=32;
%循环次数
n_max=32;
%交换率ex
exchange=0.9;
%变异率var
vari=0.3;
%第一次的选择:每行是一个个体，列数是染色体长度
choice=round(rand(num,16));
%得到背包数据
get_data;
%开始循环
for j=1:n_max     
    %计算适应度
    value=g(choice);
    %根据权值重新选择
    choice=selection(choice,value);
    %交叉
    choice=ex(choice,exchange);
    %变异
    choice=var(choice,vari);
end
%计算适应度
value=g(choice);
%此次得到的最优解
con_0=choice(value==max(value),:);
%去掉重复的行
con_unique = unique(con_0,'rows');
%得到此次的最优解
[x,~]=size(con_unique);
disp(['本次共得到',num2str(x),'组最优解'])
%输出本次得到的所有不同的最优解
for i=1:x
    disp(['第',num2str(i),'组:'])
    print_conclusion(con_unique(i,:))
end
    
        

