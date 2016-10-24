function [sig] = EEGfilter(sig,Fs,type)

%transpose input if need be.
if (size(sig,1)<size(sig,2))
    sig=sig';
end


% if IIR
if(type==1)

Hd = HPF(Fs,type);
for i = 1:size(sig,2)
    sig(:,i)=filtfilt(Hd.sosMatrix,Hd.ScaleValues, sig(:,i));
end
Hd = LPF2(Fs,type);
for i = 1:size(sig,2)
    sig(:,i)=filtfilt(Hd.sosMatrix,Hd.ScaleValues, sig(:,i));
end

end


%if FIR
if(type==2)
Hd = HPF(Fs,type);
for i = 1:size(sig,2)
    sig(:,i)=filtfilt(Hd.Numerator,1, sig(:,i));
end
Hd = LPF2(Fs,type);
for i = 1:size(sig,2)
    sig(:,i)=filtfilt(Hd.Numerator,1, sig(:,i));
end  
end

