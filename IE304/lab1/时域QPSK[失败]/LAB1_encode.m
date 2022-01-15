function encoded_signal=LAB1_encode(signal)
n=size(signal,2);
%(7,4) hamming
encoded_signal = zeros(1,7*n/4);    
G = [1 1 0 1;
     1 0 1 1;
     1 0 0 0;
     0 1 1 1;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1];
 for i = 1: n/4
     encoded_signal(7*(i-1)+1:7*i)=mod(G*(signal(4*(i-1)+1:4*i))',2)';
 end
end
 