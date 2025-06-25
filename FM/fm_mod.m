function sig_fm = fm_mod(sig_audio, Amp, fc, fs, kf)

sig_audio = sig_audio.';
%时间长度为语音时间，采样点数为fs
t = linspace(0, (length(sig_audio)-1)/fs,length(sig_audio));                          

%求信号x(t)的积分
s_int = cumsum(sig_audio)/fs;
%调频信号
sig_fm_i = Amp*cos(2*pi*fc*t + 2*pi*kf*s_int);                          
sig_fm_q = Amp*sin(2*pi*fc*t + 2*pi*kf*s_int);
sig_fm = sig_fm_i+1i*sig_fm_q;
end

