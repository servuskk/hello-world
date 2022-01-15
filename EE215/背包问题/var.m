%变异
%输入变量：choice，vari(变异概率)
%输出变量：变异以后的新种群newchoice
function [newchoice] = var(choice,vari)
[x,y] = size(choice);
%初始化新的组合
newchoice = choice;
for i = 1:x
    if(rand<vari)%发生变异
        m = round(rand*y);
        if m < 1
            m = 1;%处理随机数是0造成的越界问题
        end
        %变异0->1,1->0
        if newchoice(i,m) == 0
            newchoice(i,m) = 1;
        else
            newchoice(i,m) = 0;
        end
    end
end