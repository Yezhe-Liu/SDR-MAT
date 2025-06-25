function sig_am = am_mod(sig_audio, Amp, fc, fs)

sig_audio = sig_audio.';
%时间长度为语音时间，采样点数为fs
t = linspace(0, (length(sig_audio)-1)/fs,length(sig_audio));                          
carrier = exp(1i*2*pi*fc*t);
 %已调信号
sig_am = (Amp+sig_audio).*carrier;

end

