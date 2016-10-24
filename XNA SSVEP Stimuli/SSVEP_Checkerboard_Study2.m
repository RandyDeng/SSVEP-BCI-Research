% SSVEP checkerboard study

clear all;
%clc;


%% Pre-Processing 

%load data
[sig, state, parm]= load_data();

Fs= parm.SamplingRate.NumericValue;
numConditions = 20
channels= size(sig,2);


%filter
sig=EEGfilter(sig,Fs,1);

% filter another way. 
% use fdatool. export coeficients. use filt filt. 

%seperate out data
tmp=(Fs*60)-Fs*0.5;
for i=1:numConditions
indx= find(state.StimCondition==i);
tmpSig = sig(indx,:);
dataCube(:,:,i)= tmpSig(1:tmp,:);
%temporary{i}=tmpSig;
end

%get rid of last 2 conditions
dataCube=dataCube(:,:,1:end-2);
numConditions=size(dataCube,3);

%% Analysis
tmp = [18 8 4 7 10 2 16 9 1 14 5 17 15 13 6 11 3 12];
dataCube=dataCube(:,:,tmp);
Hwindow= hamming(Fs);


%window signal
for k=1:numConditions
for i=1:channels
    buffedSig(:,:,i,k) = buffer(squeeze(dataCube(:,i,k)),Fs,Fs*0.5,'nodelay');
end
end


% FFT Paramers
nfft=Fs;
L=Fs;

%compute FFT
fftSig=[];
for k=1:numConditions
    for i=16:channels
        for w=1:size(buffedSig,2)
            fftSig(:,w,k)=abs((fft(Hwindow.*squeeze(buffedSig(:,w,i,k)),nfft)/(Fs))).^2;
        end
    end
end
f = Fs/2*linspace(0,1,nfft/2+1);
f=f(1:30);

% grab only the useful frequency range
fftSig = fftSig(1:30,:,:);

fftAvg=squeeze(mean(fftSig,2));

titleArray{10}= '1x1 10Hz';
titleArray{11}= '2x2 10Hz';
titleArray{12}= '4x4 10Hz';
titleArray{13}= '8x8 10Hz';
titleArray{14}= '16x16 10Hz';
titleArray{15}= '32x32 10Hz';
titleArray{16}= '64x64 10Hz';
titleArray{17}= '128x128 10Hz';
titleArray{18}= '256x256 10Hz';

titleArray{1}= '1x1 6Hz';
titleArray{2}= '2x2 6Hz';
titleArray{3}= '4x4 6Hz';
titleArray{4}= '8x8 6Hz';
titleArray{5}= '16x16 6Hz';
titleArray{6}= '32x32 6Hz';
titleArray{7}= '64x64 6Hz';
titleArray{8}= '128x128 6Hz';
titleArray{9}= '256x256 6Hz';

titleArray{2,1}= '1x1';
titleArray{2,2}= '2x2';
titleArray{2,3}= '4x4';
titleArray{2,4}= '8x8';
titleArray{2,5}= '16x16';
titleArray{2,6}= '32x32';
titleArray{2,7}= '64x64';
titleArray{2,8}= '128x128';
titleArray{2,9}= '256x256';

%plot
figure; 
color = 'r';
cnt=1;
for i=1:18
subplot(3,3,cnt)
plot(f,2*fftAvg(:,i),color,'linewidth',1.5);
title(titleArray{2,cnt});
hold on;
cnt=cnt+1;
if(cnt==10)
    cnt=1;
    color='b';
end
ylim([0 max(max(fftAvg))])
legend('6Hz', '10Hz');
xlabel('Frequency (Hz)');
ylabel('Power');
end


%Averaging Bins
%6Hz
SixMatrix=fftAvg(4:8, 1:9)
y6=mean(SixMatrix, 1)
%10Hz
TenMatrix=fftAvg(8:12, 10:18)
y10=mean(TenMatrix, 1)

Myy6=fftSig(4:8,:,1:9);
Myy10=fftSig(8:12,:,10:18);
My6=squeeze(mean(Myy6,1))
My10=squeeze(mean(Myy10,1))
%BarGraph of Bins
Y=[];
Y(:,1)=y6;
Y(:,2)=y10;

figure('color',[1 1 1])
bar(Y,'grouped'); title('Comparison of 6Hz and 10Hz Power Values for Different Checkerboard Sizes')
legend('6Hz', '10Hz')
xlabel('Checkerboard Size')
ylabel('Average Bin Power')

%Statistical Analysis (Regression and T-Test)
%Regression Line
pixelArray=[1 2 4 8 16 32 64 128 256];
for i=1:9
    t(i)= pixelArray(i)^2;
end

%Perform regression
[r6,m6,b6]= regression(t,y6);
[r10,m10,b10]= regression(t,y10);

%Scatterplot
x = linspace(1,9,9);
p6=polyfit(x,y6,3);
p10=polyfit(x,y10,3);
f6=polyval(p6,x);
f10=polyval(p10,x);

figure('color',[1 1 1]); 
xlim([1 9])


scatter(x,y6,'b')
hold on
scatter(x,y10,'r')
plot(x,f6,'b')
hold on
plot(x,f10,'r')
xlabel('Checkerboard Size')
ylabel('Average Bin Power')
title('Comparison of 6Hz and 10Hz Power Values for Different Checkerboard Sizes')

%T-Test

%Paired sample ttest
load examgrades;

%[h,p,ci,stats] <Extra information if you want it>
%Ceckerboard sizes vs solid color (control)
for q=1:9
[h6]=ttest(My6(:,1),My6(:,q),'Alpha',0.05)
if (h==1)
    [h1]=ttest(My6(:,1),My6(:,q),'Tail','right','Alpha',0.05)
end
end 

for q=1:9
[h10]=ttest(My10(:,1),My10(:,q),'Alpha',0.05)
if (h==1)
    [h2]=ttest(My10(:,1),My10(:,q),'Tail','right','Alpha',0.05)
end
end 








