%����
%���������choice��vari(�������)
%��������������Ժ������Ⱥnewchoice
function [newchoice] = var(choice,vari)
[x,y] = size(choice);
%��ʼ���µ����
newchoice = choice;
for i = 1:x
    if(rand<vari)%��������
        m = round(rand*y);
        if m < 1
            m = 1;%�����������0��ɵ�Խ������
        end
        %����0->1,1->0
        if newchoice(i,m) == 0
            newchoice(i,m) = 1;
        else
            newchoice(i,m) = 0;
        end
    end
end