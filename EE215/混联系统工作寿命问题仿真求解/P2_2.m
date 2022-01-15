tic
N=500000;
lambda=1/1000;
P01=1-exp(-lambda);
life=zeros(1,N);

for k=1:N
    state=1;%1代表正常0代表坏了
    A=1;
    B=1;
    C=1;
    D=1;
    E=1;
    while state
        if A
            A=(rand(1)>P01);
        end
        if B
            B=(rand(1)>P01);
        end
        if C
            C=(rand(1)>P01);
        end
        if D
            D=(rand(1)>P01);
        end  
        if E
            E=(rand(1)>P01);
        end
        state=(A&B|C&D|A&(E&D)|C&(E&B));
        life(k)=life(k)+1;
    end
end
m=mean(life)
toc