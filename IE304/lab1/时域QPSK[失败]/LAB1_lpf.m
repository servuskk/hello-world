function signal_dc=LAB1_lpf(signal,fc,fs)
signal=fft(signal);
len = size(signal,2);
b = len*(fc/fs);
signal(b/2:(len-b)/2)=0;
signal_dc = ifft(signal);
end



