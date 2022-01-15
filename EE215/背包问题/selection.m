%选择selection
%输入：choice,value(适应度值)
%输出：选择以后的新种群newchoice
function [newchoice] = selection(choice,value)
[x,~] = size(choice);
%得到所有个体的价值总和
totalvalue = sum(value);
%计算各个个体的价值占比
value_rate = value/totalvalue;
value_rate = cumsum(value_rate);%概率求和(得到0-1之间的累积量)
elem = sort(rand(x,1));%x个0-1随机数从小到大排列，用于对比上面一行的累积量，相当于转盘的面积
cur = 1;%目前的个体
i = 1;
while i<=x
    %如果当前面积小于已处理的个体累计占比，新种群里增加一个当前个体
    if(elem(i))<value_rate(cur)
        newchoice(i,:)=choice(cur,:);
        i = i+1;
    else%比例持平时，处理下一个个体
        cur=cur+1;
    end
end