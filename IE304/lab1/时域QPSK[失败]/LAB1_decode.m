function decoded_signal=LAB1_decode(signal)
n = size(signal,2);
decoded_signal = zeros(1,4*n/7);
H = [1 0 1 0 1 0 1;
     0 1 1 0 0 1 1;
     0 0 0 1 1 1 1];
 R = [
     0 0 1 0 0 0 0;
     0 0 0 0 1 0 0;
     0 0 0 0 0 1 0;
     0 0 0 0 0 0 1];
 r = zeros(3,1);
 for i = 1: n/7
     code = signal(7*(i-1)+1:7*i);
     f = mod(H*code',2);
     if(~isequal(f,r))
         for j = 1:7
             if(isequal(H(:,j),f))
                 code(j)=~code(j);
                 break;
             end
         end
     end
     decoded_signal(4*(i-1)+1:4*i) = mod((R*code'), 2)';
 end
 