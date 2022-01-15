%交叉exchange
%输入：choice，exchange(交叉的概率)
%输出：交叉后的新种群newchoice
function [newchoice] = ex(choice,exchange)
[x,y] = size(choice);
%初始化新的选择组合
newchoice = choice;
%两个一组交换
for i = 1:2:x-1
    if(rand<exchange)%如果交换
        expoint = round(rand*y);%随机确定交换的位置
        newchoice(i,:) = [choice(i,1:expoint),choice(i+1,expoint+1:y)];
        newchoice(i+1,:) = [choice(i+1,1:expoint),choice(i,expoint+1:y)];
    end
end