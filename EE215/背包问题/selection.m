%ѡ��selection
%���룺choice,value(��Ӧ��ֵ)
%�����ѡ���Ժ������Ⱥnewchoice
function [newchoice] = selection(choice,value)
[x,~] = size(choice);
%�õ����и���ļ�ֵ�ܺ�
totalvalue = sum(value);
%�����������ļ�ֵռ��
value_rate = value/totalvalue;
value_rate = cumsum(value_rate);%�������(�õ�0-1֮����ۻ���)
elem = sort(rand(x,1));%x��0-1�������С�������У����ڶԱ�����һ�е��ۻ������൱��ת�̵����
cur = 1;%Ŀǰ�ĸ���
i = 1;
while i<=x
    %�����ǰ���С���Ѵ���ĸ����ۼ�ռ�ȣ�����Ⱥ������һ����ǰ����
    if(elem(i))<value_rate(cur)
        newchoice(i,:)=choice(cur,:);
        i = i+1;
    else%������ƽʱ��������һ������
        cur=cur+1;
    end
end