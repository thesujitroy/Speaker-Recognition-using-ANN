function final_data=noise_remove(y11,fs)
global y1
% [y11,fs]=wavread('s1.wav');
y1=[];
s=length(y11);
i=0:1.2500e-04:8;
i=i(1:s);

y1=[i' y11(:,1)];
sim('noise11'); 

final_data=outSig;
