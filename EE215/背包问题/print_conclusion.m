%打印结果
%输入：最优解矩阵
function print_conclusion(con)
%下标
bag=find(con==1);
%对应的重量、体积、价值
global w vol v;
con_w=w(bag);
con_vol=vol(bag);
con_v=v(bag);
%总重量、总体积、总价值
sum_w=sum(con_w);
sum_vol=sum(con_vol);
sum_v=sum(con_v);

disp(['序号',num2str(bag)])
disp(['重量',num2str(con_w)])
disp(['体积',num2str(con_vol)])
disp(['价值',num2str(con_v)])
disp(['总重量',num2str(sum_w)])
disp(['总体积',num2str(sum_vol)])
disp(['总价值',num2str(sum_v)])
end