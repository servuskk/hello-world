function output = check_mark( mark )
% ����������壺������ mark ���
% ������ĳһ���ӵ���������� mark ��Ϊ�㣬˵����·�в�ͨ���������ֵ��
if min(min(sum(mark,3)))==0
 output=0; %ĳһ�� mark ȫ�㣬���޿�ѡ���ʾ��·��ͨ
else
 output=1; %��ʾδ�������в�ͨ�ļ���
end
end
