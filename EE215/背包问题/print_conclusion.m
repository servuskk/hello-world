%��ӡ���
%���룺���Ž����
function print_conclusion(con)
%�±�
bag=find(con==1);
%��Ӧ���������������ֵ
global w vol v;
con_w=w(bag);
con_vol=vol(bag);
con_v=v(bag);
%����������������ܼ�ֵ
sum_w=sum(con_w);
sum_vol=sum(con_vol);
sum_v=sum(con_v);

disp(['���',num2str(bag)])
disp(['����',num2str(con_w)])
disp(['���',num2str(con_vol)])
disp(['��ֵ',num2str(con_v)])
disp(['������',num2str(sum_w)])
disp(['�����',num2str(sum_vol)])
disp(['�ܼ�ֵ',num2str(sum_v)])
end