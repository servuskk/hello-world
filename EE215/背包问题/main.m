%��ʼ����Ⱥ
%��Ⱥ��С
num=32;
%ѭ������
n_max=32;
%������ex
exchange=0.9;
%������var
vari=0.3;
%��һ�ε�ѡ��:ÿ����һ�����壬������Ⱦɫ�峤��
choice=round(rand(num,16));
%�õ���������
get_data;
%��ʼѭ��
for j=1:n_max     
    %������Ӧ��
    value=g(choice);
    %����Ȩֵ����ѡ��
    choice=selection(choice,value);
    %����
    choice=ex(choice,exchange);
    %����
    choice=var(choice,vari);
end
%������Ӧ��
value=g(choice);
%�˴εõ������Ž�
con_0=choice(value==max(value),:);
%ȥ���ظ�����
con_unique = unique(con_0,'rows');
%�õ��˴ε����Ž�
[x,~]=size(con_unique);
disp(['���ι��õ�',num2str(x),'�����Ž�'])
%������εõ������в�ͬ�����Ž�
for i=1:x
    disp(['��',num2str(i),'��:'])
    print_conclusion(con_unique(i,:))
end
    
        

