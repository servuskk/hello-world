function next_mark = refresh_mark( groups,cur_mark,x,y,ptr )
%MARKING ����������壺��Ķ��壬cur_mark�������꣬�����꣬����
% ���С�������ָ���ĸ�������д���� ptr �󣬶� mark �����и���
Order=size(cur_mark,1);
next_mark =cur_mark;
next_mark(x,y,:)=0; %ͬһ����� mark ����
next_mark(x,:,ptr)=0; %ͬһ��ͬ�� mark ����
next_mark(:,y,ptr)=0; %ͬһ��ͬ�� mark ����
%ͬһ���ͬ�� mark ����
for g=1:size(groups,3)
 found=0;
 for i=1:Order
 if groups(i,:,g)==[x,y]
 found=1;
 end
 end
 if found==1
 for i=1:Order
 next_mark(groups(i,1,g),groups(i,2,g),ptr)=0;
 end
 end
end
next_mark(x,y,ptr)=1;
end
