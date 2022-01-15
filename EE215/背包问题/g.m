%适应度计算
%输入：当前种群矩阵
%输出：每个个体对应的value
function value=g(choice)
global v vol w 
value=[];
[x,~]=size(choice);
for i=1:x
    %判断容量是否符合要求
    vol_0=sum(vol(choice(i,:)==1));
    if vol_0>95
    value=[value,1];
    else
        %判断重量是否符合要求
        w_0=sum(w(choice(i,:)==1));
        if w_0>86
            value=[value,1];
        else
            %如果都符合要求，计算价值
            value=[value,sum(v(choice(i,:)==1))];
        end
    end
end