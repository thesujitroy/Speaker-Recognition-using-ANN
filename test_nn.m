clear all;
close all;
pause(0.5);
n=5;   % no. of voice samples for each person
 %if want to change n, also change in bpntrain and bpntest.
 fs = 16000;    % Sampling rate
 intval = 3;    % Recording time interval in seconds
 len=fs*intval; %total length of voice sample
 stime=0.015;   %time duration in which voice is stationary
 
[fsize,osize,nwin]=calsize(stime,intval,len);   % to calculate frame sizes
 noc=40;    %no. of filters or channels  in mel filter bank
%%
[file,path]=uigetfile('*.wav','select .wav file'); % test data load
p12=[path file];
[voicein]= wavread(p12);   
voice_in=noise_remove(voicein,fs); % noise removal function calling
ip=preprocess(voice_in,fs,intval);  % preprocessing of data
powspc(1:floor(fsize/2),1:nwin)=0;
powspc=frm2fft(fsize,osize,nwin,ip);
mel(1:noc,1:floor(fsize/2))= 0;
mel=melfilter(fs,fsize,noc); % to cunstruct melfilter bank
mfcc(1:12,1:nwin)=0;
mfcc=melcep(mel,powspc,noc,fsize,nwin);% to find mfcc 
mfccn=postnorm(mfcc,nwin);
cb(1,:)=centr(mfccn);
data1=cb;
% load database
load db;
[r,c]=size(cd11);
n=1;
r=r*6;
s=floor(r/n);
d(s*n,s*n)=0;
d(1:n,1)=1;
for t1=2:s

    d(((t1-1)*n)+1:((t1-1)*n)+n,1:s*n)=circshift(d(((t1-2)*n)+1:((t1-2)*n)+n,1:s*n),[-1 1]);    
end;
%d=eye(r);%target or desired data
mx=0;
%while(mx<0.6)
load nnnet;
op = sim(net,cb');
y=op';

for fg=1:6
for ft=1:5
d1(fg,ft)=abs(sum(cb-cdb{1,fg}(ft,:)));
end
end
d1=d1';

for i=1:r
    outputs = sim(net,cb');
    y=outputs';
    j=num2str(i);
  %  plotregression(d(i,:),op,j)
    rgrsn(i)=d(i,1)./y(1,1);

end

%display(rgrsn);
%disply(rgrsn);
[mx,ind]=max(rgrsn);
%end
ind1=find(d1<0.000001);
 fprintf('it matched with speaker number %d\n\n',ceil(ind1/5));
