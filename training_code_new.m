
 n=5;   % no. of voice samples for each person
 %if want to change n, also change in bpntrain and bpntest.
 fs = 16000;    % Sampling rate
 intval = 3;    % Recording time interval in seconds
 len=fs*intval; %total length of voice sample
 stime=0.015;   %time duration in which voice is stationary
 
[fsize,osize,nwin]=calsize(stime,intval,len);   % to calculate frame sizes
noc=40;    %no. of filters or channels  in mel filter bank
cd(1:n,20)=0;%20 centroids from matrix
options = gaoptimset('Display','iter');
L=0;
U=255;

for t1=1:6
    for t2=1:5
    
    path=sprintf('C:\\Users\\Sujit Roy\\Downloads\\project_speech 1\\project_speech 1\\neural\\5db\\user%d\\s%d.wav',t1,t2);
    voicein=wavread(path);
    voice_in=noise_remove(voicein,fs); % noise removal function calling
    ip=preprocess(voice_in,fs,intval);  % preprocessing of data
    powspc(1:floor(fsize/2),1:nwin)=0;
    powspc=frm2fft(fsize,osize,nwin,ip);    %converting time domain to frequency domain
    mel(1:noc,1:floor(fsize/2))= 0;
    mel=melfilter(fs,fsize,noc);    %creating a mel filterbank
    mfcc(1:13,1:nwin)=0;
    mfcc=melcep(mel,powspc,noc,fsize,nwin); % to find mel frequency cepstrul coefficient
    mfcc=postnorm(mfcc,nwin);   %postnormalisatiom
    [x, fval]=ga(@fitness_fucn,1,[],[],[],[],L,U,[],[],options);
    [r,c]=size(mfcc);
    cd((n*(t2-1))+1,:)=centr(mfcc);
    cdt(t2,:)=centr(mfcc);
    end
    fin_data{t1}=cdt;
    cd11=cd;
end

cdb=fin_data;
     
    
save ('db','cdb','cd11'); % saving database cd in dbname.mat

%load db;%loading database file
cd1=cd11;
[r,c]=size(cd1);
n=1;
s=floor(r/n);
d(s*n,s*n)=0;
d(1:n,1)=1;
for t1=2:s

    d(((t1-1)*n)+1:((t1-1)*n)+n,1:s*n)=circshift(d(((t1-2)*n)+1:((t1-2)*n)+n,1:s*n),[-1 1]);    
end;
%d=eye(r);%target or desired data
net = newff(cd1',d',20);
net.divideParam.trainRatio = 100/100;  % Adjust as desired
net.divideParam.valRatio = 50/100;  % Adjust as desired
net.divideParam.testRatio = 15/100;  % Adjust as desired
net.trainParam.epochs = 50;
net.trainParam.goal = 0.00000000000000000000000001;
net = train(net,cd1',d');
save('nnnet','net');

