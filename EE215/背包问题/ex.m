%����exchange
%���룺choice��exchange(����ĸ���)
%���������������Ⱥnewchoice
function [newchoice] = ex(choice,exchange)
[x,y] = size(choice);
%��ʼ���µ�ѡ�����
newchoice = choice;
%����һ�齻��
for i = 1:2:x-1
    if(rand<exchange)%�������
        expoint = round(rand*y);%���ȷ��������λ��
        newchoice(i,:) = [choice(i,1:expoint),choice(i+1,expoint+1:y)];
        newchoice(i+1,:) = [choice(i+1,1:expoint),choice(i,expoint+1:y)];
    end
end