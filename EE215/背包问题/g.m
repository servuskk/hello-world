%��Ӧ�ȼ���
%���룺��ǰ��Ⱥ����
%�����ÿ�������Ӧ��value
function value=g(choice)
global v vol w 
value=[];
[x,~]=size(choice);
for i=1:x
    %�ж������Ƿ����Ҫ��
    vol_0=sum(vol(choice(i,:)==1));
    if vol_0>95
    value=[value,1];
    else
        %�ж������Ƿ����Ҫ��
        w_0=sum(w(choice(i,:)==1));
        if w_0>86
            value=[value,1];
        else
            %���������Ҫ�󣬼����ֵ
            value=[value,sum(v(choice(i,:)==1))];
        end
    end
end